FROM nginx:alpine
MAINTAINER woodez.org

# Setup directory structure
COPY ./web_root/ /usr/share/nginx/html

#RUN adduser -u 5001 -D kwood    
#USER kwood
