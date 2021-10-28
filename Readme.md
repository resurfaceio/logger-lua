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
Requires Lua 5.3 or higher as well as the following essential packages:
- [lua-cjson](https://www.kyne.com.au/~mark/software/lua-cjson.php)
- [lua-zlib](https://github.com/brimworks/lua-zlib)
- [regex](https://github.com/mah0x211/lua-regex)
- [luasocket](https://github.com/diegonehab/luasocket)

<a name="installing_with_luarocks"/>

## Installing With Luarocks

```
luarocks install resurfaceio-logger-1.1-1.rockspec
```
...

## Use with NGINX
You need to modify your `lua_package_path` and `lua_package_cpath` so that openresty looks for packages installed using luarocks.

Copy `HttpLoggerForNginx` to a known path inside your application.

Add the following directives to the `http` context, replacing `path/to/HttpLoggerForNginx` with the actual path in your system
```
init_by_lua_block {
  local path = "path/to/HttpLoggerForNginx"
  local r = require "resurfaceio-logger"
  local plugin = string.gsub(path, string.sub(package.config,1,1), "%.")
  r.PluginPath = plugin
  require(plugin)
}
lua_need_request_body on;
body_filter_by_lua_file path/to/HttpLoggerForNginx/body_filter.lua;
log_by_lua_file path/to/HttpLoggerForNginx/http_logger.lua;
```


## Development
Install dev requirements.

```
luarocks install --only-deps resurfaceio-logger-1.1-1.rockspec --local
```

### Test Logger

```
luarocks test -v
```
