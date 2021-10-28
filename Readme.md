# resurfaceio-logger-lua
Easily log API requests and responses to your own <a href="https://resurface.io">system of record</a>.

## Contents

<ul>
<li><a href="#dependencies">Dependencies</a></li>
<li><a href="#installing_with_luarocks">Installing With Luarocks</a></li>
<li><a href="#privacy">Protecting User Privacy</a></li>
</ul>

<a name="dependencies"/>

## Dependencies
Requires Lua 5.1 or higher* as well as the following essential packages:
- [lua-cjson](https://www.kyne.com.au/~mark/software/lua-cjson.php)
- [lua-zlib](https://github.com/brimworks/lua-zlib)
- [regex](https://github.com/mah0x211/lua-regex)
- [luasocket](https://github.com/diegonehab/luasocket)

\*Integration with OpenResty currently works with Lua 5.1 only

<a name="installing_with_luarocks"/>

## Installing With Luarocks

```
luarocks install resurfaceio-logger-1.1-1.rockspec
```

## Use with NGINX
You need to modify your `lua_package_path` and `lua_package_cpath` so that openresty looks for packages installed using luarocks.

- Install using luarocks.
- Add the following directives to the `http` context:

```
init_by_lua_block {
    local r = require "resurfaceio-logger"
    r.HttpLoggerForNginx.init()
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

For example:

```
http {
    lua_package_path '/usr/local/share/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?.lua;/home/pepper/.luarocks/share/lua/5.1/?.lua;'
    lua_package_cpath '/usr/local/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/home/pepper/.luarocks/lib/lua/5.1/?.so;'
    init_by_lua_block {
        local r = require "resurfaceio-logger"
        r.HttpLoggerForNginx.init()
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


## Development
Install dev requirements.

```
luarocks install --only-deps resurfaceio-logger-1.2-3.rockspec
```

### Test Logger

```
luarocks test -v
```
