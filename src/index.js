import "../styles/main.scss";
import "../src/main.css";
import SearchIcon from "./assets/search-icon.png";
import { Elm } from "../src/Main.elm";

const searchIcon = new Image();

searchIcon.src = SearchIcon;

document.getElementById("search-icon").innerHTML(searchIcon);
element.appendChild(searchIcon);

var app = Elm.Main.init({
  node: document.getElementById("myapp"),
});
