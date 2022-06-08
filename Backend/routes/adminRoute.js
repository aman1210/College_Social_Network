const express = require("express");
const router = express.Router();

const adminController = require("../controllers/admin-controller");

router.get("/posts", adminController.admin_get_all_post);

router.get("/users", adminController.admin_get_all_user);

router.get("/reports", adminController.admin_get_all_reports);

router.post("/event", adminController.admin_create_event);

router.post("/post", adminController.admin_create_post);

router.patch("/users/:id", adminController.admin_verify_user);

router.delete("/users/:id", adminController.admin_delete_user_verification);

router.patch("/posts/:id", adminController.admin_verify_post);

router.delete("/posts/:id", adminController.admin_delete_post);

module.exports = router;
