FROM openresty/openresty:1.21.4.1-centos
RUN yum update -y && yum install -y git gcc
WORKDIR /home
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "git clone https://github.com/resurfaceio/logger-lua.git && cd logger-lua && git checkout openresty && luarocks install --only-deps resurfaceio-logger-2.0-0.rockspec && resty tests/test.lua" ]