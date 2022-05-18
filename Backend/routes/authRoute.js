const express = require('express');
const router = express.Router();
const dotenv = require('dotenv');
const usersController = require('../controllers/user-controller')
dotenv.config();

router.post("/googleLogin", usersController.googleLogin);

module.exports = router;