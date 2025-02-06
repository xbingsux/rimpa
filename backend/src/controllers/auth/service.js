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
              where: { role_name: "user" },
              create: { role_name: "user" }
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
        profile: { update: profile },
      },
    })
  }

  return { id: user.id, role: user.role, active: user.active };
};

const vertifyUser = async (id) => {
  let user = await prisma.user.findFirst({
    where: { id: id, active: true }
  })

  if (user) return { status: 0, user: user }

  user = await prisma.user.update({
    where: {
      id: id
    },
    data: {
      active: true
    }
  })

  if (user) return { status: 1, user: user }
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
    <a href="${process.env.API_URL}/auth/verify-user?token=${token}" target="_blank" style="text-decoration: none;">
      <button style="
          background-color: #28a745; 
          color: white; 
          padding: 12px 20px; 
          font-size: 16px; 
          border: none;
          border-radius: 5px;
          cursor: pointer;
          transition: 0.3s;
          display: inline-block;
      " onmouseover="this.style.backgroundColor='#218838'" 
        onmouseout="this.style.backgroundColor='#28a745'">
        Verify Email
      </button>
    </a>
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
