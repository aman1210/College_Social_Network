const Post = require("../models/postModel");
const User = require("../models/userModel");
const Event = require("../models/eventModel");

exports.admin_get_all_post = (req, res, next) => {
  Post.find({ verified: false })
    .sort({ timeStamp: -1 })
    .exec()
    .then((posts) => {
      const response = {
        message: "fetched successfully",
        count: posts.length,
        posts: posts,
      };
      res.status(200).json(response);
    })
    .catch((error) => {
      res.status(error.status || 500).json({
        message: " fetching unsuccessful",
        error: error,
      });
    });
};

exports.admin_get_all_user = (req, res, next) => {
  User.find({ verified: false }, "name email profile_image _id")
    .then((users) => {
      var response = {
        message: "Fetching successful",
        count: users.length,
        users: users,
      };
      res.status(201).json(response);
    })
    .catch((err) => {
      res.status(401).json({
        message: "Something went wrong!",
        error: err,
      });
    });
};

exports.admin_get_all_reports = (req, res, next) => {
  Post.find()
    .where("reportCount")
    .gt(10)
    .exec()
    .then((posts) => {
      if (posts.length > 0) {
        var response = {
          message: "Fetching successful!",
          reports: posts,
        };
        res.status(201).json(response);
      } else {
        res.status(201).json({
          message: "No reports pending!",
        });
      }
    })
    .catch((err) => {
      res.status(402).json({
        message: "No reports found!",
        error: err,
      });
    });
};

exports.admin_create_event = (req, res, next) => {
  const event = new Event({
    title: req.body.title,
    detail: req.body.detail,
    venue: req.body.venue,
    time: Date(req.body.time),
  });
  event
    .save()
    .then((result) => {
      res.status(201).json({
        message: "Event created successfully!",
        event: result,
      });
    })
    .catch((err) => {
      res.status(401).json({
        message: "Something is wrong!",
        error: err,
      });
    });
};

exports.admin_verify_user = (req, res, next) => {
  User.findOneAndUpdate({ _id: req.params.id }, { verified: true })
    .then((result) => {
      return res.status(200).json({
        message: "User verified",
      });
    })
    .catch((err) => {
      console.log(err);
      return res.status(402).json({
        message: "Something went wrong!",
        error: err,
      });
    });
};

exports.admin_delete_user_verification = (req, res, next) => {
  User.findOneAndDelete({ _id: req.params.id })
    .then((result) => {
      return res.status(200).json({
        message: "User deleted successfully!",
      });
    })
    .catch((err) => {
      return res.status(401).json({
        message: "Something went wrong!",
        error: err,
      });
    });
};

exports.admin_verify_post = (req, res, next) => {
  Post.findOneAndUpdate({ _id: req.params.id }, { verified: true })
    .then((result) => {
      return res.status(200).json({
        message: "Post verified",
      });
    })
    .catch((err) => {
      console.log(err);
      return res.status(402).json({
        message: "Something went wrong!",
        error: err,
      });
    });
};

exports.admin_delete_post = (req, res, next) => {
  Post.findOneAndDelete({ _id: req.params.id })
    .then((result) => {
      return res.status(200).json({
        message: "Post deleted successfully!",
      });
    })
    .catch((err) => {
      return res.status(401).json({
        message: "Something went wrong!",
        error: err,
      });
    });
};

exports.admin_create_post = (req, res, next) => {
  const post = new Post({
    createdBy: req.body.userId,
    text: req.body.text,
    images: req.body.images,
    timeStamp: req.body.timeStamp,
    userName: "Admin",
    verified: true,
  });
  post
    .save()
    .then((result) => {
      res.status(201).json({
        message:
          "Post created successfully! It will appear in feed after verification",
        post: result,
      });
    })
    .catch((error) => {
      res
        .status(error.status || 500)
        .json({ message: "Something went wrong", error: error });
    });
};
