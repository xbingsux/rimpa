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

module.exports = {
    upsertReward,
    listReward,
    rewardById
};