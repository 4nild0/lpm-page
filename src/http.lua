local M = {}

function M.create_server(port, routes)
    port = port or 4041
    
    local function handle_request(method, path)
        local handler = routes[path]
        if handler then
            return handler()
        end
        
        return "<h1>404 Not Found</h1>", 404
    end
    
    local server = {
        port = port,
        routes = routes,
        running = false
    }
    
    function server:start()
        self.running = true
        print("HTTP Server listening on port " .. self.port)
        
        while self.running do
            local first_line = io.read()
            if not first_line then
                break
            end
            
            local method, path = first_line:match("^(%S+)%s+(%S+)")
            if method then
                local content = handle_request(method, path)
                io.write("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n" .. content)
                io.flush()
            end
        end
    end
    
    return server
end

return M
