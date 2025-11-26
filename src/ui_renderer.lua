local M = {}

function M.render_project_list(projects)
    local html = "<ul>"
    for _, p in ipairs(projects) do
        html = html .. "<li>" .. p .. "</li>"
    end
    html = html .. "</ul>"
    return html
end

return M
