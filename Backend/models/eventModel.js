const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const eventSchema = new Schema({
  title: { type: String, required: true },
  detail: { type: String, required: true },
  venue: { type: String },
  time: { type: String },
});

module.exports = mongoose.model("Event", eventSchema);
