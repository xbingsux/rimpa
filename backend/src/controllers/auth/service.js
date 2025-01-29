// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
require('dotenv').config();

const nodemailer = require("nodemailer");
const prisma = new PrismaClient();

const authenticateEmail = async (email, password) => {
  const user = await prisma.user.findUnique({ where: { email, active: true } });
  if (!user) {
    throw new Error("User not found");
  }
  if (user && bcrypt.compareSync(password, user.password)) {
    return { id: user.id, role: user.role, active: user.active };
  } else {
    throw new Error("Wrong password");
  }
};

const register = async (email, password, profile) => {
  let user = await prisma.user.findFirst({
    where: {
      email: email
    }
  })

  if (user && user.active) {
    throw new Error("This user is already in use.");
  } else if (!user) {
    await prisma.$transaction(async (prisma) => {
      user = await prisma.user.create({
        data: {
          email: email,
          password: password,
          role: {
            connectOrCreate: {
              where: { role: "user", id: 0 },
              create: { role: "user" }
            },
          },
          profile: profile ? { create: profile } : { create: {} },
          active: false
        }
      })
    }).catch((e) => {
      console.log(e);
      throw new Error("Error Can't create uer.");
    })
  } else {
    user = await prisma.user.update({
      where: {
        email: email
      },
      data: {
        email: email,
        password: password,
      },
    })
  }

  return { id: user.id, role: user.role, active: user.active };
};

const vertifyUser = async (id) => {
  const user = prisma.user.update({
    where: {
      id: id,
      active: false
    },
    data: {
      active: true
    }
  })
  return user;
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
    subject: "Test Vertify Email",
    html: `
    <button href="${process.env.API_URL}/auth/verify-user?token=${token}">
      Vertify Email
    </button>
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
module.exports = {
  authenticateEmail,
  register,
  sendVertifyUser,
  vertifyUser,
};
