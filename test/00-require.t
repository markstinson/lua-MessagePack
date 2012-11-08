#! /usr/bin/lua

require 'Test.More'

plan(10)

if not require_ok 'MessagePack' then
    BAIL_OUT "no lib"
end

local m = require 'MessagePack'
type_ok( m, 'table' )
like( m._COPYRIGHT, 'Perrad', "_COPYRIGHT" )
like( m._DESCRIPTION, 'MessagePack', "_DESCRIPTION" )
like( m._VERSION, '^%d%.%d%.%d$', "_VERSION" )

type_ok( m.pack, 'function', "function pack" )
type_ok( m.unpack, 'function', "function unpack")
type_ok( m.unpacker, 'function', "function unpacker")
type_ok( m.set_integer, 'function', "function set_integer")
type_ok( m.set_number, 'function', "function set_number")

