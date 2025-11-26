local t = require("lpm-test.src.lpm_test")
local pkg_list = require("src.package_list")
local http = require("src.http_client")

local M = {}

function M.test_render()
    -- Mock http.request
    local original_request = http.request
    http.request = function(method, path)
        if path == "/projects" then
            return 200, '["pkg-a", "pkg-b"]'
        end
        return 404, ""
    end
    
    local html = pkg_list.render()
    
    t.assert_true(html:find("pkg-a", 1, true) ~= nil, "Should contain pkg-a")
    t.assert_true(html:find("pkg-b", 1, true) ~= nil, "Should contain pkg-b")
    
    http.request = original_request
end

return M
