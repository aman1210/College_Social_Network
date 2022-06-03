const Notification = require("../models/notificationModel");
const Event = require("../models/eventModel");

exports.other_get_events = (req, res, next) => {
  let today = new Date();
  today.setHours(0, 0, 0, 0);

  let next3Days = new Date(today);
  next3Days.setDate(next3Days.getDate() + 3);

  Event.find({ time: { $gte: today, $lte: next3Days } })
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
