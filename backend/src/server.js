const express = require("express");
const app = express();
const morgan = require("morgan");
const nocache = require("nocache");
const cors = require("cors");
const path = require("path");
require('dotenv').config();
let port = process.env.PORT || 3001;

app.use(cors());
app.use(nocache());
app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// app.use("/", require("./controllers/**/controller"));
app.use("/auth", require("./controllers/auth/controller"));
// app.use(`/public`, express.static(path.join(__dirname, '/uploads')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

//start server
app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});