const User = require("../models/userModel");
const { validationResult } = require("express-validator");

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
      return {
        name: friend.name,
        profile_image: friend.profile_image,
        _id: friend._id,
      };
    }),
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

exports.user_send_request = async (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res
      .status(422)
      .json({ error: "Invalid input passes, please check your data again." });
  }
  const userId = req.params.uid;
  User.findByIdAndUpdate(
    userId,
    { $addToSet: { friendRequest: req.userData.userId } },
    function (err, result) {
      if (err) {
        res.status(404).json({ error: "something went wrong!!" });
      } else {
        res.json(result);
      }
    }
  );
};

exports.user_accept_request = async (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res
      .status(422)
      .json({ error: "Invalid input passes, please check your data again." });
  }
  const userId = req.params.uid;
  // User.findByIdAndUpdate(userId, {$pop:{friendRequest:req.userData.userId}},function(err,result){
  //   if(err){
  //     return res.status(404).json({"error":"something went wrong!!"});
  //   }
  //   else
  //   {
  //     return res.json(result);
  //   }
  // })
  User.findByIdAndUpdate(
    userId,
    { $addToSet: { friendList: userId } },
    function (err, result) {
      if (err) {
        return res.status(404).json({ error: "something went wrong!!" });
      } else {
        return res.json(result);
      }
    }
  );
};
