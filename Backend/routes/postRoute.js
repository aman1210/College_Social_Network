const express = require("express");
const fs = require("fs");
// const upload = require("../controllers/multer");

const postController = require("../controllers/post-controller");

const multer = require("multer");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});

const fileFilter = (req, file, cb) => {
  if (
    file.mimetype === "image/jpeg" ||
    file.mimetype === "image/jpg" ||
    file.mimetype === "image/png"
  ) {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 2,
  },
  fileFilter: fileFilter,
});

const router = express.Router();

router.get("/", postController.posts_get_user_posts);

router.get("/:id", postController.posts_get_post);

router.post("/", upload.array("images", 5), postController.posts_add_post);

router.post("/:id", postController.posts_like_post);

router.post("/:id/comment", postController.posts_add_comment);

module.exports = router;
