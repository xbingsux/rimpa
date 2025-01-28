const jwt = require("jsonwebtoken");

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

    req.user = decoded; // เก็บข้อมูลผู้ใช้ใน req.user
    next(); // ทำงานต่อ
  } catch (error) {
    console.log(error);
    return res.status(500).send("Token Invalid");
  }
};

module.exports = auth;