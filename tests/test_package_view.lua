local t = require("lpm-test.src.lpm_test")
local pkg_view = require("src.package_view")
local http = require("src.http_client")

local M = {}

function M.test_render()
    -- Mock http.request
    local original_request = http.request
    http.request = function(method, path)
        if path == "/projects/test-pkg" then
            return 200, '{"name":"test-pkg","versions":["1.0.0","1.1.0"]}'
        end
        return 404, ""
    end
    
    local html = pkg_view.render("test-pkg")
    
    t.assert_true(html:find("test-pkg", 1, true) ~= nil, "Should contain package name")
    t.assert_true(html:find("1.0.0", 1, true) ~= nil, "Should contain version 1.0.0")
    t.assert_true(html:find("lpm install test-pkg@1.0.0", 1, true) ~= nil, "Should contain install command")
    
    http.request = original_request
end

function M.test_render_not_found()
    local original_request = http.request
    http.request = function() return 404, "" end
    
    local html = pkg_view.render("unknown")
    t.assert_true(html:find("Package not found", 1, true) ~= nil, "Should show not found")
    
    http.request = original_request
end

return M
