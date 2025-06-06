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
  let { token, popular, limit } = req.query;
  try {
    console.log('token', token);

    let userId = null;
    if (token) {
      // ตรวจสอบและถอดรหัส token
      const decoded = jwt.verify(token, process.env.SECRET_KEY);

      if (!decoded || !decoded.userId) {
        return res.status(200).json({ status: 400, message: 'Invalid token or missing user ID' });
      }
      userId = decoded.userId;
    }

    if (isNaN(Number(limit))) {
      limit = null
    } else {
      limit = Number(limit)
    }
    const reward = await Service.listReward(userId, limit, popular)
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

    const redeem = await Service.redeemReward(req.user.userId, reward_id)
    if (redeem) {
      const barcode = `${redeem.id}`.padStart(9, '0').padStart(10, '9')
      const redeem_token = jwt.sign({ redeemId: redeem.id, userId: req.user.userId, reward_id: redeem.id }, process.env.SECRET_KEY, { expiresIn: '30m' })
      const decode = jwt.decode(redeem_token)

      return res.status(200).json({ status: "success", barcode, token: redeem_token, iat: decode.iat, exp: decode.exp });
    }

  } catch (error) {
    console.error(error);
    return res
      .status(500)
      .json({ status: "error", message: error.message });
  }
});

module.exports = router;
