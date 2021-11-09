const HtmlWebpackPlugin = require("html-webpack-plugin");
const path = require("path");
console.log("Path being logged: ", path.resolve(__dirname));
const src = path.resolve(__dirname, "../src");
const root = path.resolve(__dirname, "../");
module.exports = {
  entry: {
    app: src + "/index.js",
  },
  mode: "production",
  output: {
    filename: "[name].js",
    path: root + "/dist",
    publicPath: "/dist",
  },
  resolve: {
    extensions: [".js", ".elm"],
    modules: ["node_modules"],
  },
  target: "node",
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: "babel-loader",
            options: {
              plugins: ["module:babel-elm-assets-plugin"],
            },
          },
          {
            loader: "elm-webpack-loader",
            options: {
              debug: false,
              optimize: false,
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        use: ["style-loader", "css-loader", "sass-loader"],
      },
      { test: /\.css$/, use: ["style-loader", "css-loader"] },
      {
        test: /\.(png|svg|jpg|jpeg|gif)$/i,
        type: "asset/resource",
      },
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components|server.js)/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env"],
            plugins: ["@babel/plugin-syntax-dynamic-import"],
          },
        },
      },
      {
        // Loads the javacript into html template provided.
        // Entry point is set below in HtmlWebPackPlugin in Plugins
        test: /\.html$/,
        use: [{ loader: "html-loader" }],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      cache: false,
      chunks: ["app"],
      template: path.join(__dirname, "../templates/index.html"),
      filename: "index.html",
      inject: "head",
    }),
  ],
};
