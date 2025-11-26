local http = require("src.http_client")

local M = {}

function M.publish(name, version, file_content)
    if not name or not version or not file_content then
        return false, "Missing arguments"
    end
    
    local path = string.format("/packages?name=%s&version=%s", name, version)
    local status, body = http.request("POST", path, file_content)
    
    if status == 201 then
        return true, "Published successfully"
    else
        return false, "Failed to publish: " .. tostring(status)
    end
end

return M
