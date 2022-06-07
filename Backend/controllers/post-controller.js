const Post = require("../models/postModel");
const Comment = require("../models/commentModel");
const User = require("../models/userModel");
const Notification = require("../models/notificationModel");

exports.posts_add_post = async (req, res, next) => {
  const post = new Post({
    createdBy: req.body.userId,
    text: req.body.text,
    images: req.body.images,
    timeStamp: req.body.timeStamp,
    userName: req.body.userName,
  });
  post
    .save()
    .then((result) => {
      User.findOneAndUpdate(
        { _id: req.body.userId },
        { $push: { posts: result._id } }
      )
        .then((post) => {
          res.status(201).json({
            message:
              "Post created successfully! It will appear in feed after verification",
            post: result,
          });
        })
        .catch((err) => {
          res.status(404).json({
            message: "Something went wrong!",
            error: err,
          });
        });
    })
    .catch((error) => {
      res
        .status(error.status || 500)
        .json({ message: "Something went wrong", error: error });
    });
};

exports.posts_get_user_posts = (req, res, next) => {
  Post.find({ verified: true })
    .sort({ timeStamp: -1 })
    .populate({
      path: "comments",
      options: {
        limit: 2,
        sort: { timeStamp: -1 },
      },
    })
    .populate("createdBy", "profile_image -_id")
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

exports.posts_add_comment = (req, res, next) => {
  const newcomment = new Comment({
    userName: req.body.userName,
    text: req.body.text,
    timeStamp: req.body.time,
  });
  newcomment.save();
  Post.findOneAndUpdate(
    { _id: req.params.id },
    { $push: { comments: newcomment }, $inc: { commentCount: 1 } }
  )

    .then((post) => {
      const newNotification = new Notification({
        type: "commented",
        postId: post._id,
        senderId: req.body.userId,
        timeStamp: req.body.time,
      });
      newNotification.save();
      User.findOneAndUpdate(
        { _id: post.createdBy },
        { $push: { notifications: newNotification } }
      )
        .then((result) => {
          res.status(200).json({
            message: "comment added",
            post: post,
          });
        })
        .catch((err) => {
          res.status(402).json({
            message: "something went wrong!",
            error: err,
          });
        });
    })
    .catch((err) => {
      res.status(err.status || 404).json({
        message: "Post not found!",
        error: err,
      });
    });
};

exports.posts_get_post = (req, res, next) => {
  Post.findById({ _id: req.params.id })
    .populate("comments")
    .exec()
    .then((post) => {
      res.status(201).json({ post: post });
    })
    .catch((err) => {
      res.status(404).json({
        message: "Post not found!",
        error: err,
      });
    });
};

exports.posts_like_post = (req, res, next) => {
  Post.findByIdAndUpdate(
    { _id: req.params.id },
    { $inc: { likeCount: 1 } }
  ).then((post) => {
    const newNotification = new Notification({
      type: "liked",
      postId: post._id,
      senderId: req.body.userId,
      timeStamp: req.body.timeStamp,
    });
    newNotification.save();
    User.findOneAndUpdate(
      { _id: post.createdBy },
      { $push: { notifications: newNotification } }
    )
      .then((result) => {
        res.status(201).json({ message: "Post liked!", result: result });
      })
      .catch((err) => {
        res.status(402).json({ message: "Error", err: err });
      });
  });
};

exports.posts_report_post = (req, res, next) => {
  Post.findByIdAndUpdate(
    { _id: req.params.id },
    { $inc: { reportCount: 1 } }
  ).then((post) => {
    res.status(201).json({
      message: "Post reported!",
    });
  });
};

exports.posts_edit_post = (req, res, next) => {
  Post.findOneAndUpdate(
    { _id: req.params.id },
    { $set: req.body, verified: false }
  )
    .then((result) => {
      res.status(203).json({
        message: "Post updated successfully",
        post: result,
      });
    })
    .catch((err) => {
      res.status(402).json({
        message: "Something went wrong!",
        error: err,
      });
    });
};
