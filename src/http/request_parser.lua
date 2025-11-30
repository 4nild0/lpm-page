local HttpRequestParser = {}

function HttpRequestParser.parse(raw_request)
    local method, url = raw_request:match("^(%S+)%s+(%S+)")
    return {
        method = method,
        url = url
    }
end

return HttpRequestParser

