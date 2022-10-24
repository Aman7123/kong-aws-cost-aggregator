local plugin_name = "aws-cost-aggregator"
local package_name = "kong-plugin-" .. plugin_name
local package_version = "1.0.0"
local rockspec_revision = "1"

local github_account_name = "Aman7123"
local git_checkout = package_version == "dev" and "master" or package_version


package = package_name
version = package_version .. "-" .. rockspec_revision
supported_platforms = { "linux", "macosx" }
source = {
  url = "git+https://github.com/"..github_account_name.."/"..plugin_name..".git",
  branch = git_checkout,
}


description = {
  summary = "Kong is a scalable and customizable API Management Layer built on top of Nginx.",
  homepage = "https://"..github_account_name..".github.io/"..plugin_name,
  license = "Apache 2.0",
}


dependencies = {}


build = {
  type = "builtin",
  modules = {
    ["kong.plugins.aws-cost-aggregator.handler"] = "kong/plugins/aws-cost-aggregator/handler.lua",
    ["kong.plugins.aws-cost-aggregator.schema"] = "kong/plugins/aws-cost-aggregator/schema.lua",
  }
}