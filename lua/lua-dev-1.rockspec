package = "lua"
version = "dev-1"
source = {
   url = "git+https://github.com/farisachugthai/viconf.git"
}
description = {
   homepage = "https://github.com/farisachugthai/viconf",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      lsp = "lsp.lua",
      package = "package.lua",
      testplugin = "testplugin.lua"
   }
}
