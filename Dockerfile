FROM alpine:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apk update && apk add git \
	curl \
	tar \
	make \
	build-base \
	pcre-dev \
	openssl-dev \
	zlib-dev \
	ffmpeg \
	vim \
	autoconf

WORKDIR /usr/build
RUN git clone git://github.com/arut/nginx-rtmp-module.git
RUN curl -LO http://nginx.org/download/nginx-1.19.9.tar.gz
RUN tar -xzf nginx-1.19.9.tar.gz
WORKDIR nginx-1.19.9
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module
RUN make && make install

WORKDIR /usr/local
COPY nginx.conf /usr/local/nginx/conf
COPY init spring-blender-2019.mp4 ./
RUN rm -rf /usr/build

EXPOSE 80 8080 443 1935
CMD ["sh", "init", "stream"]
