#! /usr/bin/lua

require 'Test.More'

plan(5)

if not require_ok 'MessagePack' then
    BAIL_OUT "no lib"
end

local m = require 'MessagePack'
type_ok( m, 'table' )
like( m._COPYRIGHT, 'Perrad', "_COPYRIGHT" )
like( m._DESCRIPTION, 'MessagePack', "_DESCRIPTION" )
like( m._VERSION, '^%d%.%d%.%d$', "_VERSION" )

