#! /usr/bin/lua

require 'Test.More'

plan(12)

local mp = require 'MessagePack'

is( mp.unpack(mp.pack("text")), "text" )

error_like( function ()
                mp.unpack(mp.pack("text"):sub(1, -2))
            end,
            "missing bytes" )

error_like( function ()
                mp.unpack(mp.pack("text") .. "more")
            end,
            "extra bytes" )

error_like( function ()
                mp.unpack( {} )
            end,
            "bad argument #1 to unpack %(string expected, got table%)" )

error_like( function ()
                mp.unpacker( false )
            end,
            "bad argument #1 to unpacker %(no method 'read'%)" )

error_like( function ()
                mp.unpacker( {} )
            end,
            "bad argument #1 to unpacker %(no method 'read'%)" )

for _, val in mp.unpacker(string.rep(mp.pack("text"), 2)) do
    is( val, "text" )
end

error_like( function ()
                for _, val in mp.unpacker(string.rep(mp.pack("text"), 2):sub(1, -2)) do
                    is( val, "text" )
                end
            end,
            "missing bytes" )

error_like( function ()
                mp.set_number'bad'
            end,
            "bad argument #1 to set_number %(invalid option 'bad'%)" )

error_like( function ()
                mp.set_integer'bad'
            end,
            "bad argument #1 to set_integer %(invalid option 'bad'%)" )
