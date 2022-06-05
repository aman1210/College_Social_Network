const jwt = require("jsonwebtoken");

module.exports = (req, res, next) => {
  if (req.method === "OPTIONS") {
    return next();
  }
  // Authorization: 'Bearer Token'
  // split splits above value in two pieces and returns array
  try {
    const token = req.headers.authorization.split(" ")[1];
    if (!token) {
      res.status(500).json({error:"Authentication Failed!!"});
    }
    const decodedToken = jwt.verify(token, process.env.JWT_KEY);
    console.log(decodedToken);
    req.userData = { userId: decodedToken.userId };
    next();
  } catch (err) {
      
    return res.status(403).json({error:"Authentication Failed!!"});
  }
};