const User = require('../models/userModel');

exports.user_show_friends = async(req, res, next)=>{
    console.log(req.params.uid);
    // return next();
    
    const curUser = User.findById({_id:req.params.id});
    console.log(curUser);
    User.find({ "friendList.0": { "$exists": true } },function(err,docs) {
        console.log(docs);
        docs.
    })
    return;
    // User.find({ verified: true })
    // curUser.friendList.exec()
    // .then((friends) => {
    //   const response = {
    //     message: "fetched successfully",
    //     count: friends.length,
    //     friends: friends,
    //   };
    //   res.status(200).json(response);
    // })
    // .catch((error) => {
    //   res.status(error.status || 500).json({
    //     message: " fetching unsuccessful",
    //     error: error,
    //   });
    // });
    return;
}
