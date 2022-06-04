const express = require('express');

const userController = require("../controllers/user-controller");
const checkAuth = require('../middleware/check-auth');
const router=express.Router();

router.use(checkAuth);
router.get("/myCommunity/", userController.user_show_friends);

module.exports = router;