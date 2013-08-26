#! /usr/bin/lua

require 'Test.More'

plan(32)

local mp = require 'MessagePack'

mp.set_number'float'
is( mp.unpack(mp.pack(3.140625)), 3.140625, "3.140625" )
mp.set_number'double'
is( mp.unpack(mp.pack(math.pi)), math.pi, "pi" )

mp.set_integer'signed'
is( mp.unpack(mp.pack(2^5)), 2^5, "2^5" )
is( mp.unpack(mp.pack(-2^5)), -2^5, "-2^5" )
is( mp.unpack(mp.pack(2^11)), 2^11, "2^11" )
is( mp.unpack(mp.pack(-2^11)), -2^11, "-2^11" )
is( mp.unpack(mp.pack(2^21)), 2^21, "2^21" )
is( mp.unpack(mp.pack(-2^21)), -2^21, "-2^21" )
is( mp.unpack(mp.pack(2^51)), 2^51, "2^51" )
is( mp.unpack(mp.pack(-2^51)), -2^51, "-2^51" )

mp.set_integer'unsigned'
is( mp.unpack(mp.pack(2^5)), 2^5, "2^5" )
is( mp.unpack(mp.pack(-2^5)), -2^5, "-2^5" )
is( mp.unpack(mp.pack(2^11)), 2^11, "2^11" )
is( mp.unpack(mp.pack(-2^11)), -2^11, "-2^11" )
is( mp.unpack(mp.pack(2^21)), 2^21, "2^21" )
is( mp.unpack(mp.pack(-2^21)), -2^21, "-2^21" )
is( mp.unpack(mp.pack(2^51)), 2^51, "2^51" )
is( mp.unpack(mp.pack(-2^51)), -2^51, "-2^51" )

mp.set_string'string'
s = string.rep('x', 2^3)
is( mp.unpack(mp.pack(s)), s, "#s 2^3" )        -- fixstr
s = string.rep('x', 2^7)
is( mp.unpack(mp.pack(s)), s, "#s 2^7" )        -- str 8
s = string.rep('x', 2^11)
is( mp.unpack(mp.pack(s)), s, "#s 2^11" )       -- str 16
s = string.rep('x', 2^19)
is( mp.unpack(mp.pack(s)), s, "#s 2^19" )       -- str 32

mp.set_string'string_compat'
s = string.rep('x', 2^3)
is( mp.unpack(mp.pack(s)), s, "#s 2^3" )        -- fixstr
s = string.rep('x', 2^11)
is( mp.unpack(mp.pack(s)), s, "#s 2^11" )       -- str 16
s = string.rep('x', 2^19)
is( mp.unpack(mp.pack(s)), s, "#s 2^19" )       -- str 32

mp.set_string'binary'
s = string.rep('x', 2^5)
is( mp.unpack(mp.pack(s)), s, "#s 2^5" )        -- bin 8
s = string.rep('x', 2^11)
is( mp.unpack(mp.pack(s)), s, "#s 2^11" )       -- bin 16
s = string.rep('x', 2^19)
is( mp.unpack(mp.pack(s)), s, "#s 2^19" )       -- bin 32

t = { string.rep('x', 2^3):byte(1, -1) }
is_deeply( mp.unpack(mp.pack(t)), t, "#t 2^3" )
t = { string.rep('x', 2^9):byte(1, -1) }
is_deeply( mp.unpack(mp.pack(t)), t, "#t 2^9" )

h = {}
for i = 1, 2^3 do h[10*i] = i end
is_deeply( mp.unpack(mp.pack(h)), h, "#h 2^3" )
h = {}
for i = 1, 2^9 do h[10*i] = i end
is_deeply( mp.unpack(mp.pack(h)), h, "#h 2^9" )

