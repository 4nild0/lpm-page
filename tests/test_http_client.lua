local t = require("lpm-test.src.lpm_test")
local http_client = require("src.http_client")

local M = {}

function M.test_request()
    -- Mock socket
    local mock_socket = {}
    
    mock_socket.connect = function(host, port)
        return 123 -- Return a fake FD
    end
    
    mock_socket.send = function(sock, data)
        -- Mock send
    end
    
    mock_socket.receive = function(sock, size)
        if mock_socket.done then return nil, "closed" end
        mock_socket.done = true
        return "HTTP/1.1 200 OK\r\n\r\n{\"status\":\"ok\"}"
    end
    
    mock_socket.close = function(sock) end
    
    http_client.socket = mock_socket
    
    local status, body = http_client.request("GET", "/test", nil)
    
    t.assert_equal(200, status, "Status should be 200")
    t.assert_equal('{"status":"ok"}', body, "Body should match")
end

return M
