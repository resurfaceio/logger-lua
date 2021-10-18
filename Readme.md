# resurfaceio-logger-lua
Easily log API requests and responses to your own <a href="https://resurface.io">system of record</a>.

## Contents

<ul>
<li><a href="#dependencies">Dependencies</a></li>
<li><a href="#installing_with_luarocks">Installing With Luarocks</a></li>
...
<li><a href="#privacy">Protecting User Privacy</a></li>
</ul>

<a name="dependencies"/>

## Dependencies
Requires Lua 5.3 or higher and other essential packages.

<a name="installing_with_luarocks"/>

## Installing With Luarocks
```
luarocks install usagelogger --local
```
...
## Development
Install dev requirements.

```
luarocks install --only-deps logger-lua-dev-1.rockspec --local
```

### Test Logger

```
lua logger-tests.lua -v
```