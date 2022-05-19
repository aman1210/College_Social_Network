const express = require('express');
const router = express.Router();
const dotenv = require('dotenv');
const passport = require('passport');
// const usersController = require('../controllers/user-controller')
dotenv.config();

// router.post("/googleLogin", usersController.googleLogin);
const GoogleStrategy = require('passport-google-oauth').OAuth2Strategy;
const GOOGLE_CLIENT_ID = '248536460487-tm6tf1s7kds443ug3t0iaqt0mg72da1c.apps.googleusercontent.com';
const GOOGLE_CLIENT_SECRET = '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';

var userProfile;
 
router.use(passport.initialize());
router.use(passport.session());
 
// router.get('/success', (req, res) => {
//   res.render('pages/success', {user: userProfile});
// });
router.get('/error', (req, res) => res.send("error logging in"));
 
passport.serializeUser(function(user, cb) {
  cb(null, user);
});
 
passport.deserializeUser(function(obj, cb) {
  cb(null, obj);
});

passport.use(new GoogleStrategy({
    clientID: GOOGLE_CLIENT_ID,
    clientSecret: GOOGLE_CLIENT_SECRET,
    callbackURL: "http://localhost:3000/auth/"
  },
  function(accessToken, refreshToken, profile, done) {
      userProfile=profile;
      console.log(userProfile);
      return done(null, userProfile);
  }
));
 
router.get('/google', 
  passport.authenticate('google', { scope : ['profile', 'email'] }));
 
router.get('/', 
  passport.authenticate('google', { failureRedirect: '/error' }),
  function(req, res) {
    // Successful authentication, redirect success.
    console.log(res);
    res.redirect('https://connectus-9b0c5.web.app/');
  });


module.exports = router;