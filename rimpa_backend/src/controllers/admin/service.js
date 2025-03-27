// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
require('dotenv').config();

const nodemailer = require("nodemailer");
const prisma = new PrismaClient();

const dashboard = async () => {

    const [totalEvents, totalAttendees, totalRewards, totalUsers] = await Promise.all([
        prisma.event.count({ where: { active: true } }),
        prisma.eventParticipant.count({ where: { status: 'PAID' } }),
        prisma.reward.count({ where: { active: true } }),
        prisma.user.count({ where: { active: true } })
    ]);

    return [
        {
            title: 'Total Events',
            count: totalEvents
        },
        {
            title: 'Total Attendees',
            count: totalAttendees,
        },
        {
            title: 'Total Reward',
            count: totalRewards,
        },
        {
            title: 'Total User',
            count: totalUsers
        }
    ];

};


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
                                    บัญชีของคุณสำหรับ Go Con ถูกสร้างเรียบร้อยแล้ว ✅
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

const upsertUser = async (email, role, profile, active) => {
    const password = bcrypt.hashSync('Rh8EpbBE599AG6mwl35NtVR9Z3lB5855YIz2luKd4YXJzt0H19', 10);

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

const listProfile = async () => {
    let profile = await prisma.user.findMany({
        select: {
            id: true,
            email: true,
            role: { select: { role_name: true } },
            profile: true,
            createdAt: true,
            active: true,
        }, orderBy: {
            createdAt: 'desc'
        }
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
    const currentDate = new Date();

    let events = await prisma.event.findMany({
        where: { active: true },
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
        views: item._count.EventView,
        status: (currentDate < item.startDate ? 'Pending' : currentDate <= item.endDate ? 'Active' : 'Expired')
    }));
};

const getEvent = async (id) => {
    const event = await prisma.event.findFirst({
        where: {
            id: id,
            active: true
        },
        include: {
            SubEvent: { include: { img: true } },
        }
    })
    // event.SubEvent[0].
    return event;
}

const listReward = async () => {
    let rewards = await prisma.reward.findMany({
        where: {
            active: true
        },
        include: {
            RedeemReward: true
        }
    });

    return rewards;
};

const rewardById = async (id) => {
    const reward = await prisma.reward.findFirst({
        where: {
            id: id,
            active: true
        },
    })
    return reward
}

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
            max_per_user: 1,//default
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

const redeemReward = async (redeemId) => {
    const item = await prisma.redeemReward.findFirst({
        where: { id: redeemId }
    })

    const redeemExp = new Date(item.createdAt.getTime() + 30 * 60 * 1000)

    if (redeemExp.getTime() > new Date().getTime()) {
        throw new Error("Your license has expired.");
    }

    // ดึงข้อมูลโปรไฟล์
    const qty = 1;
    const profile = await prisma.profile.findUnique({
        where: { id: item.profileId },
        select: { points: true, id: true },
    });

    if (!profile) {
        throw new Error("Profile not found");
    }

    // ดึงข้อมูลรางวัล
    const reward = await rewardById(item.rewardId);

    if (!reward) {
        throw new Error("Reward not found");
    }

    // ตรวจสอบว่า user แลกไปแล้วกี่ครั้ง (ถ้ามีการจำกัด)
    if (reward.max_per_user !== null && reward.max_per_user > 0) {
        const redeemed = await prisma.redeemReward.findMany({
            where: { rewardId: item.rewardId, OR: [{ status: 'PAID' }, { status: 'DELIVERED' }] },
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
        const redeem = await prisma.$transaction(async (tx) => {
            const usePoint = (reward.cost * qty);
            // ลดคะแนน
            await tx.profile.update({
                where: { id: profile.id },
                data: { points: { decrement: reward.cost } },
            });

            // บันทึกการแลกรางวัล
            const redeem = await tx.redeemReward.upsert({
                where: {
                    id: item?.id | 0
                },
                create: {
                    profileId: profile.id,
                    rewardId: item.rewardId,
                    quantity: qty,
                    base_fee: 0,
                    addressId: null,
                    delivery: "Pickup",
                    status: "PAID",
                    usedCoints: usePoint
                }, update: {
                    status: "PAID",
                }, include: {
                    Profile: true,
                    Reward: true
                }
            });

            const point = await tx.point.create({
                data: {
                    points: usePoint,
                    Profile: { connect: { id: profile.id } },
                    type: 'REDEEM',
                    description: reward.reward_name
                }
            })

            return redeem;

        }).catch((e) => {
            console.log(e);

            throw new Error("Transaction could not be completed.");
        })

        return redeem;
    }

};

const rewardHistory = async () => {
    const history = await prisma.redeemReward.findMany({
        where: {
            status: 'PAID'
        },
        include: {
            Profile: true,
            Reward: true
        }
    });

    return history;
};

const getRedeem = async (barcode) => {

    const redeemId = Number(String(barcode).startsWith('9') ? String(barcode).slice(1) : String(barcode))
    if (isNaN(redeemId)) {
        throw new Error('Invalid barcode')
    }

    const redeem = await prisma.redeemReward.findFirst({
        where: {
            id: redeemId
        },
        include: {
            Profile: true,
            Reward: true
        }
    });

    return redeem;
};

const deleteUser = async (id) => {
    const user = await prisma.user.delete({
        where: {
            id: id
        }
    })
    return user;
}

const deleteEvent = async (id) => {
    const event = await prisma.event.update({
        where: {
            id: id,
            active: true
        },
        data: {
            active: false
        }
    })
    return event;
}

const deleteReward = async (id) => {
    const reward = await prisma.reward.update({
        where: {
            id: id,
            active: true
        },
        data: {
            active: false
        }
    })
    return reward;
}

const deleteBanner = async (id) => {
    const banner = await prisma.banner.delete({
        where: {
            id: id,
        }
    })
    return banner;
}

module.exports = {
    dashboard,
    listProfile,
    upsertUser,
    profileById,
    deleteUser,
    sendVertifyUser,
    //reward
    listReward,
    upsertReward,
    rewardById,
    deleteReward,
    rewardHistory,
    getRedeem,
    redeemReward,
    //banner
    listBanner,
    upsertBanner,
    deleteBanner,
    //event
    listEvent,
    getEvent,
    deleteEvent,
};