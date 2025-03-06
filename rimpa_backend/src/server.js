const express = require("express");
const app = express();
const morgan = require("morgan");
const nocache = require("nocache");
const cors = require("cors");
const path = require("path");
require('dotenv').config();
let port = process.env.PORT || 3001;

console.log("DATABASE_URL:", process.env.DATABASE_URL);

app.use(cors());
app.use(nocache());
app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// app.use("/", require("./controllers/**/controller"));
app.use("/", require("./controllers/admin/controller"));
app.use("/auth", require("./controllers/auth/controller"));
app.use("/event", require("./controllers/event/controller"));
app.use("/payment", require("./controllers/payment/controller"));
app.use("/reward", require("./controllers/reward/controller"));
app.use("/", require("./controllers/upload/controller"));
// app.use(`/public`, express.static(path.join(__dirname, '/uploads')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

//start server
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

const http = require("http");
const { Server } = require("socket.io");
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*", } });

// ให้ Express เสิร์ฟไฟล์ Static
app.use(express.static(__dirname + "/public"));

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/public/index.html");
});

app.use('/socket.io', express.static(path.join(__dirname, 'node_modules/socket.io/client-dist')));

io.on("connection", (socket) => {
  console.log(`User connected: ${socket.id}`);

  socket.on("join room", (room) => {
    socket.join(room);
    console.log(`${socket.id} joined room: ${room}`);
  });

  socket.on(`room message ${process.env.SECRET_KEY}`, ({ room, message }) => {
    console.log(`Message to room ${room}: ${message}`);
    io.to(room).emit("room message", { senderId: socket.id, message });
  });

  socket.on("disconnect", () => {
    console.log(`User disconnected: ${socket.id}`);
  });
});


server.listen(port, async () => {
  console.log(`Listening on port ${port}`);
  await prisma.role.upsert({
    where: {
      role_name: 'admin'
    },
    create: {
      role_name: 'admin'
    }, update: {}
  })
});