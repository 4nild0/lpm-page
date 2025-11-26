local http = require("src.http_client")
local json = require("src.json")

local M = {}

function M.fetch_packages()
    local status, body = http.request("GET", "/projects", nil)
    if status ~= 200 then return {} end
    local res = json.decode(body)
    return res or {}
end

function M.render()
    local packages = M.fetch_packages()
    
    local html = [[
<!DOCTYPE html>
<html>
<head>
    <title>LPM Packages</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <header>
        <h1>LPM Repository</h1>
        <nav><a href="/">Home</a> <a href="/packages">Packages</a> <a href="/admin">Admin</a></nav>
    </header>
    <main>
        <h2>All Packages</h2>
        <ul class="package-list">
]]
    
    for _, pkg in ipairs(packages) do
        html = html .. string.format('<li><a href="/package/%s">%s</a></li>', pkg, pkg)
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
