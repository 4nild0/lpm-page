local t = require("lpm-test.src.lpm_test")
local home = require("src.home")
local http = require("src.http_client")

local M = {}

function M.test_render()
    local original_request = http.request
    http.request = function(method, path)
        if path == "/stats" then
            return 200, '{"packages":10}'
        end
        return 404, ""
    end
    
    local html = home.render()
    t.assert_true(html:find("Total Packages: <strong>10</strong>", 1, true) ~= nil, "Should show stats")
    t.assert_true(html:find('action="/search"', 1, true) ~= nil, "Should show search form")
    
    http.request = original_request
end

return M
