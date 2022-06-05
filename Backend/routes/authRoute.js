const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/userModel");
const dotenv = require("dotenv");

dotenv.config();

const signup = async (req, res, next) => {
  const { name, email, password, profile_image } = req.body;
  // console.log(req.body);
  let verified = true;
  let existingUser;
  try {
    existingUser = await User.findOne({ email });
  } catch (err) {
    res.status(500).json({ error: "Something went wrong" });
    return;
  }

  if (existingUser) {
    res
      .status(422)
      .json({ error: "User already exists, Please login instead !!" });
    return;
  }
  let hashedPassword;
  try {
    hashedPassword = await bcrypt.hash(password, 12);
  } catch (err) {
    res
      .status(500)
      .json({ error: "Could not create user, Please try again !!" });
    return;
  }
  if (!/@knit.ac.in/.test(email)) {
    verified = false;
  }
  const createdUser = new User({
    name,
    email,
    password: hashedPassword,
    intro: "",
    about: "",
    dob: "",
    location: "",
    social_links: [],
    profile_image,
    verified,
    post: [],
    friendList: [],
    friendRequest: [],
  });

  try {
    await createdUser.save();
  } catch (err) {
    res.status(500).json({ error: "Signup failed, Please try again !!" });
    return;
  }

  // toObject converts mongoose Object to default js object

  let token;
  try {
    token = jwt.sign(
      {
        userId: createdUser.id,
        email: createdUser.email,
        profile_image: createdUser.profile_image,
        name: createdUser.name,
      },
      process.env.JWT_KEY,
      { expiresIn: "1h" }
    );
  } catch (err) {
    res.status(500).json({ error: "Signup failed, Please try again !!" });
    return;
  }

  res.status(201).json({
    userId: createdUser.id,
    email: createdUser.email,
    token: token,
    profile_image: createdUser.profile_image,
    userName: createdUser.userName,
  });
};

const login = async (req, res, next) => {
  const { email, password } = req.body;
  let existingUser;
  try {
    existingUser = await User.findOne({ email });
  } catch (err) {
    return res.status(500).json({ error: "Login failed, Please try again !!" });
  }

  if (!existingUser) {
    res
      .status(401)
      .json({ error: "Could not identify user, Credentials seems wrong" });
    return;
  }

  let isValidPassword = false;
  try {
    isValidPassword = await bcrypt.compare(password, existingUser.password);
  } catch (err) {
    res
      .status(500)
      .json({ error: "Could not log you in, please check your credentials" });

    return;
  }

  if (!isValidPassword) {
    res
      .status(403)
      .json({ error: "Invalid Credentials, could not log you in." });
    return;
  }

  let token;
  try {
    token = jwt.sign(
      {
        userId: existingUser.id,
        email: existingUser.email,
        profile_image: existingUser.profile_image,
        name: existingUser.name,
      },
      process.env.JWT_KEY,
      { expiresIn: "1h" }
    );
  } catch (err) {
    res.status(500).json({ error: "Login failed, Please try again !!" });
    return;
  }

  res.json({
    userId: existingUser.id,
    email: existingUser.email,
    profile_image: existingUser.profile_image,
    userName: existingUser.userName,
    token: token,
  });
};

module.exports = {
  signup,
  login,
};
