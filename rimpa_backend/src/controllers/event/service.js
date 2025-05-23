// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

const socket = require('../../socket/service')

const upsertEvent = async (event_id, sub_event_id, title, description, max_attendees, map, releaseDate, startDate, endDate, point, event_img) => {
    let event = await prisma.event.upsert({
        where: { id: event_id || 0 },
        create: {
            title: title,
            description: description,
            max_attendees: max_attendees,
            releaseDate: releaseDate,
            startDate: startDate,
            endDate: endDate,
            SubEvent: {
                create: {
                    map: map,
                    point: point,
                    event_type: "Main",
                    startDate: startDate,
                    endDate: endDate,
                    title: title,
                    description: description
                }
            },
        },
        update: {
            title: title,
            description: description,
            max_attendees: max_attendees,
            releaseDate: releaseDate,
            startDate: startDate,
            endDate: endDate,
            SubEvent: {
                update: {
                    where: {
                        id: sub_event_id || 0,
                        event_type: "Main"
                    },
                    data: {
                        map: map,
                        point: point,
                        startDate: startDate,
                        endDate: endDate,
                        title: title,
                        description: description
                    }
                }
            },
        }, include: {
            SubEvent: {
                include: {
                    img: true
                }
            },
        }
    })

    const missingImgIds = await Promise.all(
        event.SubEvent[0].img
            .filter(item => !event_img.some(img => img.id === item.id))
            .map(async item => {
                return await prisma.eventIMG.delete({
                    where: { id: item.id }
                });
            })
    );

    // console.log(missingImgIds);

    let list = []
    // event_img    key, path
    // console.log(event_img);

    if (typeof event_img == 'object') {
        for (const item of event_img) {
            list.push(await upsertEventIMG(item.path, item.id, event.SubEvent[0].id));
        }
    }
    event.img = list;

    return event;
}

const upsertEventIMG = async (path, id, sub_event_id) => {
    const img = await prisma.eventIMG.upsert({
        where: { id: id },
        create: {
            path: path,
            sub_event: {
                connect: {
                    id: sub_event_id || 0
                }
            }
        }, update: {
            path: path
        }
    })
    return img;
}

const listEvent = async (limit, popular) => {
    const currentDate = new Date();

    let orderBy = {};

    if (popular) {
        orderBy = {
            EventView: {
                _count: popular
            }
        };
    }

    let events = await prisma.event.findMany({
        where: {
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
            active: true
        },
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
                include: { img: true, checkIn: true, EventParticipant: true },
            },
            _count: {
                select: {
                    EventView: true,
                    EventLike: true,
                }
            }
        },
        orderBy: orderBy,
        ...(limit ? { take: limit } : {}),
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

const getEvent = async (id, decoded) => {
    const currentDate = new Date();
    try {
        if (decoded && decoded.userId) {
            const profile = await prisma.profile.findFirst({
                where: { user_id: decoded.userId }
            })

            let view = await prisma.eventView.findFirst({
                where: {
                    profile_id: profile.id,
                    eventId: id
                }
            })

            view = await prisma.eventView.upsert({
                where: {
                    id: view?.id | 0
                },
                create: {
                    eventId: id,
                    profile_id: profile.id,
                }, update: {

                }
            })
        }
    } catch (e) {

    }

    const event = await prisma.event.findFirst({
        where: {
            id: id,
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
            active: true
        },
        include: {
            SubEvent: { include: { img: true } },
        }
    })
    // event.SubEvent[0].
    return event;
}

const joinEvent = async (user_id, sub_event_id) => {

    let event = await prisma.eventParticipant.findFirst({
        where: {
            Profile: { user_id: user_id }, subEventId: sub_event_id, OR: [{ status: 'PAID' }, { status: 'PENDING' }]
        }
    })

    if (event) throw new Error('Transaction Failed')

    event = await prisma.eventParticipant.create({
        data: {
            Profile: { user_id: user_id }, subEventId: sub_event_id
        }
    })
    return event;
    // const point = await prisma.profile.up
}

const scan = async (user_id, qrcode) => {
    const currentDate = new Date();
    const sub_event = await prisma.subEvent.findFirst({
        where: {
            qrcode: qrcode,
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
            active: true
        }
    })

    if (!sub_event) throw new Error('QR code not found.')

    const checkIn = await prisma.checkIn.findFirst({
        where: { sub_event_id: sub_event.id, profile: { user_id: user_id } }
    })

    if (checkIn) throw new Error('You have already claimed the point.')

    return sub_event;
}

const checkIn = async (user_id, qrcode) => {
    const currentDate = new Date();
    const sub_event = await prisma.subEvent.findFirst({
        where: {
            qrcode: qrcode,
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
            active: true
        },
        include: {
            Event: true,
            checkIn: true
        }
    })

    if (!sub_event) throw new Error('No information available or out of the event period')

    if (
        sub_event.Event.max_attendees != null &&
        sub_event.Event.max_attendees > 0 &&
        sub_event.checkIn.length >= sub_event.Event.max_attendees
    ) throw new Error('The event has reached its limit.')

    let checkIn = await prisma.checkIn.findFirst({
        where: { sub_event_id: sub_event.id, profile: { user_id: user_id } }
    })

    if (checkIn) throw new Error('You have already claimed the point.')

    const point = await prisma.$transaction(async (prisma) => {
        checkIn = await prisma.checkIn.create({
            data: {
                sub_event: { connect: { id: sub_event.id } },
                profile: { connect: { user_id: user_id } },
            }
        });

        const profile = await prisma.profile.update({
            where: { user_id: user_id },
            data: {
                points: { increment: sub_event.point },
            }
        })

        const point = await prisma.point.create({
            data: {
                points: sub_event.point,
                Profile: { connect: { user_id: user_id } },
                type: 'EARN',
                description: sub_event.title
            },
            include: {
                Profile: true
            }
        })

        if (profile) {
            socket.serverMessageByUser(user_id, `🎉 ยินดีด้วย! คุณได้รับ ${sub_event.point} คะแนน`, `แต้มของคุณเพิ่มขึ้นเรื่อย ๆ! อย่าลืมสะสมให้ครบ \nเพื่อแลกรับสิทธิพิเศษ ของรางวัลสุดคุ้ม`)
        }

        return point;
    })

    return point;
}

const listBanner = async () => {
    const currentDate = new Date();
    let banners = await prisma.banner.findMany({
        where: {
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
        }
    });

    return banners;
};

const bannerById = async (id) => {
    let banner = await prisma.banner.findFirst({
        where: { id: id }
    });

    return banner;
};

module.exports = {
    upsertEvent,
    listEvent,
    getEvent,
    joinEvent,
    checkIn,
    listBanner,
    bannerById,
    scan
};