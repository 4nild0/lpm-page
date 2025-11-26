local client = require("src.http_client")

local M = {}
local API_URL = "http://localhost:4040"

function M.list_projects()
    local res = client.get(API_URL .. "/projects")
    if res.status ~= 200 then return {} end
    
    local projects = {}
    for p in res.body:gmatch('"([^"]+)"') do
        table.insert(projects, p)
    end
    return projects
end

function M.get_project(name)
    local res = client.get(API_URL .. "/projects/" .. name)
    if res.status ~= 200 then return nil end
    return res.body
end

return M
