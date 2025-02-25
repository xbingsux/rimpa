// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
require('dotenv').config();

const prisma = new PrismaClient();

const upsertReward = async (id, reward_name, description, startDate, endDate, img, stock, cost) => {
    const banner = await prisma.reward.upsert({
        where: { id: id || 0 },
        create: {
            reward_name: reward_name,
            description: description,
            startDate: startDate,
            endDate: endDate,
            img: img,
            stock: stock,
            cost: cost,
            paymentType: 'Point'
        },
        update: {
            reward_name: reward_name,
            description: description,
            startDate: startDate,
            endDate: endDate,
            img: img,
            stock: stock,
            cost: cost,
        }
    })
    return banner;
}

const listReward = async () => {
    let rewards = await prisma.reward.findMany({
        include: {
            RedeemReward: true
        }
    });

    return rewards;
};

const rewardById = async (id) => {
    const reward = await prisma.reward.findFirst({
        where: { id: id },
    })
    return reward
}

const redeemReward = async (idProfile, idReward) => {
    try {
       // เช็คว่าผู้ใช้แลกไปแล้วหรือยัง
       const existingRedemption = await prisma.redeemReward.findFirst({
        where: {
            profileId: idProfile,
            rewardId: idReward,
        },
    });

    if (existingRedemption) {
        throw new Error("You have already redeemed this reward!");
    }

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

        // ตรวจสอบว่าวันที่ปัจจุบันอยู่ในช่วงที่สามารถแลกของรางวัลได้
        const now = new Date();
        const startDate = new Date(reward.startDate);
        const endDate = new Date(reward.endDate);

        if (now < startDate || now > endDate) {
            throw new Error("Reward is not available at this time");
        }

        // ตรวจสอบว่ามีคะแนนพอหรือไม่
        const cost = Number(reward.cost);
        if (profile.points < cost) {
            throw new Error("Insufficient points");
        }

        // ตรวจสอบว่าสินค้ามีสต็อกหรือไม่
        if (reward.stock !== null && reward.stock <= 0) {
            throw new Error("Reward is out of stock");
        }

        // ทำรายการแลกรางวัล
        await prisma.$transaction([
            prisma.profile.update({
                where: { id: idProfile },
                data: {
                    points: {
                        decrement: cost,
                    },
                },
            }),
            prisma.redeemReward.create({
                data: {
                    profileId: idProfile,
                    rewardId: idReward,
                    quantity: 1, // แลก 1 ชิ้น
                    base_fee: 0,
                    addressId: null, 
                    delivery: "Pickup", 
                    status: "PAID",
                },
            }),
        ]);

        return { status: "success", message: "Reward redeemed successfully" };
    } catch (error) {
        console.error(error);
        return { status: "error", message: error.message };
    }
};


module.exports = {
    upsertReward,
    listReward,
    rewardById,
    redeemReward
};