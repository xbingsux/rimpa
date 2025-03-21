const jwt = require("jsonwebtoken");

const usedTokens = new Set();

const auth = async (req, res, next) => {
  try {
    const authHeader = req.headers["authorization"];

    // ตรวจสอบว่า authHeader มีค่าและอยู่ในรูปแบบ "Bearer <token>"
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).send("No token or Invalid token format");
    }

    const token = authHeader.split(' ')[1]; // ดึง token จาก header

    // ตรวจสอบว่า token มีค่าหรือไม่
    if (!token) {
      return res.status(401).send("No token");
    }

    // ตรวจสอบและถอดรหัส token
    const decoded = jwt.verify(token, process.env.SECRET_KEY);

    if (!decoded || !decoded.userId) {
      return res.status(401).send("Invalid token or missing user ID");
    }

    if (usedTokens.has(token)) {
      return res.status(403).json({ message: "Token already used" });
    }

    req.user = decoded; // เก็บข้อมูลผู้ใช้ใน req.user
    req.token = token // เก็บข้อมูล Token ใน req.token
    if (decoded.usedToken) usedTokens.add(token);

    next(); // ทำงานต่อ
  } catch (error) {
    if (error.name === "TokenExpiredError") {
      return res.status(401).json({ status: "error", message: "Token Expired" });
    }
    return res.status(401).json({ status: "error", message: "Invalid Token" });
  }
};

module.exports = {
  auth,
  usedTokens
};