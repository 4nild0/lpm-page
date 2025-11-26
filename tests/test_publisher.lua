local t = require("lpm-test.src.lpm_test")
local publisher = require("src.publisher")
local http = require("src.http_client")

local M = {}

function M.test_publish()
    local original_request = http.request
    http.request = function(method, path, body)
        if method == "POST" and path:find("/packages") and body == "fake-content" then
            return 201, '{"status":"Uploaded"}'
        end
        return 500, "Error"
    end
    
    local ok, msg = publisher.publish("test", "1.0.0", "fake-content")
    t.assert_true(ok, "Publish should succeed")
    t.assert_equal("Published successfully", msg, "Message should match")
    
    http.request = original_request
end

function M.test_publish_fail()
    local original_request = http.request
    http.request = function() return 500, "Error" end
    
    local ok, msg = publisher.publish("test", "1.0.0", "fake-content")
    t.assert_false(ok, "Publish should fail")
    
    http.request = original_request
end

return M
