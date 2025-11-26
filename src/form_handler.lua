local utils = require("src.utils")
local client = require("src.http_client")

local M = {}

function M.process(data)
    if not utils.validate(data) then
        return false, "Invalid data"
    end
    
    local res = client.post("http://localhost:8080/packages", data)
    if res.status == 201 then
        return true, "Success"
    else
        return false, "Server error"
    end
end

return M
