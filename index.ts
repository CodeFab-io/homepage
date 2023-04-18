import { Elm } from "./src/Main.elm";

document.addEventListener("DOMContentLoaded", function () {
    Elm.Main.init({
        node: document.querySelector("main"),
        flags: {
            width: window.innerWidth,
            height: window.innerHeight,
        },
    });
});