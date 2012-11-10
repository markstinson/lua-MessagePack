#! /usr/bin/lua

require 'Test.More'

plan(8)

if not require_ok 'MessagePack' then
    BAIL_OUT "no lib"
end

local m = require 'MessagePack'
type_ok( m, 'table' )
like( m._COPYRIGHT, 'Perrad', "_COPYRIGHT" )
like( m._DESCRIPTION, 'MessagePack', "_DESCRIPTION" )
like( m._VERSION, '^%d%.%d%.%d$', "_VERSION" )

type_ok( m.packers, 'table', "table packers" )
type_ok( m.unpackers, 'table', "table unpackers" )
type_ok( m.types_map, 'table', "table types_map" )

