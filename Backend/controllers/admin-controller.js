const Post = require("../models/postModel");
const User = require("../models/userModel");

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
  User.find({ verified: false }, "name email profileImage")
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
      var response = {
        message: "Fetching successful!",
        ports: posts,
      };
      res.status(201).json(response);
    })
    .catch((err) => {
      res.status(402).json({
        message: "No reports found!",
        error: err,
      });
    });
};
