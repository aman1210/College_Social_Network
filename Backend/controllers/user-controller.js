// // const { validationResult } = require("express-validator");
// // const HttpError = require("../models/HttpError");
// // const User = require("../models/user");
// // const bcrypt = require("bcryptjs");
// const jwt = require("jsonwebtoken");
// const dotenv = require('dotenv');

// const GoogleStrategy = require('passport-google-oauth').OAuth2Strategy;
// const GOOGLE_CLIENT_ID = '248536460487-tm6tf1s7kds443ug3t0iaqt0mg72da1c.apps.googleusercontent.com';
// const GOOGLE_CLIENT_SECRET = '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';


// passport.use(new GoogleStrategy({
//     clientID: GOOGLE_CLIENT_ID,
//     clientSecret: GOOGLE_CLIENT_SECRET,
//     callbackURL: "http://localhost:3000/auth/google/callback"
//   },
//   function(accessToken, refreshToken, profile, done) {
//       userProfile=profile;
//       return done(null, userProfile);
//   }
// ));
 
// app.get('/auth/google', 
//   passport.authenticate('google', { scope : ['profile', 'email'] }));
 
// app.get('/auth/google/callback', 
//   passport.authenticate('google', { failureRedirect: '/error' }),
//   function(req, res) {
//     // Successful authentication, redirect success.
//     res.redirect('/success');
//   });


// module.exports = { googleLogin };