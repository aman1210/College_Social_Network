const express = require("express");
const router = express.Router();

const adminController = require("../controllers/admin-controller");

router.get("/posts", adminController.admin_get_all_post);

router.get("/users", adminController.admin_get_all_user);

router.get("/reports", adminController.admin_get_all_reports);

router.post("/event", adminController.admin_create_event);

module.exports = router;
