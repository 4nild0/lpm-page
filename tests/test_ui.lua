local function run()
    local ui = require("src.ui_renderer")
    
    local html = ui.render_project_list({"a", "b"})
    if not html:find("<li>a</li>") then error("render list failed") end
    
    print("test_ui passed")
end

if not pcall(run) then
    print("test_ui failed")
    os.exit(1)
end
