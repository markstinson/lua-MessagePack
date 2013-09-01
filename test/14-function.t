#! /usr/bin/lua

require 'Test.More'

plan(4)

local loadstring = loadstring or load
local mp = require 'MessagePack'
local EXT_FUNCTION = 7

mp.packers['function'] = function (buffer, fct)
    mp.packers['ext'](buffer, EXT_FUNCTION, assert(string.dump(fct)))
end

mp.build_ext = function (tag, data)
    if tag == EXT_FUNCTION then
        return assert(loadstring(data))
    end
end

local function square (n) return n * n end
is( square(2), 4 )
local result = mp.unpack(mp.pack(square))
type_ok( result, 'function' )
nok( rawequal(square, result) )
is( result(3), 9 )

