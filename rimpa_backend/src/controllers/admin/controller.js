const express = require("express");
const jwt = require("jsonwebtoken");
const Service = require("./service");
const bcrypt = require("bcrypt");
const router = express.Router();
const https = require("https");
const { auth } = require("../../middleware/authorization");

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

router.get("/test", async (req, res) => {
  return res.status(200).json({ status: "success" });
});

router.get("/dashboard", auth, async (req, res) => {
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

router.get("/list-profile", auth, async (req, res) => {
  const { } = req.query;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
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

router.get("/profile", auth, async (req, res) => {
  const { profile_id } = req.query;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });

    const id = Number(profile_id);
    if (!isNaN(id) && Number.isInteger(id) && profile_id.trim() != '') {
      const profile = await Service.profileById(id)
      if (profile) {
        return res.status(200).json({ status: "success", profile });
      } else {
        return res.status(404).json({ status: "error", message: "Profile not found" });
      }
    } else {
      return res.status(400).json({ status: "error", message: "Invalid profile_id" });
    }

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
    return res.status(201).json({ status: "success", banner });
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
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
    const newUser = await Service.upsertUser(email, role, profile, active);
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

router.get("/list-event", auth, async (req, res) => {
  const { } = req.query;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
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

router.get("/get-event", auth, async (req, res) => {
  const { id } = req.query;
  try {

    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });

    const event_id = Number(id);
    if (!isNaN(event_id) && Number.isInteger(event_id) && id.trim() != '') {
      const event = await Service.getEvent(event_id);
      if (event) {
        return res.status(200).json({ status: "success", event });
      } else {
        return res.status(404).json({ status: "error", message: "Event not found" });
      }
    } else {
      return res.status(400).json({ status: "error", message: "Invalid event_id" });
    }


  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.get("/list-reward", auth, async (req, res) => {
  const { } = req.query;
  try {

    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
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

router.post("/update-reward", auth, async (req, res) => {
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });

    const { id, reward_name, description, startDate, endDate, img, stock, cost } = req.body;

    const reward = await Service.upsertReward(id, reward_name, description, startDate, endDate, img, stock, cost)
    return res.status(201).json({ status: "success", reward });
  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.get("/get-reward", auth, async (req, res) => {
  const { id } = req.query;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });

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

router.get("/list-banner", auth, async (req, res) => {
  const { } = req.query;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
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

router.post("/delete-user", auth, async (req, res) => {
  const { user_id } = req.body;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
    const event = await Service.deleteUser(user_id);
    return res.status(201).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/delete-event", auth, async (req, res) => {
  const { id } = req.body;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
    const event = await Service.deleteEvent(id);
    return res.status(201).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/delete-reward", auth, async (req, res) => {
  const { id } = req.body;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
    const event = await Service.deleteReward(id);
    return res.status(201).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.post("/delete-banner", auth, async (req, res) => {
  const { id } = req.body;
  try {
    if (req.user.role !== 'admin') return res.status(401).json({ status: "error", message: "Insufficient permissions" });
    const event = await Service.deleteBanner(id);
    return res.status(201).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

module.exports = router;
