const express = require("express");
const path = require("path");
const fetch = require("node-fetch");
require("dotenv").config();

const app = express();

app.use(express.json());

app.use("/assets", express.static(path.join(__dirname, "../assets")));

app.use("/dist", express.static(path.join(__dirname, "../dist")));

app.get("/get-articles/:searchTerm", async (req, res) => {
  const api_url = `https://api.newscatcherapi.com/v2/search?q="${req.params.searchTerm}"&lang=en&published_date_precision=date`;
  fetch(api_url, {
    headers: {
      "x-api-key": process.env.API_KEY,
    },
  })
    .then((response) => response.json())
    .then((data) => {
      res.send(data);
    });
});

app.get("/*", (_, res) => {
  res.sendFile(path.join(__dirname, "../dist/index.html"));
});

app.listen(8080);
