const express = require("express");
const jwt = require("jsonwebtoken");
const Service = require("./service");
const bcrypt = require("bcrypt");
const router = express.Router();
const https = require("https");
const auth = require("../../middleware/authorization");
const nodemailer = require("nodemailer");

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

router.get("/test", async (req, res) => {
  return res.status(200).json({ status: "success" });
});

router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await Service.authenticateEmail(email, password);
    if (user) {
      console.log("#LOGIN WITH EMAIL");
      let token = null;
      if (user.active)
        token = jwt.sign({ userId: user.id }, process.env.SECRET_KEY, {
          expiresIn: "1d",
        });

      return res.status(200).json({
        status: "success",
        token: token,
        role: user.role,
        // active: user.active,
      });
    } else {
      return res.status(401).json({
        status: "error",
        message: "Unauthorized",
      });
    }
  } catch (error) {
    console.error(error);
    if (error.message === "User not found") {
      return res
        .status(404)
        .json({ status: "error", message: "User not found" });
    } else if (error.message === "Wrong password") {
      return res.status(401).json({
        status: "error",
        message: "Wrong password",
      });
    } else {
      return res.status(500).json({
        status: "error",
        message: "Internal Server Error",
      });
    }
  }
});

// Email Register
router.post("/register", async (req, res) => {
  const { email, password, profile } = req.body;
  try {
    const hashedPassword = bcrypt.hashSync(password, 10);
    const newUser = await Service.register(email, hashedPassword, profile);
    if (newUser) {
      let token = jwt.sign({ userId: newUser.id }, process.env.SECRET_KEY, {
        expiresIn: "1d",
      });

      console.log(token);
      await Service.sendVertifyUser(email, token)
    }
    return res.status(201).json({
      status: "success",
      user: newUser,
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "error",
      message: error.message//"Internal Server Error",
    });
  }
});

router.get("/verify-user", async (req, res) => {
  const { token } = req.query
  // ตรวจสอบว่า token มีค่าหรือไม่
  if (!token) {
    return res.status(401).send("No token");
  }

  // ตรวจสอบและถอดรหัส token
  const decoded = jwt.verify(token, process.env.SECRET_KEY);

  if (!decoded || !decoded.userId) {
    return res.status(401).send("Invalid token or missing user ID");
  }
  const user = await Service.vertifyUser(decoded.userId)

  if (user && user.active) {
    res.status(200).json({
      status: "success",
      message: "User is online",
      user: user,
    });
  } else {
    return res.status(500).json({
      status: "error",
      message: "Internal Server Error",
    });
  }
})

// Verify Token
router.post("/verify-token", (req, res) => {
  const { token } = req.body;
  if (!token) {
    return res.status(400).json({
      status: "error",
      message: "Token is required",
    });
  }
  jwt.verify(token, process.env.SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(401).json({
        status: "error",
        message: "Invalid or expired token",
      });
    }
    return res.status(200).json({
      status: "success",
      message: "Token is verify",
      userId: decoded.userId,
    });
  });
});

module.exports = router;
