const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const userSchema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  intro: { type: String },
  about: { type: String },
  dob: { type: String },
  location: { type: String },
  social_links: [{ type: String }],
  profile_image: { type: String, required: true },
  verified: { type: Boolean, default: true },
  post: [{ type: mongoose.Schema.Types.ObjectId, ref: "Post" }],
  friendList: [
    { type: mongoose.Schema.Types.ObjectId, ref: "User", unique: true },
  ],
  friendRequest: [
    { type: mongoose.Schema.Types.ObjectId, ref: "User", unique: true },
  ],
  notifications: [
    { type: mongoose.Schema.Types.ObjectId, ref: "Notification" },
  ],
});

module.exports = mongoose.model("User", userSchema);
