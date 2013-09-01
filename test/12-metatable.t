#! /usr/bin/lua

require 'Test.More'

plan(6)

local mp = require 'MessagePack'

local EXT_METATABLE = 42

mp.packers['table'] = function (buffer, t)
    local mt = getmetatable(t)
    if mt then
        local buf = {}
        mp.packers['_table'](buf, t)
        mp.packers['table'](buf, mt)
        mp.packers['ext'](buffer, EXT_METATABLE, table.concat(buf))
    else
        mp.packers['_table'](buffer, t)
    end
end

mp.build_ext = function (tag, data)
    if tag == EXT_METATABLE then
        local f = mp.unpacker(data)
        local _, t = f()
        local _, mt = f()
        return setmetatable(t, mt)
    end
end

local t = setmetatable( { 'a', 'b', 'c' }, { __index = { [4] = 'd' } } )
is( t[4], 'd' )
t = mp.unpack(mp.pack(t))
is( t[2], 'b' )
is( t[4], 'd', "follow metatable"  )

local t = setmetatable( { a = 1, b = 2, c = 3 }, { __index = { d = 4 } } )
is( t.d, 4 )
t = mp.unpack(mp.pack(t))
is( t.b, 2 )
is( t.d, 4, "follow metatable" )

