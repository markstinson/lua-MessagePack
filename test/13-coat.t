#! /usr/bin/lua

require 'Test.More'

if not pcall(require, 'Coat') then
    skip_all 'no Coat'
end

plan(4)

local Meta = require 'Coat.Meta.Class'
local mp = require 'MessagePack'
local EXT_COAT = 4

mp.packers['table'] = function (buffer, obj)
    local classname = obj._CLASS
    if classname then
        local buf = {}
        mp.packers['string'](buf, classname)
        mp.packers['table'](buf, obj._VALUES)
        mp.packers['ext'](buffer, EXT_COAT, table.concat(buf))
    else
        mp.packers['_table'](buffer, obj)
    end
end

mp.build_ext = function (tag, data)
    if tag == EXT_COAT then
        local f = mp.unpacker(data)
        local _, classname = f()
        local _, values = f()
        local class = assert(Meta.class(classname))
        return class.new(values)
    end
end

class 'Point'

has.x = { is = 'rw', isa = 'number', default = 0 }
has.y = { is = 'rw', isa = 'number', default = 0 }

function overload:__tostring ()
    return '(' .. self.x .. ', ' .. self.y .. ')'
end

function method:draw ()
    return "drawing " .. self._CLASS .. tostring(self)
end

a = Point{x = 1, y = 2}
ok( a:isa 'Point' )
is( tostring(a), "(1, 2)" )

b =  mp.unpack(mp.pack(a))
ok( b:isa 'Point' )
is( tostring(b), "(1, 2)" )

