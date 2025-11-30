local StaticServer = {}

local DEFAULT_PORT = 3000

local function handle_client_connection(socket_library, filesystem_module, content_type_resolver, file_server, client)
    local raw_request = socket_library.recv(client, 1024)
    if not raw_request then
        return
    end
    
    local request_parser = require("http.request_parser")
    local parsed_request = request_parser.parse(raw_request)
    
    if not parsed_request then
        return
    end
    
    if parsed_request.method == "GET" then
        file_server.serve_file(socket_library, filesystem_module, content_type_resolver, client, parsed_request.url)
    end
end

local function accept_and_handle_connections(socket_library, filesystem_module, content_type_resolver, file_server, server_socket)
    while true do
        local client = socket_library.accept(server_socket)
        if not client then
            return
        end
        
        handle_client_connection(socket_library, filesystem_module, content_type_resolver, file_server, client)
        socket_library.close(client)
    end
end

function StaticServer.start(port)
    port = port or DEFAULT_PORT
    print("Starting static server on port " .. port)
    
    local socket_library = require("lpm_socket")
    local filesystem_module = require("fs")
    local content_type_resolver = require("http.content_type_resolver")
    local file_server = require("http.file_server")
    
    local server_socket = socket_library.create()
    socket_library.bind(server_socket, "0.0.0.0", port)
    socket_library.listen(server_socket, 5)
    
    accept_and_handle_connections(socket_library, filesystem_module, content_type_resolver, file_server, server_socket)
end

return StaticServer

