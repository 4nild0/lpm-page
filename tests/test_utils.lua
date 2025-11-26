local function run()
    local utils = require("src.utils")
    
    local valid_data = {
        name = "pkg",
        version = "1.0.0",
        deps = "none",
        scripts = "none"
    }
    
    if not utils.validate(valid_data) then error("valid data failed") end
    
    local invalid_data = {
        name = "",
        version = "1.0.0"
    }
    
    if utils.validate(invalid_data) then error("invalid data passed") end
    
    print("test_utils passed")
end

if not pcall(run) then
    print("test_utils failed")
    os.exit(1)
end
