ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD [ "nginx", "-c", "/etc/nginx/conf.d/default.conf", "-g", "daemon off;" ]
