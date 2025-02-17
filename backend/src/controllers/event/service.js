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

const getEvent = async (id) => {
    const event = await prisma.event.findFirst({
        where: { id: id },
        include: {
            SubEvent: { include: { img: true } },
        }
    })
    // event.SubEvent[0].
    return event;
}

module.exports = {
    upsertEvent,
    listEvent,
    getEvent
};