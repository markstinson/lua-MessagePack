#! /usr/bin/lua

local unpack = table.unpack or unpack

require 'Test.More'

local mp = require 'MessagePack'

local data = {
    false,              "false",
    true,               "true",
    nil,                "nil",
    0,                  "0 Positive FixNum",
    0,                  "0 uint8",
    0,                  "0 uint16",
    0,                  "0 uint32",
    0,                  "0 uint64",
    0,                  "0 int8",
    0,                  "0 int16",
    0,                  "0 int32",
    0,                  "0 int64",
    -1,                 "-1 Negative FixNum",
    -1,                 "-1 int8",
    -1,                 "-1 int16",
    -1,                 "-1 int32",
    -1,                 "-1 int64",
    127,                "127 Positive FixNum",
    127,                "127 uint8",
    255,                "255 uint16",
    65535,              "65535 uint32",
    4294967295,         "4294967295 uint64",
    -32,                "-32 Negative FixNum",
    -32,                "-32 int8",
    -128,               "-128 int16",
    -32768,             "-32768 int32",
    -2147483648,        "-2147483648 int64",
    0.0,                "0.0 float",
    0.0,                "0.0 double",
    -0.0,               "-0.0 float",
    -0.0,               "-0.0 double",
    1.0,                "1.0 double",
    -1.0,               "-1.0 double",
    "a",                "\"a\" FixRaw",
    "a",                "\"a\" raw 16",
    "a",                "\"a\" raw 32",
    "",                 "\"\" FixRaw",
    "",                 "\"\" raw 16",
    "",                 "\"\" raw 32",
    { 0 },              "[0] FixArray",
    { 0 },              "[0] array 16",
    { 0 },              "[0] array 32",
    {},                 "[] FixArray",
    {},                 "[] array 16",
    {},                 "[] array 32",
    {},                 "{} FixMap",
    {},                 "{} map 16",
    {},                 "{} map 32",
    { a=97 },           "{\"a\"=>97} FixMap",
    { a=97},            "{\"a\"=>97} map 16",
    { a=97 },           "{\"a\"=>97} map 32",
    { {} },             "[[]]",
    { {"a"} },          "[[\"a\"]]",
}

plan(3 * #data)

-- see http://github.com/msgpack/msgpack/blob/master/test/cases_gen.rb
local source = [===[
c2                              # false
c3                              # true
c0                              # nil
00                              # 0 Positive FixNum
cc 00                           # 0 uint8
cd 00 00                        # 0 uint16
ce 00 00 00 00                  # 0 uint32
cf 00 00 00 00 00 00 00 00      # 0 uint64
d0 00                           # 0 int8
d1 00 00                        # 0 int16
d2 00 00 00 00                  # 0 int32
d3 00 00 00 00 00 00 00 00      # 0 int64
ff                              # -1 Negative FixNum
d0 ff                           # -1 int8
d1 ff ff                        # -1 int16
d2 ff ff ff ff                  # -1 int32
d3 ff ff ff ff ff ff ff ff      # -1 int64
7f                              # 127 Positive FixNum
cc 7f                           # 127 uint8
cd 00 ff                        # 255 uint16
ce 00 00 ff ff                  # 65535 uint32
cf 00 00 00 00 ff ff ff ff      # 4294967295 uint64
e0                              # -32 Negative FixNum
d0 e0                           # -32 int8
d1 ff 80                        # -128 int16
d2 ff ff 80 00                  # -32768 int32
d3 ff ff ff ff 80 00 00 00      # -2147483648 int64
ca 00 00 00 00                  # 0.0 float
cb 00 00 00 00 00 00 00 00      # 0.0 double
ca 80 00 00 00                  # -0.0 float
cb 80 00 00 00 00 00 00 00      # -0.0 double
cb 3f f0 00 00 00 00 00 00      # 1.0 double
cb bf f0 00 00 00 00 00 00      # -1.0 double
a1 61                           # "a" FixRaw
da 00 01 61                     # "a" raw 16
db 00 00 00 01 61               # "a" raw 32
a0                              # "" FixRaw
da 00 00                        # "" raw 16
db 00 00 00 00                  # "" raw 32
91 00                           # [0] FixArray
dc 00 01 00                     # [0] array 16
dd 00 00 00 01 00               # [0] array 32
90                              # [] FixArray
dc 00 00                        # [] array 16
dd 00 00 00 00                  # [] array 32
80                              # {} FixMap
de 00 00                        # {} map 16
df 00 00 00 00                  # {} map 32
81 a1 61 61                     # {"a"=>97} FixMap
de 00 01 a1 61 61               # {"a"=>97} map 16
df 00 00 00 01 a1 61 61         # {"a"=>97} map 32
91 90                           # [[]]
91 91 a1 61                     # [["a"]]
]===]

source = source:gsub('#[^\n]+', '')
local t = {}
for v in source:gmatch'%x%x' do
    t[#t+1] = tonumber(v, 16)
end
local mpac = string.char(unpack(t))


local i = 1
for _, val in mp.unpacker(mpac) do
    if type(val) == 'table' then
        is_deeply(val, data[i], "reference   " .. data[i+1])
        is_deeply(mp.unpack(mp.pack(data[i])), data[i], "unpack/pack " .. data[i+1])
    else
        is(val, data[i], "reference   " .. data[i+1])
        is(mp.unpack(mp.pack(data[i])), data[i], "unpack/pack " .. data[i+1])
    end
    i = i + 2
end

local f = io.open('cases.mpac', 'w')
f:write(mpac)
f:close()
local r, ltn12 = pcall(require, 'ltn12')        -- from LuaSocket
if not r then
    diag "ltn12.source.file emulated"
    ltn12 = { source = {} }

    function ltn12.source.file (handle)
        if handle then
            return function ()
                local chunk = handle:read(1)
                if not chunk then
                    handle:close()
                end
                return chunk
            end
        else return function ()
                return nil, "unable to open file"
            end
        end
    end
end
local i = 1
local f = io.open('cases.mpac', 'r')
local s = ltn12.source.file(f)
for _, val in mp.unpacker(s) do
    if type(val) == 'table' then
        is_deeply(val, data[i], "reference   " .. data[i+1])
    else
        is(val, data[i], "reference   " .. data[i+1])
    end
    i = i + 2
end
os.remove 'cases.mpac'  -- clean up

mp.set_integer'unsigned'
local i = 1
for _, val in mp.unpacker(mpac) do
    if type(val) == 'table' then
        is_deeply(mp.unpack(mp.pack(data[i])), data[i], "unpack/pack " .. data[i+1])
    else
        is(mp.unpack(mp.pack(data[i])), data[i], "unpack/pack " .. data[i+1])
    end
    i = i + 2
end

mp.set_number'float'
local i = 1
for _, val in mp.unpacker(mpac) do
    if type(val) == 'table' then
        is_deeply(mp.unpack(mp.pack(data[i])), data[i], "unpack/pack " .. data[i+1])
    else
        is(mp.unpack(mp.pack(data[i])), data[i], "unpack/pack " .. data[i+1])
    end
    i = i + 2
end

mp.set_number'integer'
local i = 1
for _, val in mp.unpacker(mpac) do
    if type(val) == 'table' then
        is_deeply(mp.unpack(mp.pack(data[i])), data[i], "unpack/pack " .. data[i+1])
    else
        is(mp.unpack(mp.pack(data[i])), data[i], "unpack/pack " .. data[i+1])
    end
    i = i + 2
end
