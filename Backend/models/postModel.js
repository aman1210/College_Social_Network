const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const postSchema = new Schema({
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref:"User" },
  text: { type: String },
  images: [{ type: String }],
  timeStamp: { type: String, required: true },
  userName: { type: String, required: true },
  likeCount: { type: Number, default: 0 },
  commentCount: { type: Number, default: 0 },
  reportCount: { type: Number, default: 0 },
  comments: [{ type: mongoose.Schema.Types.ObjectId, ref: "Comment" }],
  verified: { type: Boolean, default: false },
});

module.exports = mongoose.model("Post", postSchema);
