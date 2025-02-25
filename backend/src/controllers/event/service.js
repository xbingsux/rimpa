// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");

require('dotenv').config();

const prisma = new PrismaClient();

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
                    event_type: "Main"
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
                    }
                }
            },
        }, include: {
            SubEvent: true
        }
    })
    let list = []
    // event_img    key, path
    console.log(event_img);

    if (typeof event_img == 'object') {
        event_img.map((item) => {
            console.log(item);
            list.push(upsertEventIMG(item.path, item.id, event.SubEvent[0].id))
        })
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

const listEvent = async () => {
    const currentDate = new Date();

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

const getEvent = async (id) => {
    const currentDate = new Date();

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

const checkIn = async (user_id, sub_event_id) => {
    let checkIn = await prisma.checkIn.findFirst({
        where: { sub_event_id: sub_event_id, profile: { user_id: user_id } }
    })

    let sub_event = await prisma.subEvent.findFirst({
        where: { id: sub_event_id }
    })

    if (checkIn) throw new Error('You have already claimed the point.')

    checkIn = await prisma.checkIn.create({
        data: {
            sub_event_id: sub_event_id,
            profile: { user_id: user_id },
        }
    });

    const point = await prisma.point.create({
        data: {
            points: sub_event.point,
            Profile: { user_id: user_id },
            type: 'EARN',
            description: 'รับคะแนนจากกิจกรรม'
        }
    })

    const profile = prisma.profile.update({
        where: { user_id: user_id },
        data: {
            points: { increment: sub_event.point }
        }
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
    bannerById
};