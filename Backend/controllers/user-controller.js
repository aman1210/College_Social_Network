// const { validationResult } = require("express-validator");
// const HttpError = require("../models/HttpError");
// const User = require("../models/user");
// const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const dotenv = require('dotenv');
const { OAuth2Client } = require("google-auth-library");

dotenv.config();

const googleLogin = async (req, res, next) => {
  const tokenIdFinal = req.body;
  console.log(tokenIdFinal);
  const tokenId=tokenIdFinal.tokenId;
  console.log(tokenId);
  const client = new OAuth2Client(
    process.env.CLIENT_ID
  );

  let ticket;
  try {
    ticket = await client.verifyIdToken({
      idToken: tokenId,
      audience:
        process.env.CLIENT_ID,
    });
  } catch (err) {
    console.log(err);
    // const error = new HttpError("Something went wrong", 500);
    // return next(error);
  }
  const {name, email, picture,at_hash} = ticket.getPayload();
  console.log(name+ " " + email);


  // let existingUser;
  // try {
  //   existingUser = await User.findOne({ email });
  // } catch (err) {
  //   const error = new HttpError(
  //     "Something went wrong, could not log u in",
  //     500
  //   );
  //   return next(error);
  // }
  // if (!existingUser) {
  //   let hashedPassword;
  //   try {
  //     hashedPassword =await bcrypt.hash(name+at_hash, 10);
  //   } catch (err) {
  //     const error = new HttpError("Something Went wrong", 500);
  //     return next(error);
  //   }

  //   const createdUser = new User({
  //     name,
  //     email,
  //     image: picture,
  //     password: hashedPassword,
  //     tasks: [],
  //   });
  //   console.log(createdUser);

  //   try {
  //     await createdUser.save();
  //   } catch (err) {
  //     console.log(err);
  //     const error = new HttpError("Signup failed, Please again Later", 500);
  //     return next(error);
  //   }

  //   let token;
  //   try {
  //     token = jwt.sign(
  //       { userId: createdUser.id, email: createdUser.email },
  //       "slim_shady",
  //       { expiresIn: 3600 }
  //     );
  //   } catch (err) {
  //     const error = new HttpError("Signup Failed Bro, please try again", 500);
  //     return next(error);
  //   }
  //   res
  //     .status(201)
  //     .json({ userId: createdUser.id, email: createdUser.email, token: token });
  // } else {
  //   let token;
  //   try {
  //     token = await jwt.sign(
  //       { userId: existingUser.id, email: existingUser.email },
  //       "slim_shady",
  //       { expiresIn: 3600 }
  //     );
  //   } catch (err) {
  //     const error = new HttpError("Login Failed, please try again", 500);
  //     return next(error);
  //   }
  //   res.json({
  //     userId: existingUser.id,
  //     email: existingUser.email,
  //     token: token,
  //   });
  // }
};
module.exports = { googleLogin };