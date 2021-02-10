FROM alpine

MAINTAINER "Ravuri Manoj <manojkumar.ravuri@libertymutual.com>"

ENV NGINX_VERSION nginx-1.19.6

RUN apk --update add openssl-dev pcre-dev zlib-dev wget unzip build-base && \

    mkdir -p /tmp/src && \

    cd /tmp/src && \

    wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \

    tar -zxvf ${NGINX_VERSION}.tar.gz && \

    cd /tmp/src/${NGINX_VERSION} && \

    ./configure \

        --with-http_ssl_module \

        --with-http_gzip_static_module \

        --with-http_stub_status_module \

        --prefix=/etc/nginx \

        --http-log-path=/var/log/nginx/access.log \

        --error-log-path=/var/log/nginx/error.log \

        --sbin-path=/usr/local/sbin/nginx && \

    make && \

    make install && \

    apk del build-base && \

    rm -rf /tmp/src && \

    rm -rf /var/cache/apk/*

 

#Installing Machine Agent

#RUN wget https://artifactory-apac.aws.lmig.com/artifactory/gteeast-appd-generic-np-apac/gteeast-appd-java/20.10.2/machineagent-bundle-64bit-linux-20.10.0.2813.zip \

 #   unzip machineagent-bundle-64bit-linux-20.10.0.2813.zip

#RUN ["mv","machineagent-bundle-64bit-linux-20.10.0.2813","machineagent"]

#WORKDIR machineagent

#RUN ./bin/machine-agent

 

# forward request and error logs to docker log collector

RUN ln -sf /dev/stdout /var/log/nginx/access.log

RUN ln -sf /dev/stderr /var/log/nginx/error.log

 

VOLUME ["/var/log/nginx"]

 

WORKDIR /etc/nginx

 

EXPOSE 80 443

 

CMD ["nginx", "-g", "daemon off;"]