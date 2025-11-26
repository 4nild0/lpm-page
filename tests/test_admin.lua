local t = require("lpm-test.src.lpm_test")
local admin = require("src.admin")

local M = {}

function M.test_render()
    local html = admin.render()
    t.assert_true(html:find('<form action="/publish"', 1, true) ~= nil, "Should contain publish form")
    t.assert_true(html:find('name="file"', 1, true) ~= nil, "Should contain file input")
end

return M
