// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

let betterInMobileNotice, MIN_SCREEN_WIDTH_PX_FOR_MOBILE_NOTICE;

handleMobileNotice = function () {
    betterInMobileNotice.hidden = (
        document.documentElement.clientWidth < MIN_SCREEN_WIDTH_PX_FOR_MOBILE_NOTICE
    );
};

document.addEventListener("DOMContentLoaded", () => {
    betterInMobileNotice = document.getElementById("BetterInMobileNotice");
    let mainDiv = document.getElementById("MainDivWhiteLayer");
    MIN_SCREEN_WIDTH_PX_FOR_MOBILE_NOTICE = mainDiv.offsetWidth + betterInMobileNotice.offsetWidth;
    handleMobileNotice();
});

window.onresize = function (event) {
    handleMobileNotice();
};
