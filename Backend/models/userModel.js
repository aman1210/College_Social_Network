const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const userSchema = new Schema({
    name:{type:String, required:true},
    email:{type:String, required:true},
    password:{type:String, required:true},
    intro:{type:String},
    about:{type:String},
    dob:{type:String},
    location:{type:String, required:true},
    social_links:[{type:String}],
    profile_image:{type:String},
    post:[{type:String}],
    friendList:[{type:String}]
})

module.exports = mongoose.model("User", userSchema);