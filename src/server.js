const express = require("express");
const path = require("path");
var cors = require("cors");
const url = require("url");
var app = express();

app.use(cors());
app.use(express.static("dist"));
const port = process.env.PORT || 8080;

// app.get("/*", function (req, res) {
//   res.sendFile(path.join(__dirname, "../dist/index.html"), "text/javascript");
// });

app.get("/*", (req, res) => {
  res.sendFile(path.join(__dirname, "../../dist/index.html"));
});

// sendFile will go here

app.listen(port);
console.log("Server started at http://localhost:" + port);
