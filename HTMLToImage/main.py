"""
----------------------------------------------------------------------------------------------------
Simple HTTP endpoint for converting an HTML+CSS into an image. Intended to be used as microservice
for the TomaRamosApp RoR web application, for converting a given HTML+CSS into an image.

This is used instead of `wkhtml*` ruby gems, as both wkhtmltopdf and wkhtmltoimage have a serous bug
(see issue #19).
----------------------------------------------------------------------------------------------------
"""

import flask, requests
import html2image, json

app = flask.Flask(__name__)
# app.debug = True # this will provide more verbosity

PNG_TMP_FILE_NAME = "screenshot.png"


def debugPrintRequest(req: flask.Request) -> None:
    print(
        f"""
-------------------------------------------------
HEADERS: {req.headers}
DATA: {req.data}
ARGS: {req.args}
FORM: {req.form}
ENDPOINT: {req.endpoint}
METHOD: {req.method}
HOST: {req.remote_addr}
-------------------------------------------------
    """.strip()
    )


@app.route("/", methods=["GET"])
def convert():
    """
    Get with parameters into body as JSON (not possible via standard GET query args). Returns the
    generated PNG file.
    """
    debugPrintRequest(flask.request)  #!
    try:
        htmlString = flask.request.json["html"]
    except KeyError as e:
        return (json.dumps(dict(msg="Body parameter '%s' missing" % e, error=str(type(e)))), 400)

    bootstrapCSS = open(file="bootstrap.min.css", mode="rt").read()

    converter = html2image.Html2Image(size=(1280, 720))
    if "css" in flask.request.json:
        converter.screenshot(
            html_str=htmlString,
            css_str=[bootstrapCSS, flask.request.json["css"]],
            save_as=PNG_TMP_FILE_NAME,
        )
    else:
        converter.screenshot(html_str=htmlString, css_str=bootstrapCSS, save_as=PNG_TMP_FILE_NAME)

    return flask.send_file(PNG_TMP_FILE_NAME, mimetype="image/png")


if __name__ == "__main__":
    print(__doc__)
