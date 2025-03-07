const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
require('dotenv').config();
let port = process.env.PORT || 3001;

const { io } = require("socket.io-client");
const socket = io(`http://localhost:${port}`);

const prisma = new PrismaClient();

const serverMessageByUser = async (user_id, title, message, type) => {
    let profile = await prisma.profile.findFirst({
        where: { user_id: user_id },
        include: {
            noti_room: true
        }
    })

    if (!profile.noti_roomId) {
        profile = await prisma.profile.update({
            where: { user_id: user_id },
            data: {
                noti_room: { create: {} }
            },
            include: {
                noti_room: true
            }
        })
    }

    const roomId = profile?.noti_room.id;

    const jsonMessage = {
        room: roomId,
        message: {
            title: title,
            message: message,
            type: type,
            date: new Date()
        }
    };

    socket.emit(`room message`, jsonMessage);

    let chat = null
    if (roomId) {
        chat = await prisma.notification_log.create({
            data: {
                title: title ? title : null,
                message: message,
                type: type ? type : null,
                noti_roomId: roomId
            }
        })
    }

    return chat
}

module.exports = {
    serverMessageByUser
};