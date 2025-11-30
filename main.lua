package.path = "./deps/?.lua;./deps/?/main.lua;./deps/lpm-core/src/?.lua;./src/?.lua;./src/?/init.lua;" .. package.path
package.cpath = "./deps/lpm-core/src/?.so;" .. package.cpath

local sock_lib = require("lpm_socket")
local fs = require("fs")
local path = require("path")

local PORT = 3000

local function get_content_type(file_path)
    local ext = path.extension(file_path)
    local types = {
        html = "text/html",
        css = "text/css",
        js = "application/javascript",
        png = "image/png",
        jpg = "image/jpeg"
    }
    return types[ext] or "text/plain"
end

local function serve_file(client, file_path)
    if file_path == "/" then file_path = "index.html" end
    if file_path:sub(1, 1) == "/" then file_path = file_path:sub(2) end
    
    if not fs.exists(file_path) then
        local resp = "HTTP/1.1 404 Not Found\r\n\r\nFile not found"
        sock_lib.send(client, resp)
        return
    end
    
    local content = fs.read_file(file_path)
    local ctype = get_content_type(file_path)
    
    local resp = string.format(
        "HTTP/1.1 200 OK\r\nContent-Type: %s\r\nContent-Length: %d\r\n\r\n%s",
        ctype, #content, content
    )
    sock_lib.send(client, resp)
end

local function start_server()
    print("Starting static server on port " .. PORT)
    local server = sock_lib.create()
    sock_lib.bind(server, "0.0.0.0", PORT)
    sock_lib.listen(server, 5)
    
    while true do
        local client = sock_lib.accept(server)
        if client then
            local req = sock_lib.recv(client, 1024)
            if req then
                local method, url = req:match("^(%S+)%s+(%S+)")
                if method == "GET" then
                    serve_file(client, url)
                end
            end
            sock_lib.close(client)
        end
    end
end

start_server()
