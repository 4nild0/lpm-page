local M = {}

function M.decode(str)
    if not str then return nil end
    
    -- Remove whitespace
    str = str:gsub("%s+", "")
    
    -- Handle array
    if str:sub(1, 1) == "[" and str:sub(-1) == "]" then
        local content = str:sub(2, -2)
        if content == "" then return {} end
        
        local res = {}
        for item in content:gmatch('"[^"]+"') do
            table.insert(res, item:sub(2, -2))
        end
        -- Handle numbers or other types if needed, but for now we mostly get strings in arrays
        return res
    end
    
    -- Handle object
    if str:sub(1, 1) == "{" and str:sub(-1) == "}" then
        local content = str:sub(2, -2)
        local res = {}
        -- Very simple regex for "key":"value" or "key":value
        -- This is fragile but enough for our specific server responses
        for k, v in content:gmatch('"([^"]+)":("[^"]*")') do
            res[k] = v:sub(2, -2)
        end
        for k, v in content:gmatch('"([^"]+)":(%d+)') do
            res[k] = tonumber(v)
        end
        for k, v in content:gmatch('"([^"]+)":(%[.-%])') do
            res[k] = M.decode(v)
        end
        return res
    end
    
    return nil
end

return M
