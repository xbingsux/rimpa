// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
require('dotenv').config();

const prisma = new PrismaClient();

const listReward = async () => {
    const currentDate = new Date();
    let rewards = await prisma.reward.findMany({
        where: {
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
            active: true
        },
        include: {
            RedeemReward: true
        }
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

const redeemReward = async (idProfile, idReward) => {
    try {
        // ดึงข้อมูลโปรไฟล์
        const profile = await prisma.profile.findUnique({
            where: { id: idProfile },
            select: { points: true },
        });

        if (!profile) {
            throw new Error("Profile not found");
        }

        // ดึงข้อมูลรางวัล
        const reward = await rewardById(idReward);

        if (!reward) {
            throw new Error("Reward not found");
        }

        // ตรวจสอบว่า user แลกไปแล้วกี่ครั้ง (ถ้ามีการจำกัด)
        if (reward.max_per_user !== null && reward.max_per_user > 0) {
            const userRedeemedCount = await prisma.redeemReward.count({
                where: {
                    profileId: idProfile,
                    rewardId: idReward,
                },
            });

            if (userRedeemedCount >= reward.max_per_user) {
                throw new Error(`You have already redeemed this reward ${reward.max_per_user} times!`);
            }
        }


        // ตรวจสอบว่าวันที่ปัจจุบันอยู่ในช่วงที่สามารถแลกของรางวัลได้
        const now = new Date();
        if (now < new Date(reward.startDate) || now > new Date(reward.endDate)) {
            throw new Error("Reward is not available at this time");
        }

        // ตรวจสอบว่าสินค้าถูกแลกไปแล้วกี่ครั้ง
        const redeemedCount = await prisma.redeemReward.count({
            where: { rewardId: idReward },
        });

        if (redeemedCount >= reward.stock) {
            throw new Error("Reward is out of stock");
        }

        // ตรวจสอบว่ามีคะแนนพอหรือไม่
        const cost = Number(reward.cost);
        if (profile.points < cost) {
            throw new Error("Insufficient points");
        }

        // ทำธุรกรรมแบบป้องกัน race condition
        await prisma.$transaction(async (tx) => {
            // ลดคะแนน
            await tx.profile.update({
                where: { id: idProfile },
                data: { points: { decrement: reward.cost } },
            });

            // บันทึกการแลกรางวัล
            await tx.redeemReward.create({
                data: {
                    profileId: idProfile,
                    rewardId: idReward,
                    quantity: 1,
                    base_fee: 0,
                    addressId: null,
                    delivery: "Pickup",
                    status: "PAID",
                },
            });
        });
        return { status: "success", message: "Reward redeemed successfully" };
    } catch (error) {
        console.error(error);
        return { status: "error", message: error.message };
    }
};


module.exports = {
    listReward,
    rewardById,
    redeemReward
};