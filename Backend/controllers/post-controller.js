const Post = require("../models/postModel");
const Comment = require("../models/commentModel");
const fs = require("fs");

const cloudinary = require("./cloudinary");

exports.posts_add_post = async (req, res, next) => {
  const post = new Post({
    text: req.body.text,
    images: req.body.images,
    timeStamp: req.body.timeStamp,
    userName: req.body.userName,
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

exports.posts_get_user_posts = (req, res, next) => {
  Post.find({ verified: false })
    .sort({ timeStamp: -1 })
    .populate({
      path: "comments",
      options: {
        limit: 2,
        sort: { timeStamp: -1 },
        // skip: req.params.pageIndex * 2,
      },
    })
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
    { $push: { comments: newcomment } }
  )

    .then((post) => {
      console.log(newcomment);
      res.status(200).json({
        message: "comment added",
        post: post,
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
    res.status(201).json({ message: "Post liked!" });
  });
};
