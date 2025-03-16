const express = require("express");
const jwt = require("jsonwebtoken");
const Service = require("./service");
const bcrypt = require("bcrypt");
const router = express.Router();
const https = require("https");
const { auth } = require("../../middleware/authorization");
const nodemailer = require("nodemailer");
const { token } = require("morgan");

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

//reward

router.get("/test", async (req, res) => {
  return res.status(200).json({ status: "success" });
});

router.get("/list-reward", async (req, res) => {
  const { } = req.query;
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

router.get("/get-reward", async (req, res) => {
  const { id } = req.query;
  try {

    const reward_id = Number(id);
    if (!isNaN(reward_id) && Number.isInteger(reward_id) && id.trim() != '') {
      const reward = await Service.rewardById(reward_id)
      if (reward) {
        return res.status(200).json({ status: "success", reward });
      } else {
        return res.status(404).json({ status: "error", message: "Reward not found" });
      }
    } else {
      return res.status(400).json({ status: "error", message: "Invalid reward_id" });
    }

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/redeem-qrcode", auth, async (req, res) => {
  const { reward_id } = req.body;

  try {
    if (typeof reward_id != 'number') throw new Error('reward_id is not number')

    const reward = await Service.rewardById(reward_id)
    if (reward) {
      const redeem_token = jwt.sign({ userId: req.user.userId, reward_id: reward.id }, process.env.SECRET_KEY, { expiresIn: '30m' })
      const decode = jwt.decode(redeem_token)

      return res.status(200).json({ status: "success", token: redeem_token, iat: decode.iat, exp: decode.exp });
    } else {
      return res.status(404).json({ status: "error", message: "Reward not found" });
    }

  } catch (error) {
    console.error(error);
    // console.log("error");
    if (error.message == 'reward_id is not number') {
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

module.exports = router;
