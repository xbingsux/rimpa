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

//reward

router.get("/test", async (req, res) => {
  return res.status(200).json({ status: "success" });
});

router.post("/list-reward", async (req, res) => {
  const { } = req.body;
  try {

    const reward = await Service.listReward()
    return res.status(200).json({ status: "success", reward });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/get-reward", async (req, res) => {
  const { id } = req.body;
  try {
    const reward = await Service.rewardById(id)
    return res.status(200).json({ status: "success", reward });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/redeem-rewards", async (req, res) => {
  const { idProfile,idReward } = req.body;
  try {
    const reward = await Service.redeemReward(idProfile,idReward)
    return res.status(200).json({ status: "success", reward });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

module.exports = router;
