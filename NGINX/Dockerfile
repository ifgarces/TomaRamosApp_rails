ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

# Installing envsubst
RUN apt-get update --quiet && apt-get install -y \
    gettext-base

ARG ${WEB_APP_PORT}
ENV WEB_APP_PORT=${WEB_APP_PORT}
COPY nginx.conf /etc/nginx/conf.d/default.conf
#RUN cat /etc/nginx/conf.d/default.conf | envsubst | tee /etc/nginx/conf.d/default.conf #! this does not work >:v

EXPOSE 80

CMD [ "nginx", "-c", "/etc/nginx/conf.d/default.conf", "-g", "daemon off;" ]
