local test_env = require("new_test/test_environment")
local lfs = require("lfs")

test_env.unload_luarocks()
local fetch = require("luarocks.fetch")

describe("Luarocks fetch test #whitebox #w_fetch", function()
   it("Fetch url to base dir", function()
      assert.are.same("v0.3", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2/archive/v0.3.zip"))
      assert.are.same("lua-compat-5.2", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2.zip"))
      assert.are.same("lua-compat-5.2", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2.tar.gz"))
      assert.are.same("lua-compat-5.2", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2.tar.bz2"))
      assert.are.same("parser.moon", fetch.url_to_base_dir("git://github.com/Cirru/parser.moon"))
      assert.are.same("v0.3", fetch.url_to_base_dir("https://github.com/hishamhm/lua-compat-5.2/archive/v0.3"))
   end)
end)