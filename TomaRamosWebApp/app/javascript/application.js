// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

const MINIMUM_SCREEN_WIDTH_PX_FOR_MOBILE_NOTICE = 650; // must match MAX-WEBPAGE-WIDTH at SCSS code
const OFFSET = 200; // likely to be equal to the mobile notice width

/**
 * Toggles visibility of the mobile notice according to the current screen.
 */
function handleMobileNotice() {
    document.getElementById("BetterInMobileNotice").hidden = (
        window.innerWidth < MINIMUM_SCREEN_WIDTH_PX_FOR_MOBILE_NOTICE + OFFSET
    );
};

// Toggling visibility accordingly on both page load and resize
window.onresize = function (event) {
    handleMobileNotice();
};
window.onload = function (event) {
    handleMobileNotice();
};
