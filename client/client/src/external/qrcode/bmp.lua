--[[  
Description:  
    FileName:bit.lua  
    This module provides a selection of bitwise operations.  
History:  
    Initial version created by  阵雨 2005-11-10.  
Notes:  
  ....  
]]
--[[{2147483648,1073741824,536870912,268435456,134217728,67108864,33554432,16777216,  
        8388608,4194304,2097152,1048576,524288,262144,131072,65536,  
        32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1}  
        ]]
bit = {data32 = {}}
for i = 1, 32 do
	bit.data32[i] = 2 ^(32 - i)
end

function bit:d2b(arg)
	local tr = {}
	for i = 1, 32 do
		if arg >= self.data32[i] then
			tr[i] = 1
			arg = arg - self.data32[i]
		else
			tr[i] = 0
		end
	end
	return tr
end   --bit:d2b  

function	bit:b2d(arg)
	local nr = 0
	for i = 1, 32 do
		if arg[i] == 1 then
			nr = nr + 2 ^(32 - i)
		end
	end
	return nr
end   --bit:b2d  

function	bit:_xor(a, b)
	local op1 = self:d2b(a)
	local op2 = self:d2b(b)
	local r = {}
	
	for i = 1, 32 do
		if op1[i] == op2[i] then
			r[i] = 0
		else
			r[i] = 1
		end
	end
	return self:b2d(r)
end --bit:xor  

function	bit:_and(a, b)
	local op1 = self:d2b(a)
	local op2 = self:d2b(b)
	local r = {}
	
	for i = 1, 32 do
		if op1[i] == 1 and op2[i] == 1 then
			r[i] = 1
		else
			r[i] = 0
		end
	end
	return self:b2d(r)
	
end --bit:_and  

function	bit:_or(a, b)
	local op1 = self:d2b(a)
	local op2 = self:d2b(b)
	local r = {}
	
	for i = 1, 32 do
		if op1[i] == 1 or op2[i] == 1 then
			r[i] = 1
		else
			r[i] = 0
		end
	end
	return self:b2d(r)
end --bit:_or  

function	bit:_not(a)
	local op1 = self:d2b(a)
	local r = {}
	
	for i = 1, 32 do
		if op1[i] == 1 then
			r[i] = 0
		else
			r[i] = 1
		end
	end
	return self:b2d(r)
end --bit:_not  

function	bit:_rshift(a, n)
	local op1 = self:d2b(a)
	local r = self:d2b(0)
	
	if n < 32 and n > 0 then
		for i = 1, n do
			for i = 31, 1, - 1 do
				op1[i + 1] = op1[i]
			end
			op1[1] = 0
		end
		r = op1
	end
	return self:b2d(r)
end --bit:_rshift  

function	bit:_lshift(a, n)
	local op1 = self:d2b(a)
	local r = self:d2b(0)
	
	if n < 32 and n > 0 then
		for i = 1, n do
			for i = 1, 31 do
				op1[i] = op1[i + 1]
			end
			op1[32] = 0
		end
		r = op1
	end
	return self:b2d(r)
end --bit:_lshift  


function	bit:print(ta)
	local sr = ""
	for i = 1, 32 do
		sr = sr .. ta[i]
	end
	print(sr)
end


-----------------------------------------------------------------------------
local function format_data(array, width)
	local left_and_top_spacing = 0
	local right_bottom_spacing = 0
	
	--local quotient = width // #array
	local quotient = math.modf(width / #array)
	local remainder = width % #array
	left_and_top_spacing = math.ceil(remainder / 2 - 0.5)
	right_bottom_spacing = remainder - left_and_top_spacing
	local result = {}
	for row = 1, width, 1
	do
		local row_data = {}
		if(row <= left_and_top_spacing) or(row > width - right_bottom_spacing) then
			for col = 1, width, 1
			do
				table.insert(row_data, 0)
			end
		else
			for col = 1, width, 1
			do
				if(col <= left_and_top_spacing) or(col > width - right_bottom_spacing) then
					table.insert(row_data, 0)
				else
					--table.insert(row_data, array[(row - left_and_top_spacing - 1) // quotient + 1][(col - left_and_top_spacing - 1) // quotient + 1])
					local t1, _ = math.modf((row - left_and_top_spacing - 1) / quotient)
					local t2, _ = math.modf((col - left_and_top_spacing - 1) / quotient)
					table.insert(row_data, array[t1 + 1] [t2 + 1])
				end
			end
			
		end
		table.insert(result, row_data)
	end
	return result
	
end


local function header(array)
	--local file_size = 62 + ((#array + 31) // 32) * 4 * #array
	local t1, _ = math.modf((#array + 31) / 32)
	local file_size = 62 +(t1) * 4 * #array
	--local result = "BM" .. string.pack("i4i2i2i4", file_size, 0, 0, 54 + 8)
	local result = "BM" .. string.pack("ihhi", file_size, 0, 0, 54 + 8) --pack
	
	return result
end

local function dib(array)
	--local data_size = ((#array + 31) // 32) * 4 * #array
	local t1, _ = math.modf((#array + 31) / 32)
	local data_size =(t1) * 4 * #array
	--local result = string.pack("i4i4i4i2i2i4i4i4i4i4i4", 40, #array, #array, 1, 1, 0, data_size, 0, 0, 2, 0)
	local result = string.pack("iiihhiiiiii", 40, #array, #array, 1, 1, 0, data_size, 0, 0, 2, 0)
	return result
end

local function color_map()
	return "\xff\xff\xff\xff\x00\x00\x00\x00"
end

local function data(array)
	local result = ""
	for col = #array, 1, - 1
	do
		local row_data = ""
		local index = 0
		local current_data = 0
		for row = 1, #array, 1
		do
			if array[row] [col] > 0 then
                --current_data = current_data | 1 <<(31 - index)
                local t1,_ = math.modf( bit:_lshift(1,(31 - index)) )
                local t2,_ = math.modf( bit:_xor(current_data,t1) )
                current_data = t2
			end
			index = index + 1
			
			if index == 32 then
				--row_data = row_data .. string.pack(">I4", current_data)
				row_data = row_data .. string.pack(">I", current_data)
				
				current_data = 0
				index = 0
			end
			
		end
		if index > 0 then
			--row_data = row_data .. string.pack(">I4", current_data)
			row_data = row_data .. string.pack(">I", current_data)
		end
		
		result = result .. row_data
	end
	return result
end

local function bmp(array, width)
	if not width then
		width = #array * 10
	end
	array = format_data(array, width)
	return header(array) .. dib(array) .. color_map() .. data(array)
end

return bmp 