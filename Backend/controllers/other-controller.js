const Notification = require("../models/notificationModel");
const Event = require("../models/eventModel");
const User = require("../models/userModel");

exports.other_get_events = (req, res, next) => {
  let today = new Date();
  today.setHours(0, 0, 0, 0);

  let next3Days = new Date(today);
  next3Days.setDate(next3Days.getDate() + 3);

  Event.find({
    time: { $gte: today.toISOString(), $lte: next3Days.toISOString() },
  })
    .then((events) => {
      if (events.length == 0) {
        return res.status(201).json({
          message: "No upcoming events for next 3 days!",
        });
      }
      res.status(200).json({
        message: "Event fetched successfully",
        events: events,
      });
    })
    .catch((err) => {
      res.status(401).json({
        message: "Something went wrong!",
        err: err,
      });
    });
};

exports.other_get_notifications = (req, res, next) => {
  User.findOne({ _id: req.params.id })
    .populate({
      path: "notifications",
      populate: [
        { path: "senderId", model: "User", select: "name -_id" },
        { path: "postId", model: "Post", select: "images -_id" },
      ],
    })
    .select("notifications")
    .exec()
    .then((result) => {
      res.status(200).json({ notification: result.notifications });
    })
    .catch((err) => {
      res.status(402).json({ message: "Something went wrong!", error: err });
    });
};
