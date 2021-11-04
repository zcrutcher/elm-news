const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const path = require("path");

module.exports = () => {
  const isDev = process.env.NODE_ENV !== "production";

  return {
    mode: isDev ? "development" : "production",
    cache: isDev,
    entry: {
      app: "./src/Main.elm",
    },
    output: {
      path: path.resolve(__dirname, "dist"),
      publicPath: "/dist",
      filename: "[name].js",
    },
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            {
              loader: "elm-webpack-loader",
              options: {
                debug: false,
              },
            },
          ],
        },
        {
          test: /\.s[ac]ss$/,
          use: ["style-loader", "css-loader", "sass-loader"],
        },
        { test: /\.css$/, use: ["style-loader", "css-loader"] },
      ],
    },
    resolve: {
      extensions: [".js", ".elm"],
    },
    plugins: [
      new HtmlWebpackPlugin({
        cache: false,
        chunks: ["app"],
        template: path.join(__dirname, "templates/index.html"),
        filename: "index.html",
        inject: "body",
      }),
      new CleanWebpackPlugin(),
    ],
    experiments: {
      topLevelAwait: true,
    },
  };
};
