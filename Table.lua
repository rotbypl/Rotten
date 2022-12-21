Math = require(script.Parent.Math)

Table = {}

-- Functions
function Table.copy (table: table)
	local copy = {}

	for key, value in table do
		copy[key] = value
	end

	return copy
end

function Table.merge (table: table, ...)
	for index = 1, select("#", ...) do
		local table = select(index, ...)

		for key, value in table do
			table[key] = value
		end
	end

	return table
end

function Table._merge (table: table, ...)
	return Table.merge(Table.copy(table), ...)
end

function Table.equals (table: table, other: table)
	for key, value in table do
		if other[key] ~= value then
			return false
		end
	end

	for key, value in other do
		if table[key] ~= value then
			return false
		end
	end

	return true
end

function Table.keys (table: table)
	local keys = {}

	for key, value in table do
		keys[#keys + 1] = key
	end

	return keys
end

function Table.values (table: table)
	local values = {}

	for key, value in table do
		values[#values + 1] = value
	end

	return values
end

function Table.entries (table: table)
	local entries = {}

	for key, value in table do
		entries[#entries + 1] = { key, value }
	end

	return entries
end

function Table.has (table: table, key: any)
	return table[key] ~= nil
end

function Table.get (table: table, keyOrKeys: any)
	if typeof(keyOrKeys) == 'table' then
		local piece = {}
		
		for key, value in keyOrKeys do
			piece[value] = table[value]
		end
		
		return piece
	end
	
	return table[keyOrKeys]
end

function Table.set (table: table, key: any, value: any)
	table[key] = value
	
	return table
end

function Table._set (table: table, key: any, value: any)
	return Table.set(Table.copy(table), key, value)
end

function Table.length (table: table)
	local length = 0

	for key, value in table do
		length += 1
	end

	return length
end

function Table.drop (table: table, key: any)
	table[key] = nil
	
	return table
end

function Table._drop (table: table, key: any)
	return Table.drop(Table.copy(table), key)
end

function Table.sort (table: table, callback: (first: any, second: any) -> boolean)
	for index = 1, #table - 1 do
		for index = 1, #table - 1 do
			if callback(table[index], table[index + 1]) then
				table[index], table[index + 1] = table[index + 1], table[index]
			end
		end
	end

	return table
end

function Table._sort (table: table, callback: (first: any, second: any) -> boolean)
	return Table.sort(Table.copy(table), callback)
end

function Table.map (table: table, callback: (any, any) -> any)
	for key, value in table do
		table[key] = callback(key, value)
	end
	
	return table
end

function Table._map (table: table, callback: (any, any) -> any)
	return Table.map(Table.copy(table), callback)
end

function Table.filter (table: table, callback: (any, any) -> boolean)
	for key, value in table do
		if not callback(key, value) then
			table[key] = nil
		end
	end
	
	return table
end

function Table._filter (table: table, callback: (any, any) -> boolean)
	return Table.filter(Table.copy(table), callback)
end

function Table.find (table: table, callback: (any, any) -> boolean)
	for key, value in table do
		if callback(key, value) then
			return {
				key = key,
				value = value
			}
		end
	end
end

function Table.schematic (table: table)
	local schematic = {}

	for key, value in table do
		if typeof(value) == "table" then
			schematic[key] = Table.schematic(value)
		else
			schematic[key] = typeof(value)
		end
	end

	return schematic
end

function Table.matches (table: table, schematic: table)
	local tableSchematic = Table.schematic(table)

	for key, value in schematic do
		if typeof(value) == "table" then
			if not Table.matches(table[key], value) then
				return false
			end
		else
			if tableSchematic[key] ~= value then
				return false
			end
		end
	end

	return true
end

function Table.form (table: table, blueprint: table, scheme: boolean)
	for key, value in table do
		if not blueprint[key] then
			table[key] = nil
		end
	end

	for key, value in blueprint do
		if typeof(value) == "table" then
			if not table[key] then
				table[key] = {}
			end

			Table.form(table[key], value, scheme)
		else
			if table[key] then
				if scheme and typeof(table[key]) ~= typeof(value) then
					table[key] = value
				end
			else
				table[key] = value
			end
		end
	end
	
	return table
end

function Table._form (table: table, blueprint: table, scheme: boolean)
	return Table.form(Table.copy(table), blueprint, scheme)
end

function Table.random (table: table, amount: number?)
	if amount ~= nil then
		local piece = {}
		
		for index = 1, amount, 1 do
			Table.insert(piece, Table.random(table))
		end
		
		return piece
	end
	
	local values = Table.values(table)
	
	return values[Math.random(NumberRange.new(1, #values), true)]
end

function Table.chance (table: table, amount: number?)
	if amount ~= nil then
		local piece = {}
		
		for index = 1, amount, 1 do
			Table.insert(piece, Table.chance(table))
		end
		
		return piece
	end
	
	local whole = Table.sum(Table.keys(table))
	local random = Math.random(NumberRange.new(1, whole), true)
	local chance = 0
	
	for key, value in table do
		if random <= key + chance then
			return table[key]
		end
		
		chance += key
	end
end

function Table.insert(table: table, value: any)
	table[#table + 1] = value
	
	return table
end

function Table._insert(table: table, value: any)
	return Table.insert(Table.copy(table), value)
end

function Table.trend (table: table, value: any?)
	if value ~= nil then
		local trend = 0

		for key, _value in table do
			if type(value) == 'table' then
				if typeof(_value) == 'table' then
					if Table.equals(value, _value) then
						trend += 1
					end
				end
			else
				if _value == value then
					trend += 1
				end
			end
		end

		return trend
	end
	
	local trends = {}
	
	for key, value in table do
		if trends[value] == nil and typeof(value) ~= 'table' then
			trends[value] = Table.trend(table, value)
		end
	end
	
	return trends
end

function Table.sum (table: table)
	local sum = 0
	
	for key, value in table do
		if typeof(value) == 'number' then
			sum += value
		end
	end
	
	return sum
end

function Table.keep (table: table, datatype: string)
	for key, value in table do
		if typeof(value) ~= datatype then
			table[key] = nil
		end
	end
	
	return table
end

function Table._keep (table: table, datatype: string)
	return Table.keep(Table.copy(table), datatype)
end

function Table.stringify (table: table)
	local stringified = '{'

	for key, value in table do
		stringified ..= if typeof(key) == 'string' then '[\"' .. tostring(key) .. '\"]=' else '[' .. tostring(key) .. ']='

		if typeof(value) == 'table' then
			stringified ..= Table.stringify(value)
		elseif typeof(value) == 'string' then
			stringified ..= '\"' .. value .. '\"'
		else
			stringified ..= tostring(value)
		end

		stringified ..= ','
	end

	stringified = string.sub(stringified, 1, #stringified - 1)
	stringified ..= '}'

	return stringified
end

function Table.parse (string: string)
	return loadstring("return " .. string)()
end

-- Shorthands
Table.vals = Table.values
Table.ents = Table.entries
Table.len = Table.length
Table.schema = Table.schematic
Table.rand = Table.random
Table.str = Table.stringify
Table.ins = Table.insert
Table._ins = Table._insert

function Table.asc (table: table)
	Table.sort(table, function (first, second)
		return first < second
	end)
end

function Table._asc (table: table)
	return Table._sort(table, function (first, second)
		return first < second
	end)
end

function Table.desc (table: table)
	Table.sort(table, function (first, second)
		return first > second
	end)
end

function Table._desc (table: table)
	return Table._sort(table, function (first, second)
		return first > second
	end)
end

return Table
