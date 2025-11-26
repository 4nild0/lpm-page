local function run()
    local crud = require("src.crud")
    local client = require("src.http_client")
    
    client.mock_response("GET", "http://localhost:4040/projects", {
        status=200, 
        body='["proj1","proj2"]'
    })
    
    local projects = crud.list_projects()
    if #projects ~= 2 then error("list projects failed") end
    
    print("test_crud passed")
end

if not pcall(run) then
    print("test_crud failed")
    os.exit(1)
end
