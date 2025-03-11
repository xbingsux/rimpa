const express = require("express");
const jwt = require("jsonwebtoken");
const Service = require("./service");
const bcrypt = require("bcrypt");
const router = express.Router();
const https = require("https");
const { auth, usedTokens } = require("../../middleware/authorization");
const nodemailer = require("nodemailer");

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

// router.get("/test", async (req, res) => {
//   return res.status(200).json({ status: "success" });
// });

router.post("/test", auth, async (req, res) => {
  return res.status(200).json({ status: "success" });
});

router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await Service.authenticateEmail(email, password);

    if (user) {
      console.log("#LOGIN WITH EMAIL");
      let token = null;
      if (user.active)
        token = jwt.sign({ userId: user.id, role: user.role }, process.env.SECRET_KEY, {
          expiresIn: "1d",
        });

      return res.status(200).json({
        status: "success",
        token: token,
        role: user.role,
        // active: user.active,
      });
    } else {
      return res.status(401).json({
        status: "error",
        message: "Unauthorized",
      });
    }
  } catch (error) {
    console.error(error);
    if (error.message === "User not found") {
      return res
        .status(404)
        .json({ status: "error", message: "User not found" });
    } else if (error.message === "Wrong password") {
      return res.status(401).json({
        status: "error",
        message: "Wrong password",
      });
    } else {
      return res.status(500).json({
        status: "error",
        message: "Internal Server Error",
      });
    }
  }
});

router.post("/logout", auth, async (req, res) => {
  try {
    usedTokens.add(req.token)
    return res.status(200).json({
      status: "success",
      token: req.token,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "error",
      message: "Internal Server Error",
    });
  }
});

// Email Register
router.post("/register", async (req, res) => {
  const { email, password, profile } = req.body;
  try {
    const hashedPassword = bcrypt.hashSync(password, 10);
    const newUser = await Service.register(email, hashedPassword, profile);
    if (newUser) {
      let token = jwt.sign({ userId: newUser.id, usedToken: 1 }, process.env.SECRET_KEY, {
        expiresIn: "30m",
      });

      console.log(token);
      await Service.sendVertifyUser(email, token)
    }
    return res.status(201).json({
      status: "success",
      user: newUser,
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "error",
      message: error.message//"Internal Server Error",
    });
  }
});

router.get("/verify-user", async (req, res) => {
  const { token } = req.query
  // ตรวจสอบว่า token มีค่าหรือไม่
  if (!token) {
    return res.status(401).send("No token");
  }

  // ตรวจสอบและถอดรหัส token
  let decoded
  let expired = false
  try {
    decoded = jwt.decode(token, process.env.SECRET_KEY)
    jwt.verify(token, process.env.SECRET_KEY);
  } catch (e) {
    if (e.message == 'jwt expired') {
      expired = true
    }
  }

  if (!decoded || !decoded.userId) {
    return res.status(401).send("Invalid token or missing user ID");
  }

  const item = await Service.vertifyUser(decoded.userId)
  let isSuccess = (item && item.user.active)
  console.log(item.status);
  console.log(expired);

  if (!item.status && expired) {
    res.send(`
      <style>
        body {
            margin: 0;
        }
      </style>
      <div style="background-color:#F2F2F4;position: relative;width: 100vw;height: 100vh;">
        <div style="display: grid;justify-content: center;align-items: center;row-gap: 0px;width: 500px;height: 320px;position: absolute;top: 45%;left: 50%;transform: translate(-50%,-50%);
        box-shadow: 0 4px 4px #00000040;border-radius: 16px;">
            <div>
                <div style="display: grid;justify-content: center;align-items: center;">
                  <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAYAAABV7bNHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAVTSURBVHgB7ZzLchtFFIb/ke04xCZxCIFN/ASwT4U9BXsovKYo9hR+AV4gBXs/Abc9FHtS7OEJ4lVSDrZ8SRxbmfQ/3e20xyNpdM5paaTKV9UeXSxNz69zTt9OT4EpUgKFOyy5shqOLCvh7aXavw9ceeU/hrPw/Mx9wUtMkQKZCaLccOU6vBgW56RIJzwWXrhsZBGoJso15KUSy53wOTJgKlAQZt2VNUzBOmvQkijSiaVVmVzEjIWpUwnlKnEIA9QXU3oX2sDVIDtrKNSBu8BTKBALFKzmXXir6TLHrhwWvjWcGJFApbeWO+ie1QyD1rQniU0TCxRc6j3MPtZMCvtUdLkXk3xooossvTvdxHzTL7zbtaK1QKWPN+tYDI7atnK9Nv8ULGdRxCHrZcvGZaxApe8Nz7tbNXGzbNHLHylQaK02sLjcLse0xENjUOjn3EXepnzTlQeu3HLlHt5Y6m44/ufK43DMBZv+p8P6ScsjPsignEOcT1z5zJUttHddivS3K7+GoyW8Rl5rv+nNRgsKcec2bPnKlW14q9FAsR668gts2Wuaaxom0Aewsx5azI/QC1PHWqhGV7sikGF/h+5Di/kWedmBF6oPPRyzHaUvXBLIcIxFa/kN9lYzDFrTl+GogcORJ6kV1Zt5zgLOmziW56Qea/UXUt6BjlmIY33utTLxrIsHpRdH0ylkzPkLsxEnhW72KXQx6WJAm1rQDeiwaMItYB22oeN6fFAJFIKzZvWBfZzcrdUksC4PIOdadLNoQdqlGe0vRv515WtXvgiPtfwEHZVH9dInQmg9WtdivPjGlT9deQTfZGv7NZuhblIqN7OwIAvrOcDlPkwfNh0/Td2W6Wa9UicOhxFdCMzDiLMFEmg8S/yzAjkaE54Wn0POaqUS5GhaimmxBTkqC/oI3XavCDuw0npWArWauG/gHuYHqaWvUBzpAuDHmB9uQYgmBs3TSofU2pek7kXEv8oMEP+YGoEsaRK7ExaqEegAdsTp2cg2bAXahRAu+3CyWhKHxCcdQjp/3ZX4NliGHEsLiuQSRrrw+IoudgYZjzA/SCfzK4GkGaE8qcWIOzeapetzjUDkZ9hBsXdC0S7fpGgsfVCUfiz2PmSwC/87bLiPN8Jw7PQPbOAMpVSkvWhBogzQcGKLX/sxLn8PH1u0kvwesQVxrb5X+NVEaaAmD6GHHcW0BduETYumqVuVX10NVA2SM+kO2qkPTtT/EOrxPfSDYVrPfcjZL3zGfiUQXe1DyLGMRVZ8B13mB9foB9VQI7iZZh8W/XwH3YF10YhzGpPO06VnrZst0tLzftxelQ5W+YK0NUOokEUKioaYBqMRZ5DuPbsQKLjZEXRY5enM8twn6ZNew5saKyKzEMnqnHFT3gWXBDKyIhLjwDQC9044l8UPcmW3YlOOIkXj0MMqidMqu7UOBWFTbjWrwNjzpP7isCxXLkffgS1dTwP+v2mr1KhMezbbOXYTslO5FY5txWKrxJmDP5BnHuq4mCSRnGRwtSa4OsslmTisiIJxtnI3HK0GxMMYuRVh5KJhyDy7C/niYtehKE9HbdUcuaoRPvgMi8v+uH2sY5d9wv6FeZhanZR+m/2rrdbFQkqsyUb9jnDYdt/q2029Y5BsC2dy4wbmL3AzID8rJpzWeXtjgTFobk3B+BVvaNJlpn9ripRkV3QXb26yXyjvWGUWR0pvTRbbqQyqUs1IHEutJsX6BksUh7uGZiGUqTCRbC1R2F7Fsoq8nIZyYilMZBo3eYs7iazEogiMK9lESZl6XybMNTEfgMIxPylm2tZzlc6T4yAUCnOeW5SU10q6QEk1w0+9AAAAAElFTkSuQmCC">
                </div>                
                <p style="font-size: 24px;font-weight: 600;text-align: center;">
                    บัญชีได้รับการยืนยันแล้ว
                </p>
                <p style="color: #999999;font-size: 20px;font-weight: 500;text-align: center;">
                    บัญชีของคุณได้รับการยืนยันเรียบร้อย
                </p >
            </div >
        </div >
    </div >
      `)
  } else if (item.status && !expired) {
    res.send(`
      <style>
        body {
            margin: 0;
        }
      </style>
      <div style="background-color:#F2F2F4;position: relative;width: 100vw;height: 100vh;">
        <div style="display: grid;justify-content: center;align-items: center;row-gap: 0px;width: 500px;height: 320px;position: absolute;top: 45%;left: 50%;transform: translate(-50%,-50%);
        box-shadow: 0 4px 4px #00000040;border-radius: 16px;">
            <div>
                <div style="display: grid;justify-content: center;align-items: center;">
                    ${isSuccess ?
        `<img src="data:image/png;base64,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" />`
        : `<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAYAAABV7bNHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAVTSURBVHgB7ZzLchtFFIb/ke04xCZxCIFN/ASwT4U9BXsovKYo9hR+AV4gBXs/Abc9FHtS7OEJ4lVSDrZ8SRxbmfQ/3e20xyNpdM5paaTKV9UeXSxNz69zTt9OT4EpUgKFOyy5shqOLCvh7aXavw9ceeU/hrPw/Mx9wUtMkQKZCaLccOU6vBgW56RIJzwWXrhsZBGoJso15KUSy53wOTJgKlAQZt2VNUzBOmvQkijSiaVVmVzEjIWpUwnlKnEIA9QXU3oX2sDVIDtrKNSBu8BTKBALFKzmXXir6TLHrhwWvjWcGJFApbeWO+ie1QyD1rQniU0TCxRc6j3MPtZMCvtUdLkXk3xooossvTvdxHzTL7zbtaK1QKWPN+tYDI7atnK9Nv8ULGdRxCHrZcvGZaxApe8Nz7tbNXGzbNHLHylQaK02sLjcLse0xENjUOjn3EXepnzTlQeu3HLlHt5Y6m44/ufK43DMBZv+p8P6ScsjPsignEOcT1z5zJUttHddivS3K7+GoyW8Rl5rv+nNRgsKcec2bPnKlW14q9FAsR668gts2Wuaaxom0Aewsx5azI/QC1PHWqhGV7sikGF/h+5Di/kWedmBF6oPPRyzHaUvXBLIcIxFa/kN9lYzDFrTl+GogcORJ6kV1Zt5zgLOmziW56Qea/UXUt6BjlmIY33utTLxrIsHpRdH0ylkzPkLsxEnhW72KXQx6WJAm1rQDeiwaMItYB22oeN6fFAJFIKzZvWBfZzcrdUksC4PIOdadLNoQdqlGe0vRv515WtXvgiPtfwEHZVH9dInQmg9WtdivPjGlT9deQTfZGv7NZuhblIqN7OwIAvrOcDlPkwfNh0/Td2W6Wa9UicOhxFdCMzDiLMFEmg8S/yzAjkaE54Wn0POaqUS5GhaimmxBTkqC/oI3XavCDuw0npWArWauG/gHuYHqaWvUBzpAuDHmB9uQYgmBs3TSofU2pek7kXEv8oMEP+YGoEsaRK7ExaqEegAdsTp2cg2bAXahRAu+3CyWhKHxCcdQjp/3ZX4NliGHEsLiuQSRrrw+IoudgYZjzA/SCfzK4GkGaE8qcWIOzeapetzjUDkZ9hBsXdC0S7fpGgsfVCUfiz2PmSwC/87bLiPN8Jw7PQPbOAMpVSkvWhBogzQcGKLX/sxLn8PH1u0kvwesQVxrb5X+NVEaaAmD6GHHcW0BduETYumqVuVX10NVA2SM+kO2qkPTtT/EOrxPfSDYVrPfcjZL3zGfiUQXe1DyLGMRVZ8B13mB9foB9VQI7iZZh8W/XwH3YF10YhzGpPO06VnrZst0tLzftxelQ5W+YK0NUOokEUKioaYBqMRZ5DuPbsQKLjZEXRY5enM8twn6ZNew5saKyKzEMnqnHFT3gWXBDKyIhLjwDQC9044l8UPcmW3YlOOIkXj0MMqidMqu7UOBWFTbjWrwNjzpP7isCxXLkffgS1dTwP+v2mr1KhMezbbOXYTslO5FY5txWKrxJmDP5BnHuq4mCSRnGRwtSa4OsslmTisiIJxtnI3HK0GxMMYuRVh5KJhyDy7C/niYtehKE9HbdUcuaoRPvgMi8v+uH2sY5d9wv6FeZhanZR+m/2rrdbFQkqsyUb9jnDYdt/q2029Y5BsC2dy4wbmL3AzID8rJpzWeXtjgTFobk3B+BVvaNJlpn9ripRkV3QXb26yXyjvWGUWR0pvTRbbqQyqUs1IHEutJsX6BksUh7uGZiGUqTCRbC1R2F7Fsoq8nIZyYilMZBo3eYs7iazEogiMK9lESZl6XybMNTEfgMIxPylm2tZzlc6T4yAUCnOeW5SU10q6QEk1w0+9AAAAAElFTkSuQmCC">`}
                </div>                
                <p style="font-size: 24px;font-weight: 600;text-align: center;">
                    ยืนยันสำเร็จ
                </p>
                <p style="color: #999999;font-size: 20px;font-weight: 500;text-align: center;">
                    ${isSuccess ? "บัญชีของคุณได้รับการยืนยันเรียบร้อยแล้ว" : "บัญชีของคุณยังไม่ได้รับการยืนยัน <br>โปรดตรวจสอบอีเมลของคุณ"}
                </p >
            </div >
        </div >
    </div >
      `)
  } else {
    res.send(`
      <style>
        body {
            margin: 0;
        }
      </style>
      <div style="background-color:#F2F2F4;position: relative;width: 100vw;height: 100vh;">
        <div style="display: grid;justify-content: center;align-items: center;row-gap: 0px;width: 500px;height: 320px;position: absolute;top: 45%;left: 50%;transform: translate(-50%,-50%);
        box-shadow: 0 4px 4px #00000040;border-radius: 16px;">
            <div>
                <div style="display: grid;justify-content: center;align-items: center;">
                    <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAYAAABV7bNHAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAVTSURBVHgB7ZzLchtFFIb/ke04xCZxCIFN/ASwT4U9BXsovKYo9hR+AV4gBXs/Abc9FHtS7OEJ4lVSDrZ8SRxbmfQ/3e20xyNpdM5paaTKV9UeXSxNz69zTt9OT4EpUgKFOyy5shqOLCvh7aXavw9ceeU/hrPw/Mx9wUtMkQKZCaLccOU6vBgW56RIJzwWXrhsZBGoJso15KUSy53wOTJgKlAQZt2VNUzBOmvQkijSiaVVmVzEjIWpUwnlKnEIA9QXU3oX2sDVIDtrKNSBu8BTKBALFKzmXXir6TLHrhwWvjWcGJFApbeWO+ie1QyD1rQniU0TCxRc6j3MPtZMCvtUdLkXk3xooossvTvdxHzTL7zbtaK1QKWPN+tYDI7atnK9Nv8ULGdRxCHrZcvGZaxApe8Nz7tbNXGzbNHLHylQaK02sLjcLse0xENjUOjn3EXepnzTlQeu3HLlHt5Y6m44/ufK43DMBZv+p8P6ScsjPsignEOcT1z5zJUttHddivS3K7+GoyW8Rl5rv+nNRgsKcec2bPnKlW14q9FAsR668gts2Wuaaxom0Aewsx5azI/QC1PHWqhGV7sikGF/h+5Di/kWedmBF6oPPRyzHaUvXBLIcIxFa/kN9lYzDFrTl+GogcORJ6kV1Zt5zgLOmziW56Qea/UXUt6BjlmIY33utTLxrIsHpRdH0ylkzPkLsxEnhW72KXQx6WJAm1rQDeiwaMItYB22oeN6fFAJFIKzZvWBfZzcrdUksC4PIOdadLNoQdqlGe0vRv515WtXvgiPtfwEHZVH9dInQmg9WtdivPjGlT9deQTfZGv7NZuhblIqN7OwIAvrOcDlPkwfNh0/Td2W6Wa9UicOhxFdCMzDiLMFEmg8S/yzAjkaE54Wn0POaqUS5GhaimmxBTkqC/oI3XavCDuw0npWArWauG/gHuYHqaWvUBzpAuDHmB9uQYgmBs3TSofU2pek7kXEv8oMEP+YGoEsaRK7ExaqEegAdsTp2cg2bAXahRAu+3CyWhKHxCcdQjp/3ZX4NliGHEsLiuQSRrrw+IoudgYZjzA/SCfzK4GkGaE8qcWIOzeapetzjUDkZ9hBsXdC0S7fpGgsfVCUfiz2PmSwC/87bLiPN8Jw7PQPbOAMpVSkvWhBogzQcGKLX/sxLn8PH1u0kvwesQVxrb5X+NVEaaAmD6GHHcW0BduETYumqVuVX10NVA2SM+kO2qkPTtT/EOrxPfSDYVrPfcjZL3zGfiUQXe1DyLGMRVZ8B13mB9foB9VQI7iZZh8W/XwH3YF10YhzGpPO06VnrZst0tLzftxelQ5W+YK0NUOokEUKioaYBqMRZ5DuPbsQKLjZEXRY5enM8twn6ZNew5saKyKzEMnqnHFT3gWXBDKyIhLjwDQC9044l8UPcmW3YlOOIkXj0MMqidMqu7UOBWFTbjWrwNjzpP7isCxXLkffgS1dTwP+v2mr1KhMezbbOXYTslO5FY5txWKrxJmDP5BnHuq4mCSRnGRwtSa4OsslmTisiIJxtnI3HK0GxMMYuRVh5KJhyDy7C/niYtehKE9HbdUcuaoRPvgMi8v+uH2sY5d9wv6FeZhanZR+m/2rrdbFQkqsyUb9jnDYdt/q2029Y5BsC2dy4wbmL3AzID8rJpzWeXtjgTFobk3B+BVvaNJlpn9ripRkV3QXb26yXyjvWGUWR0pvTRbbqQyqUs1IHEutJsX6BksUh7uGZiGUqTCRbC1R2F7Fsoq8nIZyYilMZBo3eYs7iazEogiMK9lESZl6XybMNTEfgMIxPylm2tZzlc6T4yAUCnOeW5SU10q6QEk1w0+9AAAAAElFTkSuQmCC">
                </div>                
                <p style="font-size: 24px;font-weight: 600;text-align: center;">
                    ลิงก์หมดอายุ
                </p>
                <p style="color: #999999;font-size: 20px;font-weight: 500;text-align: center;">
                    ขออภัย! ลิงก์นี้ไม่สามารถใช้งานได้แล้ว <br>กรุณาขอลิงก์ใหม่
                </p >
            </div >
        </div >
    </div>
      `)
  }
})

// Verify Token
router.post("/verify-token", (req, res) => {
  const { token } = req.body;
  if (!token) {
    return res.status(400).json({
      status: "error",
      message: "Token is required",
    });
  }
  jwt.verify(token, process.env.SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(401).json({
        status: "error",
        message: "Invalid or expired token",
      });
    }
    return res.status(200).json({
      status: "success",
      message: "Token is verify",
      userId: decoded.userId,
      role: decoded.role
    });
  });
});

router.put("/reset-password", async (req, res) => {
  const { token, new_password } = req.body
  // ตรวจสอบว่า token มีค่าหรือไม่
  if (!token) {
    return res.status(401).send("No token");
  }

  // ตรวจสอบและถอดรหัส token
  let decoded
  let expired = false
  try {
    decoded = jwt.decode(token, process.env.SECRET_KEY)
    jwt.verify(token, process.env.SECRET_KEY);
  } catch (e) {
    if (e.message == 'jwt expired') {
      expired = true
    }
  }

  if (!decoded || !decoded.userId) {
    return res.status(401).send("Invalid token or missing user ID");
  }

  const hashedPassword = bcrypt.hashSync(new_password, 10);
  const user = await Service.resetPassword(decoded.userId, hashedPassword)
  return res.status(201).json({
    status: "success",
    user: user,
  });
});

router.put("/reset-password-user", auth, async (req, res) => {
  const { old_password, new_password } = req.body;

  try {
    const updatedUser = await Service.resetPasswordMe(req.user.userId, old_password, new_password);

    if (!updatedUser) {
      return res.status(500).send("Failed to reset password");
    }

    return res.status(201).json({
      status: "success",
      message: "Password reset successfully",
    });
  } catch (error) {
    return res.status(500).send("Error updating password");
  }
});

router.post("/forgot-password", async (req, res) => {
  const { email } = req.body;
  console.log('email', email);

  if (!email || email == '') {
    return res.status(400).json({
      status: "error",
      message: "Email is required",
    });
  }

  try {
    const user = await Service.user(email)
    if (user) {
      let token = jwt.sign({ userId: user.id, usedToken: 1 }, process.env.SECRET_KEY, {
        expiresIn: "30m",
      });

      console.log(token);
      await Service.sendForgotPassword(email, token)

      return res.status(201).json({
        status: "success",
        user: user,
      });
    } else {
      return res.status(404).json({
        status: "fail",
        message: "No such user exists in the system."
      });
    }

  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "error",
      message: error.message//"Internal Server Error",
    });
  }
});

router.get("/profileMe", auth, async (req, res) => {
  const { } = req.query;
  try {

    const profile = await Service.profileMe(req.user.userId)

    if (profile) {
      return res.status(200).json({
        status: "success",
        profile: profile
      });
    } else {

    }
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      status: "error",
      message: "Internal Server Error",
    });
  }
});

router.post("/delete-user", auth, async (req, res) => {
  try {
    const event = await Service.deleteUser(req.user.userId);
    return res.status(201).json({ status: "success", event });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.put("/updateProfileMe", auth, async (req, res) => {
  const { profile_name, first_name, last_name, phone, birth_date, gender, profile_img, email } = req.body;

  let formattedBirthDate = null;
  if (birth_date) {
    const date = new Date(birth_date);
    if (isNaN(date.getTime())) {
      return res.status(400).json({
        status: "error",
        message: "Invalid birth_date format. Expected format: YYYY-MM-DD.",
      });
    }
    formattedBirthDate = date.toISOString().split('T')[0];
  }

  const updatedData = {
    profile_name,
    first_name,
    last_name,
    phone,
    birth_date: formattedBirthDate,
    gender,
    profile_img,
    email,
  };

  try {
    const updatedProfile = await Service.updateProfile(req.user.userId, updatedData);

    if (updatedProfile) {
      return res.status(201).json({
        status: "success",
        message: "Profile updated successfully",
        profile: updatedProfile,
      });
    } else {
      return res.status(404).json({
        status: "error",
        message: "Profile not found",
      });
    }
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "error",
      message: error.message || "Internal Server Error",
    });
  }
});

router.get("/get-noti", auth, async (req, res) => {
  const { type } = req.query
  try {
    const noti = await Service.getNoti(req.user.userId, type);
    return res.status(200).json({ status: "success", noti });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.put("/read-noti", auth, async (req, res) => {
  const { id } = req.body;
  try {
    const noti = await Service.readNoti(req.user.userId, id);
    return res.status(201).json({ status: "success", noti });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.put("/read-all-noti", auth, async (req, res) => {
  const { } = req.body;
  try {
    const noti = await Service.readAllNoti(req.user.userId);
    return res.status(201).json({ status: "success", noti });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

router.get("/point-history", auth, async (req, res) => {
  try {
    const history = await Service.pointHistory(req.user.userId);
    return res.status(200).json({ status: "success", history });

  } catch (error) {
    console.error(error);
    console.log("error");
    return res
      .status(500)
      .json({ status: "error", message: "Internal Server Error" });
  }
});

module.exports = router;
