local script_path = debug.getinfo(1, "S").source:match("@?(.*/)")
if not script_path then
    script_path = "./"
end
package.path = script_path .. "deps/?.lua;" .. script_path .. "deps/?/main.lua;" .. script_path .. "deps/lpm-core/src/?.lua;" .. script_path .. "src/?.lua;" .. script_path .. "src/?/init.lua;" .. package.path
package.cpath = script_path .. "deps/lpm-core/src/?.so;" .. package.cpath

local static_server = require("server.static_server")

static_server.start()
