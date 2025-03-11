// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
require('dotenv').config();

const nodemailer = require("nodemailer");
const prisma = new PrismaClient();

const authenticateEmail = async (email, password) => {
  const user = await prisma.user.findUnique({ where: { email, active: true }, include: { role: true } });
  if (!user) {
    throw new Error("User not found");
  }
  if (user && bcrypt.compareSync(password, user.password)) {
    return { id: user.id, role: user.role.role_name, active: user.active };
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
                            🎉 ยินดีต้อนรับ! คุณพร้อมรับรางวัลสุดพิเศษแล้ว!
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 40px;font-size: 16px;font-weight: 500;">
                            <p>
                                เรียน [${email}],
                            </p>
                            <p>
                                ขอบคุณที่ลงทะเบียนกับ [ชื่อแอป]!
                            </p>
                            <p>
                                บัญชีของคุณถูกสร้างเรียบร้อยแล้ว และคุณสามารถเริ่มสะสม รีวอร์ด ได้ทันที
                            </p>
                            <p>
                                ✨ สิ่งที่คุณสามารถทำได้ตอนนี้:
                            </p>
                            <p>
                                ✅ เข้าสู่ระบบและตั้งค่าบัญชีของคุณ
                            </p>
                            <p>
                                ✅ สำรวจภารกิจและกิจกรรมเพื่อรับแต้ม
                            </p>
                            <p>
                                ✅ แลกของรางวัลสุดพิเศษจากร้านค้าของเรา
                            </p>
                            <p>
                                กดปุ่มด้านล่างเพื่อเข้าสู่ระบบและเริ่มรับรางวัลเลย!
                            </p>
                            <a href="${process.env.API_URL}/auth/verify-user?token=${token}" target="_blank"
                                style="text-decoration: none;">
                                <button
                                    style="background-color: #1093ED;border: 1px solid #1093ED;border-radius: 12px;width: 160px;height: 48px;color: white;">
                                    Verify Email
                                </button>
                            </a>
                            <p>
                                หากคุณไม่ได้ทำการลงทะเบียน โปรดติดต่อฝ่ายสนับสนุนของเรา
                            </p><br>
                            <p>
                                ขอให้สนุกกับการสะสมรางวัล! 🎁
                            </p>
                            <p>
                                ทีมงาน
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

const user = async (email) => {
  const user = await prisma.user.findFirst({
    where: { email: email },
  })
  return user
}

const sendForgotPassword = async (email, token) => {
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
    subject: "เปลี่ยนรหัสผ่าน",
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
                            🔒 รีเซ็ตรหัสผ่านของคุณ
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 40px;font-size: 16px;font-weight: 500;">
                            <p>
                                เรียน [ชื่อผู้ใช้],
                            </p>
                            <br>
                            <p>
                                เราแจ้งให้คุณทราบว่า รหัสผ่านของบัญชี [ชื่อแอป] ของคุณถูกเปลี่ยนเรียบร้อยแล้ว
                            </p>
                            <br>
                            <p>
                                หาก คุณไม่ได้เป็นผู้เปลี่ยนรหัสผ่าน
                            </p>
                            <p>
                                โปรดรีเซ็ตรหัสผ่านของคุณทันทีโดยคลิกที่ลิงก์ด้านล่าง
                            </p>
                            <a href="${process.env.WEB_URL}/new-password?token=${token}" target="_blank"
                                style="text-decoration: none;">
                                <button
                                    style="background-color: #1093ED;border: 1px solid #1093ED;border-radius: 12px;width: 160px;height: 48px;color: white;">
                                    Reset Password
                                </button>
                            </a>
                            <p>
                                หากคุณมีคำถามหรือต้องการความช่วยเหลือโปรดติดต่อฝ่ายสนับสนุนของเรา
                            </p>
                            <p>
                                ขอบคุณที่เป็นส่วนหนึ่งของ [ชื่อแอป]!
                            </p>
                            <p>
                                ทีมงาน [ชื่อแอป]
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

const resetPassword = async (id, password) => {
  console.log(id);

  const user = await prisma.user.update({
    where: { id: id },
    data: {
      password: password
    }
  })
  return user;
}

const findUserById = async (id) => {
  const user = await prisma.user.findUnique({
    where: { id: id }
  });
  return user;
};

const profileMe = async (id) => {
  const profile = await prisma.profile.findFirst({
    where: { user_id: id },
    select: {
      id: true,
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
      points: true,
      phone: true,
      birth_date: true,
      gender: true,
      profile_img: true
    }
  })
  return profile;
}

const deleteUser = async (id) => {
  const user = await prisma.user.delete({
    where: {
      id: id
    }
  })
  return user;
}
const updateProfile = async (id, updatedData) => {
  try {
    if (updatedData.birth_date) {
      updatedData.birth_date = new Date(updatedData.birth_date).toISOString();
    } else {
      delete updatedData.birth_date;
    }

    const { email, ...profileData } = updatedData;
    const profile = await prisma.profile.update({
      where: { user_id: id },
      data: profileData, 
      select: {
        profile_name: true,
        first_name: true,
        last_name: true,
        phone: true,
        birth_date: true,
        gender: true,
        profile_img: true,
        points: true,
        user: {
          select: {
            email: true,
            active: true,
            role: {
              select: {
                role_name: true,
              },
            },
          },
        },
      },
    });

    if (email) {
      const updatedUser = await prisma.user.update({
        where: { id: id },
        data: {
          email: email,  
        },
      });
      console.log(updatedUser); 
    }

    return profile;
  } catch (error) {
    console.log(error);
    throw new Error("Error updating profile");
  }
};

const resetPasswordMe = async (id, old_password, new_password) => {

  let user = await prisma.user.findFirst({
    where: { id: id },
  })

  const isMatch = await bcrypt.compare(old_password, user.password);

  if (!isMatch) throw new Error("Incorrect old password");

  if (old_password === new_password) throw new Error("New password cannot be the same as the old password");

  const hashedPassword = await bcrypt.hash(new_password, 10);

  user = await prisma.user.update({
    where: { id: id },
    data: {
      password: hashedPassword
    }
  })
  return user;
}

const getNoti = async (userId, type) => {
  const noti = await prisma.notification_log.findMany({
    where: { noti_room: { profile: { user_id: userId } } }
  })

  return noti.map(item => !type || item.type == type)
}

const readNoti = async (userId, id) => {
  const noti = await prisma.notification_log.update({
    where: { noti_room: { profile: { user_id: userId } }, id: id },
    data: {
      read: true
    }
  })
  return noti
}

const readAllNoti = async (userId) => {
  const noti = await prisma.notification_log.update({
    where: { noti_room: { profile: { user_id: userId } } },
    data: {
      read: true
    }
  })
  return noti
}

const pointHistory = async (userId) => {
  const point = await prisma.checkIn.findMany({
    where: { profile: { user_id: userId } }
  })
  return point
}


module.exports = {
  updateProfile,
  findUserById,
  authenticateEmail,
  register,
  sendVertifyUser,
  vertifyUser,
  user,
  sendForgotPassword,
  resetPassword,
  profileMe,
  deleteUser,
  updateProfile,
  resetPasswordMe,
  getNoti,
  readNoti,
  readAllNoti,
  pointHistory
};
