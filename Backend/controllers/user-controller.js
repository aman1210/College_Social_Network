const User = require("../models/userModel");

exports.user_show_friends = async (req, res, next) => {
  let curUser;
  try{
      curUser =await User.findById(req.userData.userId);
  }
  catch(err){
      return res.status(500).json({error:"Could not fetch friendList"});
  }
  if(curUser.friendList.length === 0)
  {
    return res.status(404).json({error:"FriendList is empty!!"});
  }
  let friendList = curUser.friendList;
  return res.json({friendList:friendList.map((friend)=>friend.toObject({getters:true}))});
};
