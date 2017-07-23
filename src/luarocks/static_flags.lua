
local static_flags = {}
package.loaded["luarocks.static_flags"] = static_flags

local cfg = require("luarocks.cfg")
local fetch = require("luarocks.fetch")
local fs = require("luarocks.fs")
local manif = require("luarocks.manif")
local path = require("luarocks.path")
local search = require("luarocks.search")
local util = require("luarocks.util")

util.add_run_function(static_flags)

static_flags.help_summary = "Returns all static libraries with flags required for the compiler's Lua flag."

static_flags.help_arguments = "{<name> [<version>]}"
static_flags.help = [[
The argument may be the name of locally available module with newest version
or defined version (optional), which has already built all static libraries.

This command is useful for building an application with static libraries.

Example:
$ gcc -o myapp main.c -llua $(luarocks static-flags module_name)
]]

local function print_static_flags(collected_libs)
   for i = 1, math.floor(#collected_libs / 2) do
      collected_libs[i], collected_libs[#collected_libs - i + 1] = collected_libs[#collected_libs - i + 1], collected_libs[i]
   end
   util.printout(table.concat(collected_libs, " "))
end

local function table_contains(libs_table, name)
   for _, value in pairs(libs_table) do
      if value:match("luarocks%-"..name.."%.a") then
         return true
      end
   end
   return false
end

local function collect_libs(module_name, flags, libs_table)
   if not module_name then
      return nil, "Argument missing. "..util.see_help("static_flags")
   end

   local name, version, repo, repo_url = search.pick_installed_rock(module_name:lower(), version, flags["tree"])
   if not name then
      util.printout(name..(version and " "..version or "").." is not installed.")
      return nil, version
   end
   assert(type(repo_url) == "string")
   local manifest, err = manif.load_manifest(repo_url)
   if not manifest then
      return nil, err
   end

   local libs_table = libs_table or {}
   local rockspec = fetch.load_local_rockspec(path.rockspec_file(name, version), false)
   local minfo = manifest.repository[name][version][1]
   for lib_name in pairs(minfo.modules) do
      if lib_name:match("luarocks-(.-)" .. util.matchquote(cfg.lib_static_extension) .. "$") then
         table.insert(libs_table, cfg.home_tree..cfg.lib_modules_path..lib_name)
      end
   end

   if rockspec.external_dependencies then
      for _, desc in pairs(rockspec.external_dependencies) do
         if desc.library then
            table.insert(libs_table, "-l"..desc.library)
         end
      end
   end

   for _, dep in ipairs(rockspec.dependencies) do
      if not dep.name:match("lua$") then
         collect_libs(dep.name, flags, libs_table)
      end
   end
   return libs_table
end

function static_flags.command(flags, module_name, version)
   assert(type(version) == "string" or not version)
   local collected_libs, err = collect_libs(module_name, flags)
   if err then
      return nil, err
   end
   assert(type(collected_libs) == "table")
   print_static_flags(collected_libs)
   return collected_libs
end

return static_flags
