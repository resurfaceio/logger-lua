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
luarocks install esurfaceio-logger-1.0-1.rockspec
```
...
## Development
Install dev requirements.

```
luarocks install --only-deps resurfaceio-logger-1.0-1.rockspec --local
```

### Test Logger

```
luarocks test -v
```
