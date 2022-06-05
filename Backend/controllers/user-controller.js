const User = require("../models/userModel");

exports.user_show_friends = async (req, res, next) => {
  let curUser;
  try{
      curUser =await User.findById(req.userData.userId).populate('friendList','-password');
    console.log(curUser)
    }
  catch(err){
      return res.status(500).json({error:"Could not fetch friendList"});
  }
  if(curUser.friendList.length === 0)
  {
    return res.status(404).json({error:"FriendList is empty!!"});
  }
  return res.json({"friendList":curUser.friendList.map((friend=>{
      return {"name":friend.name, "profile_image":friend.profile_image};
  } ))});
};

exports.user_profile = async (req, res, next) => {
   const userId = req.params.uid;
   let userProfile;
   try{
       userProfile = await User.findById(userId,"name email intro about dob location social_links profile_image");
   }
   catch(err){
    return res.status(500).json({"error":"Something went wrong!!"});
   }
   res.json({"userProfile":userProfile});
};