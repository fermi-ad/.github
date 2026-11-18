FROM nginx:1.39.1
COPY nginx.conf /etc/nginx/nginx.conf
COPY build/web/ /usr/share/nginx/html/
