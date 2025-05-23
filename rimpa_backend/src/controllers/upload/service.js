const { PrismaClient } = require("@prisma/client");
const multer = require("multer");
const fs = require("fs");
const path = require("path");
const prisma = new PrismaClient();
const sharp = require("sharp");

// กำหนด multer storage สำหรับการจัดการการอัปโหลดไฟล์
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    let folder = "src/uploads/";

    // ตรวจสอบโฟลเดอร์ที่กำหนดจาก req.uploadFolder
    if (req.uploadFolder) {
      folder = path.join(folder, req.uploadFolder);
    } else {
      // fallback ไปยังโฟลเดอร์ default ถ้าไม่ได้กำหนดโฟลเดอร์
      folder = path.join(folder, "default");
    }

    // ตรวจสอบและสร้างโฟลเดอร์ถ้ายังไม่มี
    fs.mkdir(folder, { recursive: true }, (err) => {
      if (err) {
        return cb(new Error(`Failed to create directory: ${err.message}`));
      }
      cb(null, folder);
    });
  },
  filename: function (req, file, cb) {
    // กำหนดนามสกุลเป็น .jpg เสมอ
    let extension = path.extname(file.originalname); // ใช้นามสกุลจากไฟล์ที่อัปโหลดจริง
    let random = (Math.random() * 1e4).toFixed(0).padStart(4, '0')
    cb(null, `${Date.now()}${random}${extension}`);
  }
});

// ฟังก์ชันการอัปโหลดไฟล์ด้วย multer
const upload = multer({
  storage: storage,
  //   limits: { fileSize: 10 * 1024 * 1024 }, // ขนาดไฟล์สูงสุด 10MB
});

// ฟังก์ชันสำหรับอัปโหลดไฟล์
const uploadFile = async (req) => {
  if (!req.file) {
    throw new Error("No file uploaded");
  }
  // บีบอัดไฟล์ก่อนส่งออก
  const compressedFilePath = await compressImage(req.file.path);
  // คืนค่า path หลังจากบีบอัด
  return {
    status: "success",
    path: compressedFilePath,
  };
};

const compressImage = async (filePath) => {
  try {
    // ใช้ชื่อไฟล์เดิม แต่ให้มีคำว่า 'compressed-' เพิ่มไป
    const extension = path.extname(filePath);
    const fileName = path.basename(filePath, extension); // เอาชื่อไฟล์เดิมออกมาจาก path
    const cleanFileName = fileName.replace(/^test/, ''); // ลบคำว่า 'test' ที่อยู่ข้างหน้า  
    const outputFilePath = path.join(path.dirname(filePath), `${cleanFileName}${extension}`); // สร้างชื่อไฟล์ใหม่

    // // ใช้ sharp ลดขนาดภาพและบีบอัด
    // await sharp(filePath)
    //   .resize(512, 512, { fit: "cover" }) // ปรับเป็น 1:1 (ครอบภาพ)
    //   .jpeg({ quality: 70 }) // ลดคุณภาพภาพลง 70%
    //   .toFile(outputFilePath); // บันทึกไฟล์ที่บีบอัดไปที่ outputFilePath

    // // ลบไฟล์ต้นฉบับหลังจากการบีบอัดเสร็จ
    // fs.unlinkSync(filePath);

    return outputFilePath; // คืน path ของไฟล์ที่ถูกบีบอัด
  } catch (error) {
    console.error("Error compressing image:", error);
    throw new Error("Failed to compress image");
  }
};


// 🚀 ทดสอบฟังก์ชัน
// uploadImage("./temp/image.jpg").then((result) => console.log("✔️ Done:", result));


// 🚀 ทดสอบฟังก์ชัน
// compressImage("./uploads/test-image.jpg").then((result) => console.log("✔️ Done:", result));

//Prisma

const updateImgProfile = async (id, path) => {
  const profile = await prisma.profile.update({
    where: { user_id: id },
    data: {
      profile_img: path
    }
  })
  return profile;
}
module.exports = {
  upload,
  uploadFile,
  updateImgProfile
};
