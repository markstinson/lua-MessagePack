package = 'lua-MessagePack'
version = '0.1.0-1'
source = {
    url = 'http://cloud.github.com/downloads/fperrad/lua-MessagePack/lua-messagepack-0.1.0.tar.gz',
    md5 = '3fb1625aa2b277d7913ee090fd770d87',
    dir = 'lua-MessagePack-0.1.0',
}
description = {
    summary = "a pure Lua implementation",
    detailed = [[
        MessagePack is an efficient binary serialization format.

        It lets you exchange data among multiple languages like JSON but it's faster and smaller.
    ]],
    homepage = 'http://fperrad.github.com/lua-MessagePack/',
    maintainer = 'Francois Perrad',
    license = 'MIT/X11'
}
dependencies = {
    'lua >= 5.1',
}
build = {
    type = 'builtin',
    modules = {
        ['MessagePack']     = 'src/MessagePack.lua',
    },
    copy_directories = { 'doc', 'test' },
}
