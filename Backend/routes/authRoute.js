const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/userModel");
const dotenv = require('dotenv');

dotenv.config();

const signup = async (req, res, next) => {

  const { name, email, password, location } = req.body;
  let existingUser;
  try {
    existingUser = await User.findOne({ email });
  } catch (err) {
    res.status(error.status || 500).json({ message: "Something went wrong", error: err });
  }

  if (existingUser) {
    res.status(422).json({ error: "User already exists, Please login instead !!"});
  }
  let hashedPassword;
  try {
    hashedPassword = await bcrypt.hash(password, 12);
  } catch (err) {
    res.status(500).json({ error: "Could not create user, Please try again !!"});
  }
  const createdUser = new User({
    name,
    email,
    password: hashedPassword,
    intro:"",
    about:"",
    dob:"",
    location,
    social_links:[],
    profile_image:"",
    post:[],
    friendList:[]
  });

  try {
    await createdUser.save();
  } catch (err) {
    res.status(500).json({ error: "Signup failed, Please try again !!"});
  }

  // toObject converts mongoose Object to default js object


  let token;
  try {
    token = jwt.sign(
      { userId: createdUser.id, email: createdUser.email },
      process.env.JWT_KEY,
      { expiresIn: "1h" }
    );
  } catch (err) {
    res.status(500).json({ error: "Signup failed, Please try again !!"});
  }

  res.status(201).json({ userId: createdUser.id, email: createdUser.email, token: token });
};

const login = async (req, res, next) => {
  const { email, password } = req.body;
  let existingUser;
  try {
    existingUser = await User.findOne({ email });
  } catch (err) {
    res.status(500).json({ error: "Login failed, Please try again !!"});
  }

  if (!existingUser) {
    res.status(401).json({ error: "Could not identify user, Credentials seems wrong"});
  }

  let isValidPassword = false;
  try {
    isValidPassword = await bcrypt.compare(password, existingUser.password);
  } catch (err) {
    res.status(500).json({ error: "Could not log you in, please check your credentials"});
  }

  if (!isValidPassword) {
    res.status(403).json({ error: "Invalid Credentials, could not log you in."});
  }

  let token;
  try {
    token = jwt.sign(
      { userId: existingUser.id, email: existingUser.email },
      process.env.JWT_KEY,
      { expiresIn: "1h" }
    );
  } catch (err) {
      res.status(500).json({ error: "Login failed, Please try again !!"});
    }

  res.json({
    userId: existingUser.id,
    email: existingUser.email,
    token: token,
  });
};

module.exports = {
  signup,
  login,
};