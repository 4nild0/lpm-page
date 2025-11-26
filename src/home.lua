local http = require("src.http_client")
local json = require("src.json")

local M = {}

function M.fetch_stats()
    local status, body = http.request("GET", "/stats", nil)
    if status ~= 200 then return { packages = 0 } end
    return json.decode(body) or { packages = 0 }
end

function M.render()
    local stats = M.fetch_stats()
    
    local html = [[
<!DOCTYPE html>
<html>
<head>
    <title>LPM - Home</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <header>
        <h1>LPM Repository</h1>
        <nav><a href="/">Home</a> <a href="/packages">Packages</a> <a href="/admin">Admin</a></nav>
    </header>
    <main>
        <h2>Welcome to LPM</h2>
        <p>The Lua Package Manager for the modern era.</p>
        
        <div class="stats">
            <h3>Statistics</h3>
            <p>Total Packages: <strong>]] .. tostring(stats.packages) .. [[</strong></p>
        </div>
        
        <div class="search">
            <h3>Search</h3>
            <form action="/search" method="get">
                <input type="text" name="q" placeholder="Search packages...">
                <button type="submit">Search</button>
            </form>
        </div>
    </main>
</body>
</html>
]]
    return html
end

return M
