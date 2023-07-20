# Stage 1: Build the website with Hugo
FROM nginx:alpine as build

RUN apk add --update \
    wget
    
ARG HUGO_VERSION="0.115.2"
RUN wget --quiet "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv hugo /usr/bin

COPY ./ /site
WORKDIR /site

RUN hugo --environment production

# Stage 2: Set up Nginx 
FROM nginx:alpine

# Copy the custom 404 error page and custom Nginx configuration
COPY /layouts/404.html /usr/share/nginx/html/404.html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the static files from the build stage
COPY --from=build /site/public /usr/share/nginx/html
