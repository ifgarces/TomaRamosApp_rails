"""
----------------------------------------------------------------------------------------------------
Intended to be used as microservice (ish) for the RoR web application, for converting a given
HTML+CSS into an image.

This is used instead of `wkhtml*` ruby gems, as both wkhtmltopdf and wkhtmltoimage have a serous bug
(see issue #19).
----------------------------------------------------------------------------------------------------
"""
from flask import Flask, request, send_file
import html2image, json, tempfile

app = Flask(__name__)

PNG_TMP_FILE_NAME = "screenshot.png"

@app.route("/", methods=["GET"])
def convert():
    """
    Get with parameters into body as JSON (not possible via standard GET query args). Returns the
    generated PNG file.
    """
    try:
        htmlString = request.json["html"]
        cssString = request.json["css"]
    except KeyError as e:
        return (
            json.dumps(dict(
                msg="Body parameter '%s' missing" % e,
                error=str(type(e))
            )),
            400
        )

    converter = html2image.Html2Image(size=(1920, 1080))
    converter.screenshot(html_str=htmlString, css_str=cssString, save_as=PNG_TMP_FILE_NAME)
    return send_file(PNG_TMP_FILE_NAME, mimetype="image/png")


if (__name__ == "__main__"):
    print(__doc__)
