FROM nginx:1.31.9
COPY nginx.conf /etc/nginx/nginx.conf
COPY build/web/ /usr/share/nginx/html/
