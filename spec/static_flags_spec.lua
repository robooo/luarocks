local test_env = require("test/test_environment")
local run = test_env.run

test_env.unload_luarocks()

local extra_rocks = {
   "/luasec-0.6-1.rockspec",
   "/luasocket-3.0rc1-2.src.rock",
   "/luasocket-3.0rc1-2.rockspec",
   "/copas-2.0.2-1.rockspec",
   "/coxpcall-1.16.0-1.rockspec",
   "/luafilesystem-1.6.3-2.rockspec",
   "/xavante-2.4.0-1.rockspec",
   "/lluv-curl-0.1.0-1.rockspec",
   "/lluv-0.1.7-1.rockspec",
   "/eventemitter-0.1.1-1.rockspec",
   "/lua-curl-0.3.7-1.rockspec"
}

describe("LuaRocks add tests #blackbox #b_static_flags #unix", function()

   before_each(function()
      test_env.setup_specs(extra_rocks)
   end)

   describe("LuaRocks static_flags basic tests", function()
      it("LuaRocks static_flags for luasec module with external dependencies", function()
         assert.is_true(run.luarocks_bool("install luasec " .. test_env.OPENSSL_DIRS))
         local output = run.luarocks("static_flags luasec")
         assert.are.same(output, "luarocks-luasocket.a -lssl luarocks-luasec.a")
      end)
      it("LuaRocks static_flags for xavante module with more nested dependencies", function()
         assert.is_true(run.luarocks_bool("install xavante"))
         local output = run.luarocks("static_flags xavante")
         print(output)
         assert.are.same(output, "luarocks-luafilesystem.a luarocks-coxpcall.a luarocks-copas.a luarocks-luasocket.a luarocks-xavante.a")
      end)
      it("LuaRocks static_flags for lluv with one external dep", function()
         assert.is_true(run.luarocks_bool("install lluv"))
         local output = run.luarocks("static_flags lluv")
         assert.are.same(output, "-luv luarocks-lluv.a")
      end)
      it("LuaRocks static_flags for lluv-curl with nested external dependencies", function()
         assert.is_true(run.luarocks_bool("install lluv-curl"))
         local output = run.luarocks("static_flags lluv-curl")
         assert.are.same(output, "luarocks-eventemitter.a luarocks-lua-curl.a -luv luarocks-lluv.a luarocks-lluv-curl.a")
      end)
   end)
end)
