// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
require('dotenv').config();

const prisma = new PrismaClient();

const listReward = async (limit, popular) => {
    let orderBy = {};

    if (popular) {
        orderBy = {
            RedeemReward: {
                _count: popular
            }
        };
    }

    const currentDate = new Date();
    let rewards = await prisma.reward.findMany({
        where: {
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
            active: true
        },
        include: {
            RedeemReward: true
        },
        take: limit,
        orderBy: orderBy
    });

    return rewards;
};

const rewardById = async (id) => {
    const currentDate = new Date();
    const reward = await prisma.reward.findFirst({
        where: {
            id: id,
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
            active: true
        },
    })
    return reward
}

const redeemReward = async (userId, reward_id) => {

    // ดึงข้อมูลโปรไฟล์
    const qty = 1;
    const profile = await prisma.profile.findUnique({
        where: { user_id: userId },
        select: { points: true, id: true },
    });

    if (!profile) {
        throw new Error("Profile not found");
    }

    // ดึงข้อมูลรางวัล
    const reward = await rewardById(reward_id);

    if (!reward) {
        throw new Error("Reward not found");
    }

    // ตรวจสอบว่า user แลกไปแล้วกี่ครั้ง (ถ้ามีการจำกัด)
    if (reward.max_per_user !== null && reward.max_per_user > 0) {
        const redeemed = await prisma.redeemReward.findMany({
            where: { rewardId: reward_id, OR: [{ status: 'PAID' }, { status: 'DELIVERED' }] },
        });

        let userRedeemedCount = 0
        let redeemedCount = 0;

        redeemed.map((item) => {
            if (item.profileId == profile.id) {
                userRedeemedCount += item.quantity
            }
            redeemedCount += item.quantity
        })

        if (userRedeemedCount >= reward.max_per_user) {
            throw new Error(`You have already redeemed this reward ${reward.max_per_user} times!`);
        }

        // ตรวจสอบว่าวันที่ปัจจุบันอยู่ในช่วงที่สามารถแลกของรางวัลได้
        const now = new Date();
        if (now < new Date(reward.startDate) || now > new Date(reward.endDate)) {
            throw new Error("Reward is not available at this time");
        }

        // ตรวจสอบว่าสินค้าถูกแลกไปแล้วกี่ครั้ง
        if (redeemedCount >= reward.stock) {
            throw new Error("Reward is out of stock");
        }

        // ตรวจสอบว่ามีคะแนนพอหรือไม่
        const cost = Number(reward.cost);
        if (profile.points < (cost * qty)) {
            throw new Error("Insufficient points");
        }



        // ทำธุรกรรมแบบป้องกัน race condition
        const usePoint = (reward.cost * qty);

        let redeem = await prisma.redeemReward.findFirst({
            where: {
                profileId: profile.id,
                rewardId: reward_id,
                status: 'PENDING'
            }
        })

        // บันทึกการแลกรางวัล

        redeem = await prisma.redeemReward.upsert({
            where: {
                id: redeem.id | 0
            },
            create: {
                profileId: profile.id,
                rewardId: reward_id,
                quantity: qty,
                base_fee: 0,
                addressId: null,
                delivery: "Pickup",
                status: "PENDING",
                usedCoints: usePoint
            }, update: {
                createdAt: now
            }, include: {
                Profile: true,
                Reward: true
            }
        });


        return redeem;
    }

};

module.exports = {
    listReward,
    rewardById,
    redeemReward
};