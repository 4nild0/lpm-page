local http = require("src.http_client")
local json = require("src.json")

local M = {}

function M.fetch_package(name)
    local status, body = http.request("GET", "/projects/" .. name, nil)
    if status ~= 200 then return nil end
    return json.decode(body)
end

function M.render(name)
    local pkg = M.fetch_package(name)
    
    if not pkg then
        return "<h1>Package not found</h1>"
    end
    
    local html = [[
<!DOCTYPE html>
<html>
<head>
    <title>LPM - ]] .. name .. [[</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <header>
        <h1>LPM Repository</h1>
        <nav><a href="/">Home</a> <a href="/packages">Packages</a> <a href="/admin">Admin</a></nav>
    </header>
    <main>
        <h2>]] .. name .. [[</h2>
        <h3>Versions</h3>
        <ul>
]]
    
    if pkg.versions then
        for _, v in ipairs(pkg.versions) do
            html = html .. string.format('<li>%s <button onclick="navigator.clipboard.writeText(\'lpm install %s@%s\')">Copy Install Command</button></li>', v, name, v)
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
