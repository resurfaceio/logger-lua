local cjson = require('cjson')
HttpRequestImpl = require('usagelogger.http_request_impl')
HttpResponseImpl = require('usagelogger.http_response_impl')

DEMO_URL = "https://demo.resurface.io"

function mock_request()
    r = HttpRequestImpl:new()
    r.method = "GET"
    r.url = MOCK_URL
    return r
end


function mock_request_with_json()
    r = HttpRequestImpl:new()
    r.method = "POST"
    r.url = MOCK_URL.."?"..MOCK_QUERY_STRING
    r.headers["Content-Type"] = "Application/JSON"
    r.params["message"] = MOCK_JSON
    r.body = MOCK_JSON
    return r
end

function mock_request_with_json2()
    r = mock_request_with_json()
    r.headers["ABC"] = "123"
    r.headers["A"] = "1, 2"
    r.params["ABC"] = "123, 234"
    return r
end

function mock_response()
    r = HttpResponseImpl:new()
    r.status = 200
    return r
end

function mock_response_with_html()
    r = mock_response()
    r.headers["Content-Type"] = "text/html; charset=utf-8"
    r.body = MOCK_HTML
    return r
end

function string.starts(String, Start)
    return string.sub(String,1,string.len(Start))==Start
 end

 function string.ends(String, End)
    return string.sub(String, string.len(String), string.len(String))==End
 end
 
function parseable(msg)
    if (
        (msg == nil)
        or not string.starts(msg, "[")
        or not string.ends(msg, "]")
        -- or (string.match(msg, [[]]))
        -- or (string.match(msg, ",,"))
    ) then
        return false
    else
        if cjson.encode(msg) ~= nil then
            return true
        else error()
            return false
        end
    end

end


function test_good_json()
    assert (parseable("[\n]") == true)
    assert (parseable("[\n\t\n]") == true)
    assert (parseable('["A"]') == true)
    assert (parseable('["A","B"]') == true)
end



function test_invalid_json()
    assert (parseable(nil) == false)
    assert (parseable("") == false)
    assert (parseable(" ") == false)
    assert (parseable("\n\n\n\n") == false)
    assert (parseable("1234") == false)
    assert (parseable("archer") == false)
    assert (parseable('"sterling archer"') == false)
    assert (parseable(",,") == false)
    -- assert (parseable("[]") == false)
    -- assert (parseable("[,,]") == false)
    -- assert (parseable('["]') == false)
    -- assert (parseable("[:,]") == false)
    assert (parseable(",") == false)
    assert (parseable("exact words") == false)
    assert (parseable("his exact words") == false)
    assert (parseable('"exact words') == false)
    assert (parseable('his exact words"') == false)
    assert (parseable('"hello":"world" }') == false)
    assert (parseable('{ "hello":"world"') == false)
    assert (parseable('{ "hello world"}') == false)

end

local helpers = {
    DEMO_URL = DEMO_URL,
    MOCK_AGENT = "helper.py",
    MOCK_HTML = "<html>Hello World!</html>",
    MOCK_HTML2 = "<html>Hola Mundo!</html>",
    MOCK_HTML3 = "<html>1 World 2 World Red World Blue World!</html>",
    MOCK_HTML4 = "<html>1 World\n2 World\nRed World \nBlue World!\n</html>",

    MOCK_HTML5 = [[<html>
    <input type='hidden'>SECRET1</input>
    <input class='foo' type='hidden'>
    SECRET2
    </input>
    </html>]],

    MOCK_JSON = '{ "hello" : "world" }',
    MOCK_JSON_ESCAPED = '{ \\"hello\\" : \\"world\\" }',
    MOCK_NOW = 1455908640173,
    MOCK_QUERY_STRING = "foo=bar",
    MOCK_URL = "http://localhost:3000/index.html",

    MOCK_URLS_DENIED = {
        DEMO_URL .. "/noway3is5this1valid2",
        "https://www.noway3is5this1valid2.com/",
    },

    MOCK_URLS_INVALID = {
        "",
        "noway3is5this1valid2",
        "ftp:\\www.noway3is5this1valid2.com/",
        "urn:ISSN:1535–3613",
    },

    MOCK_USER_AGENT = (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:26.0) Gecko/20100101 Firefox/26.0"
    ),
    mock_request = mock_request,
    mock_request_with_json = mock_request_with_json,
    mock_request_with_json2 = mock_request_with_json2,
    mock_response = mock_response,
    mock_response_with_html = mock_response_with_html,
    parseable = parseable,
    test_good_json = test_good_json,
    test_invalid_json = test_invalid_json
}


return helpers