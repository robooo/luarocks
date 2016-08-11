local test_env = require("test/test_environment")
local lfs = require("lfs")
local run = test_env.run
local testing_paths = test_env.testing_paths
local env_variables = test_env.env_variables
local site_config

test_env.unload_luarocks()

describe("LuaRocks config tests #blackbox #b_config", function()
   
   before_each(function()
      test_env.setup_specs()
      test_env.unload_luarocks() -- need to be required here, because site_config is created after first loading of specs
      site_config = require("luarocks.site_config")
   end)

   describe("LuaRocks config - basic tests", function()
      it("LuaRocks config with no flags/arguments", function()
         assert.is_false(run.luarocks_bool("config"))
      end)
      
      it("LuaRocks config include dir", function()
         local output = run.luarocks("config --lua-incdir")
         if test_env.TEST_TARGET_OS == "windows" then
            assert.are.same(output, site_config.LUA_INCDIR:gsub("\\","/"))
         else
            assert.are.same(output, site_config.LUA_INCDIR)
         end
      end)
      
      it("LuaRocks config library dir", function()
         local output = run.luarocks("config --lua-libdir")
         if test_env.TEST_TARGET_OS == "windows" then
            assert.are.same(output, site_config.LUA_LIBDIR:gsub("\\","/"))
         else
            assert.are.same(output, site_config.LUA_LIBDIR)
         end
      end)
      
      it("LuaRocks config lua version", function()
         local output = run.luarocks("config --lua-ver")
         local lua_version = _VERSION:gsub("Lua ", "")
         if test_env.LUAJIT_V then
            lua_version = "5.1"
         end
         assert.are.same(output, lua_version)
      end)
      
      it("LuaRocks config rock trees", function()
         assert.is_true(run.luarocks_bool("config --rock-trees"))
      end)
      
      it("LuaRocks config user config", function()
         local user_config_path = run.luarocks("config --user-config")
         assert.is.truthy(lfs.attributes(user_config_path))
      end)
      
      it("LuaRocks config missing user config", function()
         assert.is_false(run.luarocks_bool("config --user-config", {LUAROCKS_CONFIG = "missing_file.lua"}))
      end)
   end)

   describe("LuaRocks config - more complex tests", function()
      local scdir = testing_paths.testing_lrprefix .. "/etc/luarocks"
      local versioned_scname = scdir .. "/config-" .. env_variables.LUA_VERSION .. ".lua"
      local scname = scdir .. "/config.lua"
      local sysconfig = ""

      it("LuaRocks fail system config", function()
         os.rename(versioned_scname, versioned_scname .. ".bak")
         assert.is_false(run.luarocks_bool("config --system-config"))
         os.rename(versioned_scname .. ".bak", versioned_scname)
      end)
      
      it("LuaRocks system config", function()
         lfs.mkdir(testing_paths.testing_lrprefix)
         lfs.mkdir(testing_paths.testing_lrprefix .. "/etc/")
         lfs.mkdir(scdir)

         if test_env.TEST_TARGET_OS == "windows" then
            -- sysconfig = io.open(versioned_scname, "w+")
            -- sysconfig:write(" ")
            -- sysconfig:close()

            local output = run.luarocks("config --system-config")
            assert.are.same(output, versioned_scname)
         else
            sysconfig = io.open(scname, "w+")
            sysconfig:write(" ")
            sysconfig:close()
            
            local output = run.luarocks("config --system-config")
            assert.are.same(output, scname)
            os.remove(scname)
         end
      end)
      
      it("LuaRocks fail system config invalid", function()
         lfs.mkdir(testing_paths.testing_lrprefix)
         lfs.mkdir(testing_paths.testing_lrprefix .. "/etc/")
         lfs.mkdir(scdir)

         if test_env.TEST_TARGET_OS == "windows" then
            test_env.copy(versioned_scname, "versioned_scname_temp")
            sysconfig = io.open(versioned_scname, "w+")
            sysconfig:write("if if if")
            sysconfig:close()
            assert.is_false(run.luarocks_bool("config --system-config"))
            test_env.copy("versioned_scname_temp", versioned_scname)
         else
            sysconfig = io.open(scname, "w+")
            sysconfig:write("if if if")
            sysconfig:close()
            assert.is_false(run.luarocks_bool("config --system-config"))
            os.remove(scname)
         end
      end)
   end)
end)
