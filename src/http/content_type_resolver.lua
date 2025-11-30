local HttpContentTypeResolver = {}

local content_type_map = {
    html = "text/html",
    css = "text/css",
    js = "application/javascript",
    png = "image/png",
    jpg = "image/jpeg",
    jpeg = "image/jpeg"
}

function HttpContentTypeResolver.resolve(file_path)
    local path_module = require("path")
    local file_extension = path_module.extension(file_path)
    return content_type_map[file_extension] or "text/plain"
end

return HttpContentTypeResolver

