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
app.debug = True

PNG_TMP_FILE_NAME = "screenshot.png"

@app.route("/", methods=["GET"])
def convert():
    """
    Get with parameters into body as JSON (not possible via standard GET query args). Returns the
    generated PNG file.
    """
    try:
        htmlString = request.json["html"]
    except KeyError as e:
        return (
            json.dumps(dict(
                msg="Body parameter '%s' missing" % e,
                error=str(type(e))
            )),
            400
        )

    converter = html2image.Html2Image(size=(1280, 720))
    if ("css" in request.json):
        converter.screenshot(html_str=htmlString, css_str=request.json["css"], save_as=PNG_TMP_FILE_NAME)
    else:
        converter.screenshot(html_str=htmlString, save_as=PNG_TMP_FILE_NAME)

    return send_file(PNG_TMP_FILE_NAME, mimetype="image/png")


if (__name__ == "__main__"):
    print(__doc__)
