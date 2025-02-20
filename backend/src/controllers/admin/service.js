// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
require('dotenv').config();

const nodemailer = require("nodemailer");
const prisma = new PrismaClient();

const dashboard = async () => {
    const event = await prisma.event.findMany({})
    const attendees = await prisma.eventParticipant.findMany({})
    const reward = await prisma.reward.findMany({})
    const user = await prisma.user.findMany({})

    return [
        {
            title: 'Total Events',
            count: event.length
        },
        {
            title: 'Total Attendees',
            count: attendees.length,
        },
        {
            title: 'Total Reward',
            count: reward.length,
        },
        {
            title: 'Total User',
            count: user.length
        }
    ]
}

const upsertBanner = async (id, title, description, startDate, endDate, path) => {
    const banner = await prisma.banner.upsert({
        where: { id: id || 0 },
        create: {
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate,
            path: path
        },
        update: {
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate,
            path: path
        }
    })
    return banner;
}

const sendVertifyUser = async (email, token) => {
    // ตั้งค่า SMTP (ใช้ Gmail เป็นตัวอย่าง)
    const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
            user: process.env.EMAIL_USER,   // ใส่อีเมลของคุณ
            pass: process.env.EMAIL_PASS       // ใช้ App Password แทนรหัสผ่านจริง
        }
    });

    // ตั้งค่าเนื้อหาอีเมล
    const mailOptions = {
        from: `<${process.env.EMAIL_USER}>`,
        to: email,
        subject: "ยืนยันอีเมลของคุณ",
        html: `
        <div style="width: 100%;background-color: #fff;">
            <center>
                <div style="width: fit-content;background-color: white;padding: 0 80px 0 80px;">
                    <div style="height: 250px;">
                        <img src="https://lh3.googleusercontent.com/d/1OEo5p0k7p34zj4bms2YY7Rw1JxPPVj0B"
                            style="width: 165px;height: 160px;margin-top: 45px;">
                    </div>
                    <table>
                        <tr>
                            <td style="font-weight: 700;font-size: 24px;color: #1E1E1E;">
                                🎉 ข้อมูลบัญชีของคุณ
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 40px;font-size: 16px;font-weight: 500;">
                                <p>
                                    เรียน [ชื่อผู้ใช้],
                                </p>
                                <br>
                                <p>
                                    บัญชีของคุณสำหรับ [ชื่อแอป/ระบบ] ถูกสร้างเรียบร้อยแล้ว ✅
                                </p>
                                <p>
                                    กรุณาใช้ข้อมูลต่อไปนี้เพื่อลงชื่อเข้าใช้:
                                </p>
                                <p>
                                    🔹 ชื่อผู้ใช้ (Username): [ชื่อผู้ใช้]
                                </p>
                                <p>
                                    📌 เพื่อความปลอดภัย กรุณาเปลี่ยนรหัสผ่านของคุณทันทีหลังจากเข้าสู่ระบบ
                                </p>
                                <a href="${process.env.WEB_URL}/new-password?token=${token}" target="_blank"
                                    style="text-decoration: none;">
                                    <button
                                        style="background-color: #1093ED;border: 1px solid #1093ED;border-radius: 12px;width: 160px;height: 48px;color: white;">
                                        Verify Email
                                    </button>
                                </a>
                                <p>
                                    หากคุณพบปัญหาในการเข้าใช้งาน โปรดติดต่อฝ่ายสนับสนุน
                                </p><br>
                                <p>
                                    ขอแสดงความนับถือ,
                                </p>
                                <p>
                                    ทีมแอดมิน
                                </p>
                            </td>
                        </tr>
                    </table>
                </div>
            </center>
        </div>
        `
    };

    // ส่งอีเมล
    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.log("Error:", error);
        } else {
            console.log("Email sent:", info.response);
        }
    });

}

const upsertUser = async (email, password, role, profile, active) => {

    if (typeof active == 'boolean') {

    }

    let created = 0
    let user = await prisma.user.findFirst({
        where: { email: email }
    });

    if (!user) {
        created = 1
    }

    user = await prisma.user.upsert({
        where: {
            email: email
        },
        create: {
            email: email,
            password: password,
            role: {
                connectOrCreate: {
                    where: { role_name: role },
                    create: { role_name: role }
                },
            },
            profile: profile ? { create: profile } : { create: {} },
            active: active ? active : false
        },
        update: {
            email: email,
            role: {
                connectOrCreate: {
                    where: { role_name: role },
                    create: { role_name: role }
                },
            },
            profile: profile ? { update: profile } : { update: {} },
            active: active ? active : false
        }
    })
    return { created: created, user, user };
};

const listBanner = async () => {
    let banners = await prisma.banner.findMany({});

    return banners;
};

const bannerById = async (id) => {
    let banner = await prisma.banner.findFirst({
        where: { id: id }
    });

    return banner;
};

const listProfile = async () => {
    let profile = await prisma.user.findMany({
        select: {
            email: true,
            role: { select: { role_name: true } },
            profile: true,
            createdAt: true,
            active: true,
        },
    });

    return profile;
};

const profileById = async (id) => {
    const profile = await prisma.profile.findFirst({
        where: { id: id },
        select: {
            profile_name: true,
            first_name: true,
            last_name: true,
            user: {
                select: {
                    email: true,
                    active: true,
                    role: {
                        select: {
                            role_name: true
                        }
                    }
                }
            },
            phone: true,
            birth_date: true,
            gender: true,
            profile_img: true
        }
    })
    return profile;
}

const listEvent = async () => {
    let events = await prisma.event.findMany({
        select: {
            id: true,
            event_name: true,
            title: true,
            description: true,
            startDate: true,
            endDate: true,
            releaseDate: true,
            max_attendees: true,
            SubEvent: {
                include: { img: true, checkIn: true, EventParticipant: true }
            },
            _count: {
                select: {
                    EventView: true,
                    EventLike: true
                }
            }
        }
    });

    return events.map((item) => ({
        id: item.id,
        event_name: item.event_name,
        title: item.title,
        description: item.description,
        startDate: item.startDate,
        endDate: item.endDate,
        releaseDate: item.releaseDate,
        max_attendees: item.max_attendees,
        sub_event: item.SubEvent,
        likes: item._count.EventLike,
        views: item._count.EventView
    }));
};

module.exports = {
    dashboard,
    upsertBanner,
    bannerById,
    upsertUser,
    listBanner,
    listProfile,
    profileById,
    sendVertifyUser,
    listEvent
};