local function run()
    local app = require("src.app")
    
    if app.get_title() ~= "LPM Page" then error("title mismatch") end
    
    print("test_app passed")
end

if not pcall(run) then
    print("test_app failed")
    os.exit(1)
end
