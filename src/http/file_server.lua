local HttpFileServer = {}

local function send_not_found_response(socket_library, client)
    local response = "HTTP/1.1 404 Not Found\r\n\r\nFile not found"
    socket_library.send(client, response)
end

local function send_file_response(socket_library, client, file_content, content_type)
    local response = string.format(
        "HTTP/1.1 200 OK\r\nContent-Type: %s\r\nContent-Length: %d\r\n\r\n%s",
        content_type,
        #file_content,
        file_content
    )
    socket_library.send(client, response)
end

local PUBLIC_DIRECTORY = "public"

local function normalize_file_path(file_path)
    if file_path == "/" then
        return PUBLIC_DIRECTORY .. "/index.html"
    end
    if file_path:sub(1, 1) == "/" then
        return PUBLIC_DIRECTORY .. "/" .. file_path:sub(2)
    end
    return PUBLIC_DIRECTORY .. "/" .. file_path
end

function HttpFileServer.serve_file(socket_library, filesystem_module, content_type_resolver, client, file_path)
    local normalized_path = normalize_file_path(file_path)
    
    if not filesystem_module.exists(normalized_path) then
        send_not_found_response(socket_library, client)
        return
    end
    
    local file_content = filesystem_module.read_file(normalized_path)
    local content_type = content_type_resolver.resolve(normalized_path)
    send_file_response(socket_library, client, file_content, content_type)
end

return HttpFileServer

