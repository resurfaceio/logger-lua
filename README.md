# resurfaceio-logger-lua
Easily capture API requests and responses to your own <a href="https://resurface.io">API call data lake</a>.

## Contents

<ul>
<li><a href="#dependencies">Dependencies</a></li>
<li><a href="#installing_with_luarocks">Installing With Luarocks</a></li>
<li><a href="#logging_from_nginx">Logging From NGINX</a></li>
<li><a href="#logging_with_api">Logging With API</a></li>
<li><a href="#development">Development</a></li>
<li><a href="#tests">Testing Logger</a></li>
<li><a href="#privacy">Protecting User Privacy</a></li>
</ul>

<a name="dependencies"/>

## Dependencies
Requires Lua 5.1/LuaJIT as well as the following essential packages:
- [ngx](https://github.com/openresty/lua-nginx-module#introduction)
- [lua-cjson](https://www.kyne.com.au/~mark/software/lua-cjson.php)
- [lua-ffi-zlib](https://github.com/hamishforbes/lua-ffi-zlib)
- [lua-resty-http](https://github.com/ledgetech/lua-resty-http)

<a name="installing_with_luarocks"/>

## Installing With Luarocks

```
luarocks install resurfaceio-logger
```

<a name="logging_from_nginx"/>

## Logging From NGINX
You might need to modify your `lua_package_path` and `lua_package_cpath` so that OpenResty looks for packages installed using luarocks.

- Install using luarocks.
- Add the following directives to the `http` context:

```bash
init_by_lua_block {
    local r = require "resurfaceio-logger"
    r.HttpLoggerForNginx.init{
        url="http://127.0.0.1:7701/message",
        rules="include debug"
    }
}
lua_need_request_body on;
access_by_lua_block {
    local r = require "resurfaceio-logger"
    r.HttpLoggerForNginx.access()
}

body_filter_by_lua_block {
    local r = require "resurfaceio-logger"
    r.HttpLoggerForNginx.bodyfilter()
}

log_by_lua_block {
    local r = require "resurfaceio-logger"
    r.HttpLoggerForNginx.log()
}
```

Example `nginx.conf` file:

```bash
http {
    lua_package_path '/usr/local/share/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?.lua;/home/pepper/.luarocks/share/lua/5.1/?.lua;'
    lua_package_cpath '/usr/local/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/home/pepper/.luarocks/lib/lua/5.1/?.so;'
    init_by_lua_block {
        local r = require "resurfaceio-logger"
        r.HttpLoggerForNginx.init{
            url="http://127.0.0.1:7701/message",
            rules="include debug"
        }
    }
    
    lua_need_request_body on;
    access_by_lua_block {
        local r = require "resurfaceio-logger"
        r.HttpLoggerForNginx.access()
    }
    
    body_filter_by_lua_block {
        local r = require "resurfaceio-logger"
        r.HttpLoggerForNginx.bodyfilter()
    }
    
    log_by_lua_block {
        local r = require "resurfaceio-logger"
        r.HttpLoggerForNginx.log()
    }
    
    server {
        listen 8000;
        
        location / {
            root app/www;
        }
    }
}
```
<a name="logging_with_api"/>

## Logging With API

Loggers can be directly integrated into your application using our [API](API.md). This requires the most effort compared with
the options described above, but also offers the greatest flexibility and control.

[API documentation](API.md)

<a name="development"/>

## Development
Install dev requirements.

```bash
luarocks install --only-deps resurfaceio-logger
```

<a name="tests"/>

### Testing Logger
- If you are running OpenResty, you can do
  ```bash
  resty test/test.lua
  ```
- If you don't have OpenResty installed but you do have `docker`, you can do:
  ```bash
  docker build -t loggerlua:test . && docker run -it --rm loggerlua:test
  ```
  
  Two tests are skipped if you don't have Resurface up and running. If you would like to run those tests as well, and you have docker compose, you can do:
  ```bash
  docker build -t loggerlua:test . &&  docker-compose up
  ```
  Wait for the tests to complete, and then
  ```bash
  docker-compose down --remove-orphans --volumes && docker rmi loggerlua:test
  ```
<a name="privacy"/>

## Protecting User Privacy

Loggers always have an active set of <a href="https://resurface.io/rules.html">rules</a> that control what data is logged
and how sensitive data is masked. All of the examples above apply a predefined set of rules (`include debug`),
but logging rules are easily customized to meet the needs of any application.

<a href="https://resurface.io/rules.html">Logging rules documentation</a>

---
<small>&copy; 2016-2022 <a href="https://resurface.io">Resurface Labs Inc.</a></small>
