--!nocheck


--[[ Lots of problems with typechecking here.
	Disabled until further notice. ]]


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions
local function getlength(t: {[string | number]: any}): number
	local i = 0

	for _, _ in t do
		i += 1
	end

	return i
end

local function split(t: {[number | string]: any}, x: number): ({[number | string]: any}, {[number | string]: any})
	local low, high = {}, {}
	local i = 0

	for key, value in t do
		i += 1

		if i <= x then
			low[key] = value
		else
			high[key] = value
		end
	end

	return low, high
end


-- Module
local tablev = {}


--[[ Functions: 

	tablev.len(t)
	tablev.tabletype(t)
	tablev.shuffle(t)
	tablev.swap(t, a, b)
	tablev.fill(t, val)
	tablev.insert(t, val, p)
	tablev.remove(t, predicate)
	tablev.removeall(t, predicate)
	tablev.first(t, predicate)
	tablev.firstindex(t, predicate)
	tablev.last(t, predicate)
	tablev.lastindex(t, predicate)
	tablev.reorganize(t)
	tablev.deepcopy(t)
	tablev.deepfreeze(t)
	tablev.safefreeze(t)
	tablev.reverse(t)
	tablev.split(t, x)
	tablev.binsearch(t, v)
	tablev.closestbinsearch(t, v)
	tablev.same(a, b)

]]


--[[ tablev.len(t)
	PARAMETERS: 
	- <table> t: The table to get the length of.

	RETURNS:
	- <number> i: The table length.

	Returns the length of a given table, regardless of table type. ]] 
function tablev.len(t: {[string | number]: any}): number
	return getlength(t)
end


--[[ tablev.tabletype(t: {[number | string]: any})
	PARAMETERS: 
	- <table> t: The table to get the type of.

	RETURNS:
	- <string> tableType: The type of the dictionary. Can return "Empty", "Mixed", "Array", and "Dictionary".

	Returns the exact type of a given table. ]] 
function tablev.tabletype(t: {[number | string]: any}): string
	local stringCount, length = 0, tablev.len(t)

	if length == 0 then return "Empty" end

	for i, _ in t do
		if typeof(i) == "string" then 
			stringCount += 1
		end
	end
	
	if stringCount == 0 then
		return "Array"
	elseif stringCount == length then
		return "Dictionary"
	else
		return "Mixed"
	end
end


--[[ tablev.shuffle(t)
	PARAMETERS: 
	- <table> t: The array to shuffle.

	RETURNS:
	- <table> result: The shuffled array.

	Returns the given array in its shuffled form. ]] 
function tablev.shuffle(t: {[number]: any}): {[number]: any}
	local result = t
	for i = #result, 2, -1 do
		local j = Random.new(tick()):NextInteger(1, i)
		result[i], result[j] = result[j], result[i]
	end
	return result
end


--[[ tablev.swap(t, a, b)
	[ MUTATIVE ]

	PARAMETERS: 
	- <table> t: The array to shuffle.
	- <number> a: The first index to swap with the second.
	- <number> b: The second index to swap with the first.

	RETURNS:
	- nil.

	Mutates the given array such that 2 given indices are swapped with one another. Does NOT return a table. ]] 
function tablev.swap(t: {[number]: any}, a: number, b: number)
	t[a], t[b] = t[b], t[a]
end


--[[ tablev.fill(t, val)
	[ MUTATIVE ]

	PARAMETERS: 
	- <table> t: The array to insert into.
	- <any> val: The value to insert.

	RETURNS:
	- nil.

	Inserts a given value into the first empty position of the array if any, otherwise appends it to the array. ]] 
function tablev.fill(t: {[number]: any}, val: any)
	local index = 0
	for i, v in t do
		if i == index + 1 then 
			index = i
		else
			t[index + 1] = val
			break
		end
	end
	
	t[index + 1] = val
end


--[[ tablev.insert(t, val, p)
	[ MUTATIVE ]

	PARAMETERS: 
	- <table> t: The array to insert into.
	- <any> val: The value to insert.
	- <number> p: The position to insert the value into. Defaults to the length of the array, meaning it is inserted to the end of the array.

	RETURNS:
	- nil.

	Inserts a given value into the given position of the array and shifts subsequent indices up, otherwise appends it to the array. ]] 
function tablev.insert(t: {[number]: any}, val: any, p: number?)
	-- Insert to end of array if 'p' is nil.
	if p == nil then
		table.insert(t, val)
		return
	end
	
	-- Insert to 'array[p]' if it is nil (empty index).
	if t[p] == nil then 
		t[p] = val
		return
	end
	
	-- Insert to 'array[p]' if it is not nil (bumps all subsequent indices upwards).
	for i = #t, p, -1 do
		t[i + 1] = t[i]
	end
	
	t[p] = val
end


--[[ tablev.remove(t, predicate)
	[ MUTATIVE ]

	PARAMETERS: 
	- <table> t: The array to remove from.
	- <function> predicate: A callback function that matches the values to a provided condition. Condition must always return true or false.

	RETURNS:
	- nil.

	Removes the first value that match a given condition within the callback function from a given array. ]] 
function tablev.remove(t: {[number]: any}, predicate: (a: any) -> boolean)
	for i, v in t do
		if predicate(v) == true then 
			t[i] = nil 
			break 
		end
	end
end


--[[ tablev.removeall(t, predicate)
	[ MUTATIVE ]

	PARAMETERS: 
	- <table> t: The array to remove from.
	- <function> predicate: A callback function that matches the values to a provided condition. Condition must always return true or false.

	RETURNS:
	- nil.

	Removes all values that match a given condition within the callback function from a given array. ]] 
function tablev.removeall(t: {[number]: any}, predicate: (a: any) -> boolean)
	for i, v in t do
		if predicate(v) == true then table.remove(t, i) end
	end
end


--[[ tablev.first(t, predicate)
	PARAMETERS: 
	- <table> t: The array to find the values from.
	- <function> predicate: A callback function that matches the values to a provided condition. Condition must always return true or false.

	RETURNS:
	- <any> result: The first value within the array that matches the given conditions.

	Returns the first value that match a given condition within the callback function from a given array, or nil if no such matching value exists. ]] 
function tablev.first(t: {[number]: any}, predicate: (a: any) -> boolean): any
	local val = nil
	
	for i, v in t do
		if predicate(v) == true then 
			val = v

			break
		end
	end
	
	return val
end


--[[ tablev.firstindex(t, predicate)
	PARAMETERS: 
	- <table> t: The array to find the values from.
	- <function> predicate: A callback function that matches the values to a provided condition. Condition must always return true or false.

	RETURNS:
	- <any> result: The first index within the array that matches the given conditions.

	Returns the first index that match a given condition within the callback function from a given array, or nil if no such matching value exists. ]] 
function tablev.firstindex(t: {[number]: any}, predicate: (a: any) -> boolean): any
	local val = nil

	for i, v in t do
		if predicate(v) == true then 
			val = i

			break
		end
	end

	return val
end


--[[ tablev.last(t, predicate)
	PARAMETERS: 
	- <table> t: The array to find the values from.
	- <function> predicate: A callback function that matches the values to a provided condition. Condition must always return true or false.

	RETURNS:
	- <any> result: The last value within the array that matches the given conditions.

	Returns the last value that match a given condition within the callback function from a given array, or nil if no such matching value exists. ]] 
function tablev.last(t: {[number]: any}, predicate: (a: any) -> boolean): any
	local val = nil

	for i = #t, 1, -1 do
		if predicate(t[i]) == true then 
			val = t[i]

			break
		end
	end

	return val
end


--[[ tablev.last(t, predicate)
	PARAMETERS: 
	- <table> t: The array to find the values from.
	- <function> predicate: A callback function that matches the values to a provided condition. Condition must always return true or false.

	RETURNS:
	- <any> result: The last value within the array that matches the given conditions.

	Returns the last value that match a given condition within the callback function from a given array, or nil if no such matching value exists. ]] 
function tablev.lastindex(t: {[number]: any}, predicate: (a: any) -> boolean): any
	local val = nil

	for i = #t, 1, -1 do
		if predicate(t[i]) == true then 
			val = i

			break
		end
	end

	return val
end


--[[ tablev.reorganize(t)
	[ MUTATIVE ]

	PARAMETERS: 
	- <table> t: The array to reorganize.

	RETURNS:
	- nil.

	Reorganizes the array such that the numbers are in a continuous sequence (1, 2, 3, 4, ...). ]] 
function tablev.reorganize(t: {[number]: any})
	local index = 0
	
	for i, v in t do
		index += 1
		
		if t[index] == nil then
			t[index] = v
			t[i] = nil
		end
	end
end


--[[ tablev.deepcopy(t)
	PARAMETERS: 
	- <table> t: The table to copy.

	RETURNS:
	- nil.

	Returns a copy of the table, including any nested tables. ]] 
function tablev.deepcopy(t: {[number | string]: any})
	local copy = {}
	
	for k, v in t do
		if type(v) == "table" then v = tablev.deepcopy(v) end
		
		copy[k] = v
	end
	
	return copy
end


--[[ tablev.deepfreeze(t)
	[ MUTATIVE ]

	PARAMETERS: 
	- <table> t: The table to freeze.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- This function safely freezes the tables, meaning it will not error if the tables and nested tables are already frozen.

	Freezes the table, including any nested tables. ]] 
function tablev.deepfreeze(t: {[number | string]: any})
	if table.isfrozen(t) == false then table.freeze(t) end

	for k, v in t do
		if typeof(v) == "table" and table.isfrozen(v) == false then
			table.freeze(v)
		end
	end
end


--[[ tablev.safefreeze(t)
	[ MUTATIVE ]

	PARAMETERS: 
	- <table> t: The table to freeze safely.

	RETURNS:
	- nil.

	Safely freezes the table, meaning this will not error if the table has already been frozen. ]] 
function tablev.safefreeze(t: {[number | string]: any})
	if table.isfrozen(t) == false then table.freeze(t) end
end


--[[ tablev.reverse(t)
	PARAMETERS: 
	- <table> t: The table to reverse.

	RETURNS:
	- <table> result: The reversed array.

	Returns a reversed version of the array. ]] 
function tablev.reverse(t: {[number]: any})
	local result = {}
	
	for i = #t, 1, -1 do
		table.insert(result, t[i])
	end
	
	return result
end


--[[ tablev.split(t, x)
	PARAMETERS: 
	- <table> t: The table to split.
	- <number> x: The index to split at.

	RETURNS:
	- <table> a: The left part of the split array.
	- <table> b: The right part of the split array.
	
	FOOTNOTES:
	- Dictionaries are unordered by nature, so splitting them may yield unintended results.

	Returns a version of the given table that is split down the index of x into two. ]] 
function tablev.split(t: {[number | string]: any}, x: number): ({[number | string]: any}, {[number | string]: any})
	if x <= 0 or x > tablev.len(t) then error("Attempt to split table of invalid index.") end
	
	return split(t, x)
end


--[[ tablev.binsearch(t, v)
	PARAMETERS: 
	- <table> t: The table to split.
	- <number> v: The value to search for.

	RETURNS:
	- <number?> index: The index, or nil if no such index exists.
	
	FOOTNOTES:
	- This behaves similarly to table.find, except this uses a binary search algorithm.
	- This is O(log n) as opposed to table.find's O(n), meaning it is faster in most cases, especially on larger tables.
	- This only works on incrementally sorted tables.
	
	Returns the first available index, using a binary search algorithm, or nil if no such value exists. ]] 
function tablev.binsearch(t: {[number]: number}, v: number): number?
	local lefti, righti = 1, #t
	
	local result = nil

	while lefti <= righti do
		local mid = math.floor((lefti + righti) / 2)
		local midvalue = t[mid]

		if midvalue == v then
			result = mid
			break

		elseif midvalue < v then
			lefti = mid + 1

		else
			righti = mid - 1

		end
	end

	return result
end


--[[ tablev.same(a, b)
	PARAMETERS: 
	- <table> a: The first table to compare.
	- <table> b: The second table to compare.

	RETURNS:
	- <boolean> isSame: Whether both tables are similar or not.
	
	FOOTNOTES:
	- This ignores table values.
	
	Returns whether 2 given tables have the same keys or indexes or not. ]] 
function tablev.same(a: { [string | number]: any }, b: { [string | number]: any }): boolean
	local result = false
	
	if getlength(a) ~= getlength(b) then return result end
	
	for key, _ in a do
		if b[key] == nil then return result end
	end
	
	return true
end


return tablev