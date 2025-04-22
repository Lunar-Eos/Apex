--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local stringv = {}


--[[ Functions: 


 
]]


--[[ stringv.escapestring(s)
	PARAMETERS: 
	<string> s: The string to escape for rich text.

	RETURNS:
	<string> result: The escaped string.

	Escapes a string to make it suitable for rich text. ]] 
function stringv.escapestring(s: string): string
	local tags = {
		{ `&`, `&amp;` },
		{ `<`, `&lt;` },
		{ `>`, `&gt;` },
		{ `"`, `&quot;` },
		{ `'`, `&apos;` },
	}

	local result = s
	for _, tag in tags do
		local match, replace = tag[1], tag[2]
		result = string.gsub(result, match, replace)
	end

	return result
end


--[[ stringv.escapestringpattern(s)
	PARAMETERS: 
	<string> s: The string to escape for string patterns.

	RETURNS:
	<string> result: The escaped string.

	Escapes a string such that potential characters do not count as magic characters for string patterns. ]] 
function stringv.escapestringpattern(s: string): string
	local magicChars = { '%', '$', '^', '*', '(', ')', '.', '[', ']', '+', '-', '?' }
	
	local result = ""
	for i = 1, #s do
		local char = string.sub(s, i, i)
		if table.find(magicChars, char) ~= nil then
			char = `%{char}`
		end
		
		result ..= char
	end
	
	return result
end


--[[ stringv.splitpattern(s, ...)
	PARAMETERS: 
	<string> s: The string to be split.
	<number> ...: The patterns to capture.

	RETURNS:
	<table> result: A table of the substrings split from the original string.

	Splits a string into substrings using patterns. Functions like string.split(), but accepts multiple patterns instead of characters. ]] 
function stringv.splitpattern(s: string, ...: string): {[number]: string} | {}
	local patterns = {...}
	local result = {}

	for occurrence in string.gmatch(s, `[^{patterns[1]}]`) do
		table.insert(result, occurrence)
	end
	
	return result
end


--[[ stringv.startswith(s, prefix)
	PARAMETERS: 
	<string> s: The string to check.
	<string> prefix: The string that would be checked against the start of s.

	RETURNS:
	<boolean> result: Whether the prefix matches what is at the start of the given string.

	Returns whether a given string has the same starting as the prefix provided. ]] 
function stringv.startswith(s: string, prefix: string): boolean
	if #s < #prefix then error("Attempt to match string with a prefix whose length is larger than given string.") end
	
	return string.sub(s, 1, #prefix) == prefix
end


--[[ stringv.endswith(s, suffix)
	PARAMETERS: 
	<string> s: The string to check.
	<string> suffix: The string that would be checked against the end of s.

	RETURNS:
	<boolean> result: Whether the suffix matches what is at the end of the given string.

	Returns whether a given string has the same ending as the suffix provided. ]] 
function stringv.endswith(s: string, suffix: string): boolean
	if #s < #suffix then error("Attempt to match string with a prefix whose length is larger than given string.") end
	
	return string.sub(s, #s - #suffix + 1, #s) == suffix
end


--[[ stringv.capitalize(s, forceFind)
	PARAMETERS: 
	<string> s: The string to capitalize the first character of.

	RETURNS:
	<string> result: The string with the first character capitalized.
	<boolean?> forceFind: Whether to find the first alphabetical character available, regardless of its position in the string. Defaults to false.
	
	Returns a given string with the first character capitalized, if any. ]] 
function stringv.capitalize(s: string, forceFind: boolean?): string
	return if forceFind == true then string.gsub(s, "-%l", string.upper) else string.gsub(s, "^%l", string.upper)
end


--[[ stringv.camelcase(s)
	PARAMETERS: 
	<string> s: The string to convert into camelCase.

	RETURNS:
	<string> result: The string in camelCase.
	
	FOOTNOTES:
	- If a space, dash or underscore is preceding a character, that character will be capitalized.

	Returns a given string in camelcase. ]] 
function stringv.camelcase(s: string): string
	s = string.gsub(s, "(%a)([%w]*)", function(h: string, t: string) 
		return `{string.upper(h)}{string.lower(t)}` 
	end :: (string) -> string)

	s = string.gsub(s, "%A", "")
	s = string.gsub(s, "^%u", string.lower)
	
	return s
end


--[[ stringv.kebabcase(s)
	PARAMETERS: 
	<string> s: The string to convert into kebab-case.

	RETURNS:
	<string> result: The string in kebab-case.
	
	FOOTNOTES:
	- If a space or underscore is present at the front of a character, that character will be kebab-ed.

	Returns a given string in kebab-case, enforcing lowercase. ]] 
function stringv.kebabcase(s: string): string
	s = string.gsub(s, "(%l)(%u)", function(a: string, b: string) 
		return `{a}-{b}` 
	end :: (string) -> string)

	s = string.gsub(s, "%A", "-")
	s = string.gsub(s, "^%-+", "")
	s = string.gsub(s, "%-+$", "")

	return string.lower(s)
end


--[[ stringv.snakecase(s)
	PARAMETERS: 
	<string> s: The string to convert into SNAKE_CASE.

	RETURNS:
	<string> result: The string in SNAKE_CASE.
	
	FOOTNOTES:
	- If a character is uppercase, an underscore will be added at its front.
	- Spaces and dashes are converted into underscores.

	Returns a given string in SNAKE_CASE, enforcing uppercase. ]] 
function stringv.snakecase(s: string): string
	s = string.gsub(s, "(%l)(%u)", function(a: string, b: string) 
		return `{a}_{b}` 
	end :: (string) -> string)

	s = string.gsub(s, "%A", "_")
	s = string.gsub(s, "^_+", "")
	s = string.gsub(s, "_+$", "")

	return string.upper(s)
end


--[[ stringv.titlecase(s)
	PARAMETERS: 
	<string> s: The string to convert into Title Case.

	RETURNS:
	<string> result: The string in Title Case.
	
	FOOTNOTES:
	- If a space is preceding a character, that character is capitalized.

	Returns a given string in Title case. ]] 
function stringv.titlecase(s: string): string
	return string.gsub(s, "(%a)([%w_%-'’]*)", function(h: string, t: string) 
		return `{string.upper(h)}{t}` 
	end :: (string) -> string)
end


--[[ stringv.pad(s, len: number, direction: Enums.StringPadDirection, sub)
	PARAMETERS: 
	<string> s: The string to create padding on.
	<number> len: The length of the padding.
	<string> direction: Whether to pad at the start, end or both. Accepts "Start", "End", and "Both".
	<string?> sub: The string to pad the original string with. Defaults to space.

	RETURNS:
	<string> result: The padded string.
	
	Returns a given string with padding. ]] 
function stringv.pad(s: string, len: number, direction: "Start" | "End" | "Both", sub: string?): string
	if len < 0 then error("Attempt to pad string with a length of less than 0.") end
	
	local newsub = sub or " "
	local result = s

	sub = `{string.rep(sub or " ", math.floor(len / #newsub))}{string.sub(newsub, 1, len % #newsub)}` 
	
	if direction == "Start" then
		result = `{sub}{s}`
		
	elseif direction == "End" then
		result = `{s}{sub}`
		
	elseif direction == "Both" then
		result = `{sub}{s}{sub}`
		
	end
	
	return result
end


--[[ stringv.trim(s)
	PARAMETERS: 
	<string> s: The string to trim whitespace from.

	RETURNS:
	<string> result: The trimmed string.
	
	Returns a given string where there are no whitespace at the start and end of it. ]] 
function stringv.trim(s: string): string
	return string.match(s, "^%s*(.-)%s*$") :: string
end


--[[ stringv.removestart(s, n)
	PARAMETERS: 
	<string> s: The string to remove characters from.
	<number> n: The amount of characters to remove from the start of the string.

	RETURNS:
	<string> result: The edited string.
	
	Removes n amount of characters from the start of a given string. ]] 
function stringv.removestart(s: string, n: number): string
	return string.sub(s, 1 + n)
end


--[[ stringv.removeend(s, n)
	PARAMETERS: 
	<string> s: The string to trim whitespace from.
	<number> n: The amount of characters to remove from the end of the string.

	RETURNS:
	<string> result: The edited string.
	
	Removes n amount of characters from the end of a given string. ]] 
function stringv.removeend(s: string, n: number): string
	return string.sub(s, 1, #s - n)
end


--[[ stringv.commanumber(s)
	PARAMETERS: 
	<string | number> s: The string representation of an integer to add commas to.

	RETURNS:
	<string> result: The number with commas in the correct places.
	
	Returns a given number with commas in certain places. Eg: -1,444,444 ]] 
function stringv.commanumber(s: string | number): string
	local result = tostring(s) :: string

	assert(result ~= nil, "Attempt to supply a non-integer or non-representation of integer into commanumber.")
	
	local int, dec = string.match(result, "([^%.]*)(%.?.*)")
	local revInt = string.reverse(int :: string)
	local substring = string.gsub(revInt, "(%d%d%d)", "%1,")
	local formattedInt = string.reverse(substring)
	
	return formattedInt .. dec :: string
end


--[[ stringv.numsuffix(n)
	PARAMETERS:
	<number> n: The number in question. Must be positive and more than 0.

	RETURNS:
	<string> result: The number, n, with its proper suffix (-st, -nd, -rd, -th).

	Returns a suffixed number as a string. Number must be positive and more than 0. ]]
function stringv.numsuffix(n: number): string
	assert(n > 0, "Attempt to supply zero or negative number into numsuffix.")

	local arr = { "st", "nd", "rd", }
	return if arr[n] ~= nil then `{tostring(n)}{arr[n]}` else `{tostring(n)}"th"`
end


--[[ stringv.numroman(n)
	PARAMETERS:
	<number> n: The number in question. Must be positive, and more than 0.

	RETURNS:
	<string> result: The number, n, converted into Roman numerals.

	Returns the Roman numeral version of the number. ]]
function stringv.numroman(n: number): string
	assert(n > 0, "Attempt to supply zero or negative number into numroman.")
	
	local numberMap: { [number]: {string | number} } = {
		{ 1000, 'M' },
		{ 900, 'CM' },
		{ 500, 'D' },
		{ 400, 'CD' },
		{ 100, 'C' },
		{ 90, 'XC' },
		{ 50, 'L' },
		{ 40, 'XL' },
		{ 10, 'X' },
		{ 9, 'IX' },
		{ 5, 'V' },
		{ 4, 'IV' },
		{ 1, 'I' }
	}
	
	local roman = ""
	while n > 0 do
		for _, v in numberMap do 
			local int = v[1] :: number
			local romanChar = v[2] :: string
			
			while n >= int do
				roman ..= romanChar
				n -= int
			end
		end
	end
	
	return roman
end


--[[ stringv.numbinsuffix(n, nd)
	PARAMETERS:
	<number> n: The number in question.
	<number?> nd: The nearest decimal point to round off to. Defaults to 15.

	RETURNS:
	<string> result: The number, n, shortened with K/M/B/T...

	Returns the number, shortformed with k/m/b/t/... ]]
function stringv.numbinsuffix(n: number, nd: number?): string
	if n < 1000 and n > -1000 then return tostring(n) end
	
	local neg = false
	if n < 0 then
		neg = true
		n = math.abs(n)
	end
	
	local list = {'', 'K', 'M', 'B', 'T', 'Qa', 'Qi', 'Sx', 'Sp', 'Oc', 'No', 'Dc', 'Udc', 'Ddc', 'Tdc'}
	local dp = nd or 15

	local result = if neg == true then "-" else ""
	local digits = math.floor(math.log10(n)) + 1
	local suffix = list[math.floor((digits - 1) / 3) + 1]
	
	result ..= math.floor((n / (10^(3 * math.floor((digits - 1) / 3)))) * 10^dp) / 10^dp .. suffix 
	
	return result
end


--[[ stringv.numpercent(n, nd)
	PARAMETERS:
	<number> n: The number in question.
	<number?> nd: The nearest decimal point to round off to. Defaults to 15.

	RETURNS:
	<string> result: The number converted into a percentage.

	Returns the number converted into a percentage. ]]
function stringv.numpercent(n: number, nd: number?): string
	local dp = nd or 15
	
	return tostring(math.round(n * 100 * 10^dp) / 10^dp)
end


return stringv