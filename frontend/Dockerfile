FROM nginx:alpine AS frontend

COPY ./nginx.conf /etc/nginx/nginx.conf

RUN rm -rf /usr/share/nginx/html/*

COPY ./dist /usr/share/nginx/html
