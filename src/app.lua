local M = {}

function M.get_title()
    return "LPM Page"
end

function M.start(port)
    port = port or 4041
    print("LPM Frontend started on port " .. port)
    
    local http = require("src.http")
    local ui = require("src.ui_renderer")
    
    local routes = {
        ["/"] = function()
            return ui.render("index.html", {title = M.get_title()})
        end,
        ["/packages"] = function()
            return ui.render("packages.html", {title = "Packages"})
        end,
        ["/upload"] = function()
            return ui.render("upload.html", {title = "Upload"})
        end,
        ["/admin"] = function()
            return ui.render("admin.html", {title = "Admin"})
        end
    }
    
    http.create_server(port, routes)
end

return M
