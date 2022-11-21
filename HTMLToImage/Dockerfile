ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}

WORKDIR /tmp
ENV PYTHONUNBUFFERED=1

# Installing Flask and html2image (and its dependency chromium for websites "screenshots")
# Ref: https://github.com/vgalin/html2image/blob/master/Dockerfile
RUN apt-get update --quiet && apt-get install -y chromium \
    && pip3 install --upgrade flask requests html2image \
    && echo 'export CHROMIUM_FLAGS="$CHROMIUM_FLAGS --no-sandbox"' >> /etc/chromium.d/default-flags

WORKDIR /code/

# Style file(s)
COPY main.css .
COPY bootstrap.css .

# Source code file(s)
COPY main.py .

ARG API_PORT
EXPOSE ${API_PORT}

ENV API_PORT=${API_PORT}
ENV FLASK_APP="main.py"

CMD [ "python3", "main.py" ]
