const express = require('express');

const userController = require("../controllers/user-controller");
const checkAuth = require('../middleware/check-auth');
const router=express.Router();

router.use(checkAuth);
router.get("/myCommunity/", userController.user_show_friends);
router.get("/profile/:uid", userController.user_profile);
router.patch("/editProfile/:uid", userController.user_edit_profile);
router.get("/friendRequests/", userController.user_show_friendRequests);
router.patch("/sendRequest/:uid", userController.user_send_request);
router.patch("/acceptRequest/:uid", userController.user_accept_request);

module.exports = router;