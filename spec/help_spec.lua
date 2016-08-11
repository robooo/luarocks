local test_env = require("test/test_environment")
local run = test_env.run

test_env.unload_luarocks()

describe("LuaRocks help tests #blackbox #b_help", function()

   before_each(function()
      test_env.setup_specs()
   end)

   it("LuaRocks help with no flags/arguments", function()
      assert.is_true(run.luarocks_bool(test_env.quiet("help")))
   end)

   it("LuaRocks help invalid argument", function()
      assert.is_false(run.luarocks_bool("help invalid"))
   end)
   
   it("LuaRocks help config", function()
      assert.is_true(run.luarocks_bool(test_env.quiet("help config")))
   end)
   
   it("LuaRocks-admin help with no flags/arguments", function()
      assert.is_true(run.luarocks_admin_bool(test_env.quiet("help")))
   end)
end)
