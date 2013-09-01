#! /usr/bin/lua

require 'Test.More'

if not pcall(require, 'ffi') then
    skip_all 'no ffi'
end

plan(20)

local mp = require 'MessagePack'
local ffi = require 'ffi'
local EXT_UINT = 0x40

local uint8_t   = ffi.typeof'uint8_t'
local uint16_t  = ffi.typeof'uint16_t'
local uint32_t  = ffi.typeof'uint32_t'
local uint64_t  = ffi.typeof'uint64_t'
local uint8_a1  = ffi.typeof'uint8_t[1]'
local uint16_a1 = ffi.typeof'uint16_t[1]'
local uint32_a1 = ffi.typeof'uint32_t[1]'
local uint64_a1 = ffi.typeof'uint64_t[1]'
local uint8_p   = ffi.typeof'uint8_t *'
local uint16_p  = ffi.typeof'uint16_t *'
local uint32_p  = ffi.typeof'uint32_t *'
local uint64_p  = ffi.typeof'uint64_t *'

mp.packers['cdata'] = function (buffer, cdata)
    if     ffi.istype(uint8_t, cdata) then
        mp.packers['fixext1'](buffer, EXT_UINT, ffi.string(uint8_a1(cdata), 1))
    elseif ffi.istype(uint16_t, cdata) then
        mp.packers['fixext2'](buffer, EXT_UINT+1, ffi.string(uint16_a1(cdata), 2))
    elseif ffi.istype(uint32_t, cdata) then
        mp.packers['fixext4'](buffer, EXT_UINT+2, ffi.string(uint32_a1(cdata), 4))
    elseif ffi.istype(uint64_t, cdata) then
        mp.packers['fixext8'](buffer, EXT_UINT+3, ffi.string(uint64_a1(cdata), 8))
    else
        error("pack 'cdata' is unimplemented")
    end
end

mp.build_ext = function (tag, data)
    if     tag == EXT_UINT then
        return uint8_t(ffi.cast(uint8_p, data)[0])
    elseif tag == EXT_UINT+1 then
        return uint16_t(ffi.cast(uint16_p, data)[0])
    elseif tag == EXT_UINT+2 then
        return uint32_t(ffi.cast(uint32_p, data)[0])
    elseif tag == EXT_UINT+3 then
        return uint64_t(ffi.cast(uint64_p, data)[0])
    end
end


local a = ffi.new('uint8_t', 100)
ok( ffi.istype(uint8_t, a) )
-- diag(mp.hexadump(mp.pack(a)))
local b = mp.unpack(mp.pack(a))
type_ok( b, 'cdata' )
is( tonumber(b), 100 )
nok( rawequal(a, b) )
ok( ffi.istype(uint8_t, b) )

local a = ffi.new('uint16_t', 10000)
ok( ffi.istype(uint16_t, a) )
-- diag(mp.hexadump(mp.pack(a)))
local b = mp.unpack(mp.pack(a))
type_ok( b, 'cdata' )
is( tonumber(b), 10000 )
nok( rawequal(a, b) )
ok( ffi.istype(uint16_t, b) )

local a = ffi.new('uint32_t', 100000000)
ok( ffi.istype(uint32_t, a) )
-- diag(mp.hexadump(mp.pack(a)))
local b = mp.unpack(mp.pack(a))
type_ok( b, 'cdata' )
is( tonumber(b), 100000000 )
nok( rawequal(a, b) )
ok( ffi.istype(uint32_t, b) )

local a = ffi.new('uint64_t', 1000000000000)
ok( ffi.istype(uint64_t, a) )
-- diag(mp.hexadump(mp.pack(a)))
local b = mp.unpack(mp.pack(a))
type_ok( b, 'cdata' )
is( tonumber(b), 1000000000000 )
nok( rawequal(a, b) )
ok( ffi.istype(uint64_t, b) )

