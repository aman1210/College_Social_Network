const User = require("../models/userModel");
const {validationResult} = require('express-validator');
const { UserRefreshClient } = require("google-auth-library");

exports.user_show_friends = async (req, res, next) => {
  let curUser;
  try {
    curUser = await User.findById(req.userData.userId).populate(
      "friendList",
      "-password"
    );
  } catch (err) {
    return res.status(500).json({ error: "Could not fetch friendList" });
  }
  if (curUser.friendList.length === 0) {
    return res.status(404).json({ error: "FriendList is empty!!" });
  }
  return res.json({
    friendList: curUser.friendList.map((friend) => {
      return { userId: friend._id,name: friend.name, profile_image: friend.profile_image };
    })
  });
};

exports.user_profile = async (req, res, next) => {
  const userId = req.params.uid;
  let userProfile;
  try {
    userProfile = await User.findById(
      userId,
      "name email intro about dob location social_links profile_image post"
    );
  } catch (err) {
    return res.status(500).json({ error: "Something went wrong!!" });
  }
  res.json({ userProfile: userProfile });
};

exports.user_show_friendRequests = async(req,res,next)=>{
  const userId = req.userData.userId;
  let curUser;
  try{
    curUser = await User.findById(userId).populate("friendRequest", "-password");
  }
  catch(err){
    return res.status(500).json({"error":"Something went wrong!!"})
  }

  res.status(201).json({friendRequest:curUser.friendRequest.map((user)=>{
    return {userId: user._id, name:user.name, profile_image:user.profile_image};
  })});
}

exports.user_send_request = async (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res.status(422).json({"error":"Invalid input passes, please check your data again."})
  }
  const userId = req.params.uid;
  User.findByIdAndUpdate(userId, {$addToSet:{friendRequest:req.userData.userId}}
    ).then((result)=>{
    res.status(201).json(result);
  }).catch((err)=>{
    res.status(404).json({"error":"Could not send request"});
  })
};

exports.user_accept_request = async (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res.status(422).json({"error":"Invalid input passes, please check your data again."})
  }
  const userId=req.params.uid;
  const curUserId = req.userData.userId;
  
  User.updateOne(
    { _id:curUserId},
    { $pull: { friendRequest: {userId } } }
  ).then(curUser => console.log(curUser)).catch(err => console.log(err));

  User.findByIdAndUpdate(userId,{$addToSet:{friendList:{_id:req.userData.userId}}}).then((result)=>{
    res.json(result);
  }).catch((err)=>{
    res.status(500).json({"error":"Operation Could not be perfromed !!"});
  })
  console.log("HELLOO");
};
