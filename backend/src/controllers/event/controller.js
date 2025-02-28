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

router.post("/update-event", auth, async (req, res) => {
  const { event_id, sub_event_id, title, description, max_attendees, map, releaseDate, startDate, endDate, point, event_img } = req.body;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });

    const event = await Service.upsertEvent(event_id, sub_event_id, title, description, max_attendees, map, releaseDate, startDate, endDate, point, event_img)
    return res.status(200).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/list-event",  async (req, res) => {
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

router.post("/get-event", async (req, res) => {
  const { id } = req.body;
  try {

    const event = await Service.getEvent(id);
    return res.status(200).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/scan", auth, async (req, res) => {
  const { qrcode } = req.body;
  
  if (!qrcode) {
    return res.status(400).json({
      status: "error",
      message: "QR code is required"
    });
  }

  try {
    const event = await Service.scan(req.user.userId, qrcode);
    return res.status(200).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    if (error.message === 'QR code not found.' || error.message === 'You have already claimed the point.') {
      return res
        .status(500)
        .json({ status: "error", message: error.message });
    } else {
      return res
        .status(500)
        .json({ status: "error", message: "Internal Server Error" });
    }
  }
});


router.post("/checkIn", auth, async (req, res) => {
  const { sub_event_id } = req.body;

  try {
    const event = await Service.checkIn(req.user.userId, sub_event_id);
    return res.status(200).json({ status: "success", event });
  } catch (error) {
    console.error(error);
    console.log("error");
    if (error.message === 'You have already claimed the point.' || error.message === 'No information available or out of the event period') {
      return res
        .status(500)
        .json({ status: "error", message: error.message });
    } else {
      return res
        .status(500)
        .json({ status: "error", message: "Internal Server Error" });
    }
  }
});

router.post("/list-banner", async (req, res) => {
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

router.post("/get-banner", async (req, res) => {
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

module.exports = router;
