FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

# Zmień domyślny port nginx na 8080
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf

EXPOSE 8080
