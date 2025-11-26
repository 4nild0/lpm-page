-- Add deps to path
package.path = package.path .. ";deps/?.lua"

local runner = require("lpm-test.src.runner")

-- Dynamically find tests or list them manually
-- For now, I'll list the ones I'm about to create
local files = {
    "tests/test_http_client.lua",
    "tests/test_json.lua",
    "tests/test_package_list.lua",
    "tests/test_package_view.lua",
    "tests/test_admin.lua",
    "tests/test_publisher.lua",
    "tests/test_home.lua",
    "tests/test_search.lua"
}

-- Check if files exist before running, to avoid error on empty list if I haven't created them yet
local fs_check = io.open(files[1], "r")
if fs_check then
    fs_check:close()
    local success = runner.run(files)
    if not success then
        os.exit(1)
    end
else
    print("No tests found yet.")
end
