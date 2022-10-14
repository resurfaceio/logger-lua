FROM openresty/openresty:1.21.4.1-centos
RUN yum update -y && yum install -y git gcc
COPY . /home/logger-lua
WORKDIR /home/logger-lua
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "luarocks install --only-deps resurfaceio-logger-2.0-0.rockspec && resty tests/test.lua" ]