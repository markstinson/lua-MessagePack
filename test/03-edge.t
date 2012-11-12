#! /usr/bin/lua

require 'Test.More'

plan(11)

local mp = require 'MessagePack'

is( mp.unpack(mp.pack(1/0)), 1/0, "inf" )

is( mp.unpack(mp.pack(-1/0)), -1/0, "-inf" )

local nan = mp.unpack(mp.pack(0/0))
type_ok( nan, 'number', "nan" )
ok( nan ~= nan )

is( mp.pack{}:byte(), 0x90, "empty table as array" )

local t = setmetatable( { 'a', 'b', 'c' }, { __index = { [4] = 'd' } } )
is( t[4], 'd' )
t = mp.unpack(mp.pack(t))
is( t[2], 'b' )
is( t[4], nil, "don't follow metatable" )

local t = setmetatable( { a = 1, b = 2, c = 3 }, { __index = { d = 4 } } )
is( t.d, 4 )
t = mp.unpack(mp.pack(t))
is( t.b, 2 )
is( t.d, nil, "don't follow metatable" )
