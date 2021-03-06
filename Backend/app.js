const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");

const authRoutes = require("./routes/authRoute");
const userRoutes = require("./routes/userRoute");
const postRoutes = require("./routes/postRoute");
const adminRoutes = require("./routes/adminRoute");
const otherRoutes = require("./routes/otherRoute");

const session = require("express-session");
dotenv.config();

const app = express();

const http = require("http").Server(app);
const io = require("socket.io")(http);

const port = process.env.PORT || 8080;

const dbURI =
  "mongodb+srv://connectus:" +
  process.env.DATABASE_PASSWORD +
  "@connectus.u2hwv.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";

app.use(express.json());

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  if (req.method === "OPTIONS") {
    res.header("Access-Control-Allow-Methods", "PUT, GET, POST, PATCH, DELETE");

    return res.status(200).json({});
  }
  return next();
});

mongoose
  .connect(dbURI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.log("Failed to connect to MongoDB", err));

app.use(
  session({
    resave: false,
    saveUninitialized: true,
    secret: "SECRET",
  })
);
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use(express.static(__dirname + "/public"));
app.use("/uploads", express.static("uploads"));

app.use("/signup", authRoutes.signup);
app.use("/login", authRoutes.login);
app.use("/admin", adminRoutes);
app.use("/user", userRoutes);
app.use("/posts", postRoutes);
app.use("/other", otherRoutes);

app.get("/", (req, res) => {
  res.send("Hello World!");
});

io.on("connection", (socket) => {
  //Get the chatID of the user and join in a room of the same chatID

  chatID = socket.handshake.query.chatID;
  socket.join(chatID);

  //Leave the room if the user closes the socket
  socket.on("disconnect", () => {
    socket.leave(chatID);
  });

  //Send message to only a particular user
  socket.on("send_message", (message) => {
    receiverChatID = message.receiverChatID;
    senderChatID = message.senderChatID;
    content = message.content;

    //Send message to only that particular room
    socket.in(receiverChatID).emit("receive_message", {
      content: content,
      senderChatID: senderChatID,
      receiverChatID: receiverChatID,
    });
  });
});

//Handling error likes invalid pages
app.use((req, res, next) => {
  let err = new Error("Not Found");
  err.status = 404;
  next(err);
});

//Handling error in database
app.use((err, req, res, next) => {
  res.status(err.status || 500);
  res.json({
    error: err.message,
  });
});

app.listen(port, () => console.log(`Listening on port ${port}..`));

