const express = require("express");
const router = express.Router();

const otherController = require("../controllers/other-controller");

router.get("/events", otherController.other_get_events);

router.get("/notifications/:id", otherController.other_get_notifications);

module.exports = router;
