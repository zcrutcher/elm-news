import "../styles/main.scss";
import "../src/main.css";
import { Elm } from "../src/Main.elm";

var app = Elm.Main.init({
  node: document.getElementById("myapp"),
});
