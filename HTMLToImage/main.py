"""
----------------------------------------------------------------------------------------------------
Simple HTTP endpoint for converting an HTML+CSS_STRING into an image. Intended to be used as
microservice for the TomaRamosApp RoR web application, for converting a given HTML+CSS_STRING into
an image.

This is used instead of `wkhtml*` ruby gems, as both wkhtmltopdf and wkhtmltoimage have a serous bug
(see issue #19).
----------------------------------------------------------------------------------------------------
"""

import flask, html2image, json
from os import environ

app = flask.Flask(__name__)
# app.debug = True # this will provide more verbosity

PNG_TMP_FILE_NAME :str = "screenshot.png"
OUTPUT_WIDTH :int = 720
OUTPUT_HEIGHT :int = 1080
CSS_STRING :str = None


# def debugPrintRequest(req: flask.Request) -> None:
#     print(
#         f"""
# -------------------------------------------------
# HEADERS: {req.headers}
# DATA: {req.data}
# ARGS: {req.args}
# FORM: {req.form}
# ENDPOINT: {req.endpoint}
# METHOD: {req.method}
# HOST: {req.remote_addr}
# -------------------------------------------------
#     """.strip()
#     )


def create_app(testConfig=None):
    print("Hello, I was initialized.")


@app.route("/", methods=["GET"])
def convert():
    """
    Get with parameters into body as JSON (not possible via standard GET query args). Returns the
    generated PNG file.
    """
    # debugPrintRequest(flask.request)  # * DEBUGGING - TEMPORAL
    try:
        htmlString :str = flask.request.json["html"]
    except KeyError as e:
        return (json.dumps(dict(msg="Body parameter '%s' missing" % e, error=str(type(e)))), 400)

    assert (CSS_STRING is not None) and (len(CSS_STRING) > 0)

    converter = html2image.Html2Image(size=(OUTPUT_WIDTH, OUTPUT_HEIGHT))
    if "css" in flask.request.json:
        converter.screenshot(
            html_str=htmlString,
            css_str=[CSS_STRING, flask.request.json["css"]],
            save_as=PNG_TMP_FILE_NAME,
        )
    else:
        converter.screenshot(html_str=htmlString, css_str=CSS_STRING, save_as=PNG_TMP_FILE_NAME)

    return flask.send_file(PNG_TMP_FILE_NAME, mimetype="image/png")


if __name__ == "__main__":
    print(__doc__)

    # Reading CSS from files
    CSS_STRING = ""
    for fileName in ["bootstrap.css", "main.css"]:
        with open(file=fileName, mode="rt") as bootstrapFile:
            CSS_STRING += bootstrapFile.read()

    # Running API
    app.run(host="0.0.0.0", port=environ["API_PORT"], debug=False)
