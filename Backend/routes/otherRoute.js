const express = require("express");
const router = express.Router();

const otherController = require("../controllers/other-controller");

router.get("/events", otherController.other_get_events);

module.exports = router;
