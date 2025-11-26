local http = require("src.http_client")
local json = require("src.json")

local M = {}

function M.search(query)
    local status, body = http.request("GET", "/projects", nil)
    if status ~= 200 then return {} end
    local projects = json.decode(body) or {}
    
    local results = {}
    for _, p in ipairs(projects) do
        if p:find(query, 1, true) then
            table.insert(results, p)
        end
    end
    return results
end

function M.render(query)
    local results = M.search(query)
    
    local html = [[
<!DOCTYPE html>
<html>
<head>
    <title>LPM - Search Results</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <header>
        <h1>LPM Repository</h1>
        <nav><a href="/">Home</a> <a href="/packages">Packages</a> <a href="/admin">Admin</a></nav>
    </header>
    <main>
        <h2>Search Results for "]] .. query .. [["</h2>
        <ul class="package-list">
]]
    
    if #results == 0 then
        html = html .. "<p>No packages found.</p>"
    else
        for _, pkg in ipairs(results) do
            html = html .. string.format('<li><a href="/package/%s">%s</a></li>', pkg, pkg)
        end
    end
    
    html = html .. [[
        </ul>
    </main>
</body>
</html>
]]
    return html
end

return M
