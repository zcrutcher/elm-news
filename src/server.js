// const express = require("express");
// const path = require("path");
// var cors = require("cors");
// const url = require("url");
// var app = express();

// app.use(cors());
// app.use(express.static("dist"));
// const port = process.env.PORT || 8080;

// // app.get("/*", function (req, res) {
// //   res.sendFile(path.join(__dirname, "../dist/index.html"), "text/javascript");
// // });

// app.get("/*", (req, res) => {
//   res.sendFile(path.join(__dirname, "../../dist/index.html"));
// });

// // sendFile will go here

// app.listen(port);
// console.log("Server started at http://localhost:" + port);

// const path = require("path");
// const express = require("express");
// const app = express(),
//   DIST_DIR = path.resolve(__dirname, "../dist"),
//   STATIC_DIR = path.resolve(__dirname, "../src");
// HTML_FILE = path.join(DIST_DIR, "/index.html");
// app.use(express.static(DIST_DIR));
// app.use(express.static(STATIC_DIR));
// app.get("/", (req, res) => {
//   res.set("Content-Type", "text/javascript");
//   res.sendFile(HTML_FILE);
// });
// app.get("/src/index.js", (req, res) => {
//   res.set("Content-Type", "text/javascript");
//   res.sendFile(STATIC_DIR + "/index.js");
// });
// app.get("/src/app.js", (req, res) => {
//   res.set("Content-Type", "text/javascript");
//   res.sendFile(STATIC_DIR + "/app.js");
// });
// const PORT = process.env.PORT || 8080;
// app.listen(PORT, () => {
//   console.log("HTML", HTML_FILE);
//   console.log(`App listening to ${PORT}....`);
//   console.log("Press Ctrl+C to quit.");
// });

const express = require("express");
const path = require("path");

//function startServer(port) {
const app = express();

app.use(express.json());

//app.use("/assets", express.static(path.join(__dirname, "../../assets")));
app.use(express.static(path.join(__dirname, "../dist")));
app.use(express.static(path.join(__dirname)));
// app.use(express.static(path.join(__dirname, "../dist")));
// app.use(express.static(path.join(__dirname, "./src")));
// app.use('/graphql', async (req, res) => {
//     axios({
//         url: 'https://www.blockloader.io/graphql',
//         method: 'POST',
//         data: req.body,
//     })
//         .then((response) => res.send(response.data))
//         .catch((response) => res.sendStatus(response.status));
// });
app.get("/index.js", function (req, res) {
  console.log("indexjs request hit");
  res.set("Content-Type", "text/javascript");
  res.sendFile(path.join(__dirname, "../src/index.js"));
});

app.get("/app.js", function (req, res) {
  console.log("appjs request hit");
  res.set("Content-Type", "text/javascript");
  res.sendFile(path.join(__dirname, `../dist/app.js`));
});

app.get("/*", (_, res) => {
  console.log("star route hit");
  //res.set("Content-Type", "text/javascript");
  res.sendFile(path.join(__dirname, "../dist/index.html"));
});
const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log(`App listening to ${port}....`);
  console.log("Press Ctrl+C to quit.");
});
// }

// module.exports = {
//   startServer,
// };
