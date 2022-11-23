/**
 * Displays the cookie consent dialog, if it exists, so backend login in templates must decide
 * whether render that dialog.
 */

document.addEventListener("DOMContentLoaded", function() {
    let cookieShowButton = document.getElementById("cookieButton");
    if (cookieShowButton != null) cookieShowButton.click();
});