#! /usr/bin/lua

require 'Test.More'

plan(3)

local mp = require 'MessagePack'

is( mp.unpack(mp.pack("text")), "text" )

error_like(function ()
               mp.unpack(mp.pack("text"):sub(1, -2))
           end,
           "missing bytes")

error_like(function ()
               mp.unpack(mp.pack("text") .. "more")
           end,
           "extra bytes")


