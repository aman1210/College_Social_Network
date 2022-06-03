const express = require('express');

const userController = require("../controllers/user-controller");
const router=express.Router();

router.get("/friendsList/:uid", userController.user_show_friends);

module.exports = router;