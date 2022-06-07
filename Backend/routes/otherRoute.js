const express = require("express");
const router = express.Router();
// const checkAuth = require('../middleware/check-auth');

const otherController = require("../controllers/other-controller");

router.get("/events", otherController.other_get_events);

router.get("/notifications/:id", otherController.other_get_notifications);

router.get("/searchResults",otherController.other_get_search_results);

module.exports = router;
