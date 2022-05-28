const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const commentSchema = new Schema({
    userName: {type: String,required:true},
    text: {type: String,required:true},
})

module.exports = mongoose.model("Comment", commentSchema);