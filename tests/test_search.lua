local t = require("lpm-test.src.lpm_test")
local search = require("src.search")
local http = require("src.http_client")

local M = {}

function M.test_search()
    local original_request = http.request
    http.request = function(method, path)
        if path == "/projects" then
            return 200, '["pkg-a", "pkg-b", "other"]'
        end
        return 404, ""
    end
    
    local results = search.search("pkg")
    t.assert_equal(2, #results, "Should find 2 packages")
    t.assert_equal("pkg-a", results[1], "First result match")
    t.assert_equal("pkg-b", results[2], "Second result match")
    
    local html = search.render("pkg")
    t.assert_true(html:find("pkg-a", 1, true) ~= nil, "HTML should contain pkg-a")
    
    http.request = original_request
end

return M
