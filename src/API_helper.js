const request = require("request");

module.exports = {
  make_API_call: function (url) {
    return new Promise((resolve, reject) => {
      request(
        url,
        { "x-api-key": "4sO4JEcX3HwMRR7yRvxAQAE67xRBVj__psUpcKmioNc" },
        { json: true },
        (err, res, body) => {
          if (err) reject(err);
          resolve(body);
        }
      );
    });
  },
};
