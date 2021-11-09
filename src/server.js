const express = require("express");
const path = require("path");
const api_helper = require("./API_helper");

const app = express();

app.use(express.json());

app.use("/assets", express.static(path.join(__dirname, "../assets")));

app.use("/dist", express.static(path.join(__dirname, "../dist")));

app.get("/get-articles");

app.get("/getAPIResponse/:searchTerm", (req, res) => {
  //res.header("x-api-key", "4sO4JEcX3HwMRR7yRvxAQAE67xRBVj__psUpcKmioNc");
  api_helper
    .make_API_call(
      "https://api.newscatcherapi.com/v2/search?q=" +
        req.params.searchTerm +
        "&lang=en"
    )
    .then((response) => {
      console.log("response", response);
      res.json(response);
    })
    .catch((error) => {
      console.log("error", error);
      res.send(error);
    });
});

app.get("/*", (_, res) => {
  res.sendFile(path.join(__dirname, "../dist/index.html"));
});

app.listen(8080);
