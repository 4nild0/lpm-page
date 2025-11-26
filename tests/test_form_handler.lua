local function run()
    local handler = require("src.form_handler")
    local client = require("src.http_client")
    
    client.mock_response("POST", "http://localhost:8080/packages", {status=201})
    
    local data = {
        name = "pkg",
        version = "1.0",
        deps = "none",
        scripts = "none"
    }
    
    local ok, msg = handler.process(data)
    if not ok then error("process failed: " .. tostring(msg)) end
    
    local bad_data = {name=""}
    local ok2 = handler.process(bad_data)
    if ok2 then error("should fail invalid data") end
    
    print("test_form_handler passed")
end

if not pcall(run) then
    print("test_form_handler failed")
    os.exit(1)
end
