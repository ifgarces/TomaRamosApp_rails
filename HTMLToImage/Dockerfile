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

# Getting Bootstrap CSS for default styles
RUN wget -O bootstrap.min.css https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css

COPY main.py .

ARG API_PORT
EXPOSE ${API_PORT}

ENV API_PORT=${API_PORT}
ENV FLASK_APP="main.py"

CMD [ "sh", "-c", "flask run --host 0.0.0.0 --port ${API_PORT}" ]
