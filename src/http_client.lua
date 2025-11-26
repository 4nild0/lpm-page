local M = {}

-- Allow injecting socket for testing
M.socket = nil

function M.load_socket()
    if M.socket then return M.socket end
    
    -- Try to find socket.so
    local paths = { "./socket.so", "../socket.so", "../../socket.so" }
    local loader = nil
    for _, p in ipairs(paths) do
        loader = package.loadlib(p, "luaopen_socket")
        if loader then break end
    end
    
    if not loader then
        error("failed to load socket extension")
    end
    
    M.socket = loader()
    return M.socket
end

function M.request(method, path, body)
    local socket = M.load_socket()
    local host = "127.0.0.1"
    local port = 4040
    
    local sock, err = socket.connect(host, port)
    if not sock then
        return nil, "connection failed: " .. tostring(err)
    end
    
    local req = string.format("%s %s HTTP/1.1\r\nHost: %s:%d\r\nConnection: close\r\n", method, path, host, port)
    if body then
        req = req .. string.format("Content-Length: %d\r\n", #body)
    end
    req = req .. "\r\n"
    if body then
        req = req .. body
    end
    
    socket.send(sock, req)
    
    -- Read response
    local response = ""
    while true do
        local chunk, err, partial = socket.receive(sock, 1024)
        if chunk then
            response = response .. chunk
        else
            if partial then response = response .. partial end
            break
        end
    end
    
    socket.close(sock)
    
    -- Parse status and body
    local status_code = tonumber(response:match("HTTP/1%.1 (%d+)"))
    local body_start = response:find("\r\n\r\n")
    local resp_body = ""
    if body_start then
        resp_body = response:sub(body_start + 4)
    end
    
    return status_code, resp_body
end

return M
