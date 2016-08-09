local test_env = require("test/test_environment")
local lfs = require("lfs")
local run = test_env.run
local testing_paths = test_env.testing_paths
local env_variables = test_env.env_variables

describe("Basic tests #blackbox #b_util", function()

   before_each(function()
      test_env.setup_specs()
   end)

   -- it("LuaRocks version", function()
   --    assert.is_true(run.luarocks_bool("--version"))
   -- end)

   -- it("LuaRocks unknown command", function()
   --    assert.is_false(run.luarocks_bool("unknown_command"))
   -- end)

   -- it("LuaRocks arguments fail", function()
   --    assert.is_false(run.luarocks_bool("--porcelain=invalid"))
   --    assert.is_false(run.luarocks_bool("--invalid-flag"))
   --    assert.is_false(run.luarocks_bool("--server"))
   --    assert.is_false(run.luarocks_bool("--server --porcelain"))
   --    assert.is_false(run.luarocks_bool("--invalid-flag=abc"))
   --    assert.is_false(run.luarocks_bool("invalid=5"))
   -- end)

   -- it("LuaRocks execute from not existing directory #unix", function()
   --    local main_path = lfs.currentdir()
   --    assert.is_true(lfs.mkdir("idontexist"))
   --    assert.is_true(lfs.chdir("idontexist"))
   --    local delete_path = lfs.currentdir()
   --    assert.is_true(lfs.rmdir(delete_path))
   --    -- assert.is_true(os.remove(delete_path))

   --    local output = run.luarocks("")      
   --    assert.is.falsy(output:find("LuaRocks scm, a module deployment system for Lua"))
   --    assert.is_true(lfs.chdir(main_path))

   --    output = run.luarocks("")
   --    assert.is.truthy(output:find("LuaRocks scm, a module deployment system for Lua"))
   -- end)

   -- it("LuaRocks timeout", function()
   --    assert.is.truthy(run.luarocks("--timeout=10"))
   -- end)
   
   -- it("LuaRocks timeout invalid", function()
   --    assert.is_false(run.luarocks_bool("--timeout=abc"))
   -- end)

   -- it("LuaRocks only server=testing", function()
   --    assert.is.truthy(run.luarocks("--only-server=testing"))
   -- end)
   
   -- it("LuaRocks test site config", function()
   --    assert.is.truthy(os.rename("src/luarocks/site_config.lua", "src/luarocks/site_config.lua.tmp"))
   --    assert.is.falsy(lfs.attributes("src/luarocks/site_config.lua"))
   --    assert.is.truthy(lfs.attributes("src/luarocks/site_config.lua.tmp"))

   --    assert.is.truthy(run.luarocks(""))
      
   --    assert.is.truthy(os.rename("src/luarocks/site_config.lua.tmp", "src/luarocks/site_config.lua"))
   --    assert.is.falsy(lfs.attributes("src/luarocks/site_config.lua.tmp"))
   --    assert.is.truthy(lfs.attributes("src/luarocks/site_config.lua"))
   -- end)

   -- describe("LuaRocks sysconfig fails", function()
   --    local scdir = ""
      
   --    before_each(function()
   --       scdir = testing_paths.testing_lrprefix .. "/etc/luarocks/"
   --       lfs.mkdir(testing_paths.testing_lrprefix)
   --       lfs.mkdir(testing_paths.testing_lrprefix .. "/etc/")
   --       lfs.mkdir(scdir)
   --    end)

   --    -- after_each(function()
   --    --    test_env.remove_dir(testing_paths.testing_lrprefix)
   --    -- end) 

   --    it("LuaRocks sysconfig fail", function()
   --       local sysconfig = io.open(scdir .. "/config.lua", "w+")
   --       print("SYSCONFIG IS: " .. scdir .. "/config.lua")
   --       sysconfig:write("aoeui")
   --       sysconfig:close()

   --       assert.is_false(run.luarocks_bool("list --verbose"))
   --    end)

   --    it("LuaRocks sysconfig fail", function()
   --       local sysconfig = io.open(scdir .. "/config-" .. env_variables.LUA_VERSION .. ".lua", "w+")
   --       sysconfig:write("aoeui")
   --       sysconfig:close()

   --       assert.is_false(run.luarocks_bool("list"))
   --    end)
   -- end)
end)
