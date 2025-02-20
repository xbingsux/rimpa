const express = require("express");
const jwt = require("jsonwebtoken");
const Service = require("./service");
const bcrypt = require("bcrypt");
const router = express.Router();
const https = require("https");
const { auth } = require("../../middleware/authorization");
const nodemailer = require("nodemailer");

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

router.get("/test", async (req, res) => {
  return res.status(200).json({ status: "success" });
});

router.post("/dashboard", auth, async (req, res) => {
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });

    const dashboard = await Service.dashboard()
    return res.status(200).json({ status: "success", dashboard });
  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/list-profile", auth, async (req, res) => {
  const { } = req.body;
  try {

    const profile = await Service.listProfile()
    return res.status(200).json({ status: "success", profile });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/profile", auth, async (req, res) => {
  const { profile_id } = req.body;
  try {
    const profile = await Service.profileById(profile_id)
    return res.status(200).json({ status: "success", profile });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/update-banner", auth, async (req, res) => {
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });

    const { id, title, description, startDate, endDate, path } = req.body;

    const banner = await Service.upsertBanner(id, title, description, startDate, endDate, path)
    return res.status(200).json({ status: "success", banner });
  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/list-banner", auth, async (req, res) => {
  const { } = req.body;
  try {

    const banner = await Service.listBanner()
    return res.status(200).json({ status: "success", banner });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/get-banner", auth, async (req, res) => {
  const { id } = req.body;
  try {
    const banner = await Service.bannerById(id)
    return res.status(200).json({ status: "success", banner });
  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/register", auth, async (req, res) => {
  const { email, role, profile, active } = req.body;
  try {
    password = 'e6g3!Xh@aMwhyJx'
    const hashedPassword = bcrypt.hashSync(password, 10);
    const newUser = await Service.upsertUser(email, hashedPassword, role, profile, active);
    if (newUser.created) {
      let token = jwt.sign({ userId: newUser.id, usedToken: 1 }, process.env.SECRET_KEY, {
        expiresIn: "1d",
      });

      console.log(token);
      await Service.sendVertifyUser(email, token)
    }

    return res.status(201).json({
      status: "success",
      user: newUser.user,
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "error",
      message: error.message//"Internal Server Error",
    });
  }
});

router.post("/list-event", auth, async (req, res) => {
  const { } = req.body;
  try {

    const event = await Service.listEvent()
    return res.status(200).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

module.exports = router;
