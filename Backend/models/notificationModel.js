const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const notificationSchema = new Schema({
  type: {
    type: String,
    enum: ["liked", "commented", "sent connection request"],
    required: true,
  },
  postId: { type: mongoose.Schema.Types.ObjectId, ref: "Post" },
  senderId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  timeStamp: { type: String, required: true },
});

module.exports = mongoose.model("Notification", notificationSchema);
