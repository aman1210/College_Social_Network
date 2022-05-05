const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
dotenv.config()

const app = express();

const port = process.env.PORT || 8080;

const dbURI = "mongodb+srv://connectus:"+process.env.DATABASE_PASSWORD+"@connectus.u2hwv.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  );
  if (req.method === 'OPTIONS') {
    res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, PATCH, DELETE');
    return res.status(200).json({});
  }
  return next();
});

mongoose
  .connect(
    dbURI,
    { useNewUrlParser: true }
  )
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.log('Failed to connect to MongoDB', err));

app.get('/',(req,res)=>{
    res.send("Hello World!");
});

app.listen(port, () => console.log(`Listening on port ${port}..`));