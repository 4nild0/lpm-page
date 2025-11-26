local t = require("lpm-test.src.lpm_test")
local json = require("src.json")

local M = {}

function M.test_decode_array()
    local str = '["a","b","c"]'
    local res = json.decode(str)
    t.assert_equal(3, #res, "Should have 3 items")
    t.assert_equal("a", res[1], "First item should be a")
end

function M.test_decode_object()
    local str = '{"name":"test","count":1}'
    local res = json.decode(str)
    t.assert_equal("test", res.name, "Name should be test")
    t.assert_equal(1, res.count, "Count should be 1")
end

function M.test_decode_nested()
    local str = '{"list":["a"]}'
    local res = json.decode(str)
    t.assert_equal("a", res.list[1], "Nested list should work")
end

return M
