local M = {}

function M.validate(data)
    if not data then return false end
    if not data.name or data.name == "" then return false end
    if not data.version or data.version == "" then return false end
    return true
end

function M.log(msg)
    print("[LOG] " .. tostring(msg))
end

return M
