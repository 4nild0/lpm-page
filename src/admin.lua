local M = {}

function M.render()
    local html = [[
<!DOCTYPE html>
<html>
<head>
    <title>LPM Admin</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <header>
        <h1>LPM Repository</h1>
        <nav><a href="/">Home</a> <a href="/packages">Packages</a> <a href="/admin">Admin</a></nav>
    </header>
    <main>
        <h2>Admin Panel</h2>
        <h3>Publish Package</h3>
        <form action="/publish" method="post" enctype="multipart/form-data">
            <label>Package File (.zip): <input type="file" name="file" required></label><br>
            <label>Name: <input type="text" name="name" required></label><br>
            <label>Version: <input type="text" name="version" required></label><br>
            <button type="submit">Publish</button>
        </form>
    </main>
</body>
</html>
]]
    return html
end

return M
