ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}

WORKDIR /tmp
ENV PYTHONUNBUFFERED=1

# Installing Flask and html2image (and its dependency chromium for websites "screenshots")
# Ref: https://github.com/vgalin/html2image/blob/master/Dockerfile
RUN apt-get update --quiet && apt-get install -y chromium \
    && pip3 install --upgrade flask html2image \
    && echo 'export CHROMIUM_FLAGS="$CHROMIUM_FLAGS --no-sandbox"' >> /etc/chromium.d/default-flags

WORKDIR /code/

COPY main.py .

ENV FLASK_APP="main.py"

ARG API_PORT
EXPOSE ${API_PORT}
ENV API_PORT=${API_PORT}

CMD [ "sh", "-c", "flask run --host 0.0.0.0 --port ${API_PORT}" ]
