// // import db from "../utils/db";
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

const authenticateEmail = async (email, password) => {
  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) {
    throw new Error("User not found");
  }
  if (user && bcrypt.compareSync(password, user.password)) {
    return { id: user.id, role: user.role, active: user.active };
  } else {
    throw new Error("Wrong password");
  }
};

module.exports = {
  authenticateEmail,
};
