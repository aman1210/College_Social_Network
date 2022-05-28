const Post = require("../models/postModel");
const fs = require("fs");

exports.posts_add_post = (req, res, next) => {
  var imageslist = [];
  if (req.files != null) {
    for (var i = 0; i < req.files.length; i++) {
      imageslist.push(req.files[i].destination + req.files[i].filename);
    }
  }
  const post = new Post({
    text: req.body.text,
    images: imageslist,
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

exports.posts_get_user_post = (req, res, next) => {
  Post.find({ verified: false })
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
