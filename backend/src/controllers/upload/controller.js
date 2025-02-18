const express = require("express");
const router = express.Router();
const { auth } = require("../../middleware/authorization");
const fileService = require("./service"); // นำเข้า Service ที่รวมแล้ว
const { upload } = fileService; // ใช้ multer จาก fileService

// ดึงข้อมูลโปรไฟล์จาก token
router.get("/test", auth, async (req, res) => {
  try {
    return res.status(200).json({ status: "success" });
  } catch (error) {
    console.error(error);
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

// // เส้นทางสำหรับการดึงไฟล์
// router.get("/file/:fileName", auth, async (req, res) => {
//   console.log("in get file");

//   try {
//     const fileName = req.params.fileName;
//     const folder = req.query.folder || "default";
//     const filePath = path.join(__dirname, "../../src/uploads", folder, fileName);

//     console.log("File path:", filePath);  // สำหรับการดีบัก

//     if (!fs.existsSync(filePath)) {
//       return res.status(404).json({ status: "error", message: "File not found" });
//     }

//     res.sendFile(filePath, (err) => {
//       if (err) {
//         console.error("Error sending file:", err);
//         res.status(500).json({ status: "error", message: "Failed to send file" });
//       }
//     });
//   } catch (error) {
//     console.error("Error retrieving file:", error);
//     return res.status(500).json({ status: "error", message: "Failed to retrieve file" });
//   }
// });

// เส้นทางสำหรับอัปโหลดรูปโปรไฟล์
router.post(
  "/update/profile",
  auth,
  (req, res, next) => {
    req.uploadFolder = "profile-images";
    next();
  },
  upload.single("file"),
  async (req, res) => {
    try {

      const path = req.file.path.replace('src', '')
      fileService.updateImgProfile(req.user.userId, path)

      return res.status(200).json({
        status: "success",
        file: req.file,
        path: path,
      });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ status: "error", message: "File upload failed" });
    }
  }
);

router.post(
  "/upload/profile",
  auth,
  (req, res, next) => {
    req.uploadFolder = "profile-images";
    next();
  },
  upload.single("file"),
  async (req, res) => {
    try {
      // const file = await fileService.uploadFile(req);
      // console.log('xxxxxxxxxxxxxxxxxxxxxxxxxx', file)
      console.log(req.file);

      return res.status(200).json({
        status: "success",
        file: req.file,
        path: req.file.path.replace('src', ''),
      });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ status: "error", message: "File upload failed" });
    }
  }
);

router.post(
  "/upload/event",
  auth,
  (req, res, next) => {
    req.uploadFolder = "event-images";
    next();
  },
  upload.single("file"),
  async (req, res) => {
    try {
      // const file = await fileService.uploadFile(req);
      // console.log('xxxxxxxxxxxxxxxxxxxxxxxxxx', file)
      console.log(req.file);

      return res.status(200).json({
        status: "success",
        file: req.file,
        path: req.file.path.replace('src', ''),
      });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ status: "error", message: "File upload failed" });
    }
  }
);

router.post(
  "/upload/banner",
  auth,
  (req, res, next) => {
    req.uploadFolder = "banner-images";
    next();
  },
  upload.single("file"),
  async (req, res) => {
    try {
      // const file = await fileService.uploadFile(req);
      // console.log('xxxxxxxxxxxxxxxxxxxxxxxxxx', file)
      console.log(req.file);

      return res.status(200).json({
        status: "success",
        file: req.file,
        path: req.file.path.replace('src', ''),
      });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ status: "error", message: "File upload failed" });
    }
  }
);

router.post(
  "/upload/reward",
  auth,
  (req, res, next) => {
    req.uploadFolder = "reward-images";
    next();
  },
  upload.single("file"),
  async (req, res) => {
    try {
      console.log('test reward');

      // const file = await fileService.uploadFile(req);
      // console.log('xxxxxxxxxxxxxxxxxxxxxxxxxx', file)
      console.log(req.file);

      return res.status(200).json({
        status: "success",
        file: req.file,
        path: req.file.path.replace('src', ''),
      });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ status: "error", message: "File upload failed" });
    }
  }
);

// เส้นทางสำหรับลบรูปโปรไฟล์
router.delete(
  "/delete/profile/:fileName", // fileName is still part of the URL
  auth,  // Assuming this is the middleware for authentication
  (req, res, next) => {
    console.log("Deleting profile picture...");
    req.deleteFile = "profile-images"; // Optional, if used for file storage logic
    next();
  },
  async (req, res) => {
    try {
      // Extract the profileId from the request body
      const { profileId } = req.body;  // Assuming profileId is passed in the body
      const fileName = req.params.fileName;

      if (!profileId) {
        return res.status(400).json({
          status: "error",
          message: "Profile ID is required",
        });
      }

      console.log("Deleting file for userId:", profileId);

      // Call the service to delete the image
      await fileService.deleteImageByProfileID(profileId, fileName, req);

      return res.status(200).json({
        status: "success",
        message: `File ${fileName} deleted successfully`,
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        status: "error",
        message: "File deletion failed",
      });
    }
  }
);

// เส้นทางสำหรับอัปโหลดไฟล์ทั่วไป
router.post(
  "/upload/file",
  auth,
  (req, res, next) => {
    req.uploadFolder = "file"; // กำหนดโฟลเดอร์เป็น file
    next();
  },
  upload.single("file"),
  async (req, res) => {
    try {
      const file = await fileService.uploadFile(req); // เรียกใช้ฟังก์ชัน uploadFile
      return res.status(200).json({
        status: "success",
        file: file,
      });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ status: "error", message: "File upload failed" });
    }
  }
);

// เส้นทางสำหรับลบไฟล์
router.delete(
  "/delete/profile/:fileName",
  auth,
  (req, res, next) => {
    console.log("Deleting profile picture...");
    req.deleteFile = "profile-images";
    next();
  },
  async (req, res) => {
    try {
      const fileName = req.params.fileName;
      await fileService.deleteProfileImage(fileName, req);
      return res.status(200).json({
        status: "success",
        message: `File ${fileName} deleted successfully`,
      });
    } catch (error) {
      console.error(error);
      return res
        .status(500)
        .json({ status: "error", message: "File deletion failed" });
    }
  }
);

module.exports = router;