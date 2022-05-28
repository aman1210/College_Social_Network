const express = require("express");
const upload = require("../controllers/multer");

const postController = require("../controllers/post-controller");

const router = express.Router();

router.get("/", postController.posts_get_user_posts);

router.get("/:id", postController.posts_get_post);

router.post("/", upload.array("images", 5), postController.posts_add_post);

router.post("/:id/comment", postController.posts_add_comment);

module.exports = router;
