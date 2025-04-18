--!native
--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local mathv = {
	eulers = 2.718281828459045,
	phi = 1.618033988749895,
	tau = 6.283185307179586,
}


--[[ Functions: 

	mathv.isnan(a)
	mathv.numtype(n)
	mathv.dpround(n, d)
	mathv.sfround(n, sf)
	mathv.ceil(n, dp)
	mathv.floor(n, dp)
	mathv.swap(a, b)
	mathv.lerp(a, b, t)
	mathv.normalize(x, min, max)
	mathv.circlamp(x, min, max)
	mathv.lcm(a, b)
	mathv.hcf(a, b)
	mathv.factorial(a)
	mathv.factors(a)
	mathv.fibonaccinum(n)
	mathv.rootnum(n)
	mathv.ctok(n)
	mathv.ctof(n)
	mathv.ftoc(n)
	mathv.ftok(n)
	mathv.ktoc(n)
	mathv.ktof(n)
	mathv.mulseq(a, b)
	mathv.addseq(a, b)
	mathv.ncr(n, r)
	mathv.npr(n, r)
	mathv.vertex(a, b, c)
	
]]


--[[ mathv.isnan(a)
	PARAMETERS: 
	- <number> a: The number to check.

	RETURNS:
	- <boolean> is: Whether a is NaN or not.
	
	FOOTNOTES:
	- NaNs can cause problems in certain parts of Roblox's engine. Use this function to check if a number is NaN or not.

	Returns whether a given number is NaN or not. ]] 
function mathv.isnan(a: number): boolean
	return a == a
end


--[[ mathv.numtype(n)
	PARAMETERS: 
	- <number> n: The number in question.

	RETURNS:
	- <NumberType> t: The type of number.

	Returns the type of the number, such as float or integer. ]] 
function mathv.numtype(n: number): string
	return if n % 1 == 0 then "integer" else "float"
end


--[[ mathv.dpround(n, d)
	PARAMETERS: 
	- <number> n: The number in question.
	- <number> d: How many decimal places to round to.

	RETURNS:
	- <number> result: The number, n, rounded off to decimals places defined by d.

	Returns a number rounded to its closest specified decimal place. ]] 
function mathv.dpround(n: number, d: number): number
	local e = tonumber(string.format(`%.{d}f`, n))
	
	if e == nil then error("Rounding error - n must be a valid number.") end
	
	return e
end


--[[ mathv.sfround(n, sf)
	PARAMETERS: 
	- <number> n: The number in question.
	- <number> sf: How many significant figures to round to.

	RETURNS:
	- <number> result: The number, n, rounded off to significant figures defined by sf.

	Returns a number rounded to its closest specified significant figure. ]] 
function mathv.sfround(n: number, sf: number): number
	if sf <= 0 then error("Rounding error - sf must be more than 0.") end
	if sf % 1 ~= 0 then error("Rounding error - sf must be an integer.") end
	if #tostring(n) < sf then return n end
	
	local e = tonumber(string.format(`%.{sf}g`, n))
	
	if e == nil then error("Rounding error - n must be a valid number.") end
	
	return e
end


--[[ mathv.ceil(n, dp)
	PARAMETERS: 
	- <number> n: The number in question.
	- <number> dp: How many decimal points to perform the ceiling operation to.

	RETURNS:
	- <number> result: The number, n, ceiled to the defined decimal point.
	
	FOOTNOTES:
	- This function behaves exactly like math.ceil, but works with decimals.
	
	Returns a number ceiled to the defined decimal point. ]] 
function mathv.ceil(n: number, dp: number): number
	if dp < 0 then error("Ceil error - dp must be 0 or more.") end
	if dp % 1 ~= 0 then error("Ceil error - dp must be an integer.") end
	
	return math.ceil(n * (10^dp)) / 10^dp
end


--[[ mathv.floor(n, dp)
	PARAMETERS: 
	- <number> n: The number in question.
	- <number> dp: How many decimal points to perform the flooring operation to.

	RETURNS:
	- <number> result: The number, n, floored to the defined decimal point.
	
	FOOTNOTES:
	- This function behaves exactly like math.floor, but works with decimals.
	
	Returns a number floored to the defined decimal point. ]] 
function mathv.floor(n: number, dp: number): number
	if dp < 0 then error("Floor error - dp must be 0 or more.") end
	if dp % 1 ~= 0 then error("Floor error - dp must be an integer.") end

	return math.floor(n * (10^dp)) / 10^dp
end


--[[ mathv.swap(a, b)
	PARAMETERS: 
	- <number> a: The first number.
	- <number> b: The second number.

	RETURNS:
	- <number> a: The second number.
	- <number> b: The first number.

	Returns two swapped values. ]] 
function mathv.swap(a: number, b: number): (number, number)
	a, b = b, a
	return a, b
end


--[[ mathv.lerp(a, b, t)
	PARAMETERS: 
	- <number> a: The lowest value.
	- <number> b: The highest value.
	- <number> t: The alpha to get in between a and b.

	RETURNS:
	- <number> c: The number between a and b, based on the alpha t.

	Returns the number between a and b, based on the alpha x (0 to 1). ]] 
function mathv.lerp(a: number, b: number, t: number): number
	return a * (1 - t) + b * t
end


--[[ mathv.normalize(min, max, x)
	PARAMETERS: 
	- <number> a: The minimum.
	- <number> b: The maximum.
	- <number> x: The number in question.

	RETURNS:
	- <number> x: The normalized number between 0 to 1.

	Returns the number normalized between 0 to 1. ]] 
function mathv.normalize(x: number, min: number, max: number): number
	return math.clamp((x - min) / (max - min), 0, 1)
end


--[[ mathv.circlamp(x, min, max)
	PARAMETERS: 
	- <number> x: The number in question.
	- <number> a: The minimum.
	- <number> b: The maximum.

	RETURNS:
	- <number> x: The clamped number that is inverted to max if below min, and vice versa.

	Returns the number clamped between a and b, but is overflown/underflown (eg: min -> max, max -> min). ]] 
function mathv.circlamp(x: number, min: number, max: number): number
	while x < min do
			x = max - (min - x - 1)
	end
	
	while x > max do
			x = min + (x - max - 1)
	end

	return x
end
	

--[[ mathv.lcm(a, b)
	PARAMETERS: 
	- <number> a: The first number.
	- <number> b: The second number.

	RETURNS:
	- <number> x: The lowest common multiple for a and b.

	Returns the lowest common multiple for a and b. ]] 
function mathv.lcm(a: number, b: number): number
	local greater = if a > b then a else b
	
	while true do
		if greater % a == 0 and greater % b == 0 then 
			return greater
		end
			
		greater += 1
	end
end


--[[ mathv.hcf(a, b)
	PARAMETERS: 
	- <number> a: The first number.
	- <number> b: The second number.

	RETURNS:
	- <number> x: The highest common factor for a and b.

	Returns the highest common factor for a and b. Also known as greatest common divisor (GCD). ]] 
function mathv.hcf(a: number, b: number): number
	if b == 0 then
		return a
	else 
		return mathv.hcf(b, a % b)
	end
end


--[[ mathv.factorial(a)
	PARAMETERS: 
	- <number> a: The natural number to get its factorial of.

	RETURNS:
	- <number> x: The factorial value of a.

	Returns the factorial value of the given natural number (positive integers). ]] 
function mathv.factorial(a: number): number
	if a < 0 then error("Attempt to provide negative number to mathv.factorial.") end
	if a % 1 ~= 0 then error("Attempt to provide non-natural number to mathv.factorial.") end
	
	if a == 0 then return 0 end
	
	local x = 1
	for i = a, 1, -1 do
		x *= i 
	end
	
	return x
end


--[[ mathv.factors(a)
	PARAMETERS: 
	- <number> a: The natural number to get the factors of.

	RETURNS:
	- <table> x: The factors of a.

	Returns the factors of a given number in a table. ]] 
function mathv.factors(a: number): { [number]: number }
	if a % 1 ~= 0 then error("Attempt to provide non-natural number to mathv.factors.") end
	
	local t = {}
	
	for i = 1, a^0.5 do
		if a % i == 0 then
			table.insert(t, i)
			table.insert(t, a/i)
		end
	end
	
	table.sort(t, function(a, b)
		return a < b
	end)
	
	return t
end


--[[ mathv.fibonaccinum(n)
	PARAMETERS: 
	- <number> n: The Fibonacci number index to get.

	RETURNS:
	- <table> x: The nth Fibonacci number.

	Returns the nth Fibonacci number. ]] 
function mathv.fibonaccinum(n: number): number
	return math.floor(mathv.phi ^ n / math.sqrt(5) + 1/2)
end


--[[ mathv.rootnum(x, y)
	PARAMETERS: 
	- <number> x: The result of the base and exponent.
	- <number> y: The base.

	RETURNS:
	- <number> x: The exponent.

	Returns the exponent of a given base and result. ]] 
function mathv.rootnum(x: number, y: number): number
	return x^(1 / y)
end


--[[ mathv.ctok(n)
	PARAMETERS: 
	- <number> n: The temperature in celsius.

	RETURNS:
	- <number> x: The temperature in kelvin.

	Returns the temperature in kelvin, converted from celsius. ]] 
function mathv.ctok(n: number): number
	return n + 273.15
end


--[[ mathv.ctof(n)
	PARAMETERS: 
	- <number> n: The temperature in celsius.

	RETURNS:
	- <number> x: The temperature in fahrenheit.

	Returns the temperature in fahrenheit, converted from celsius. ]] 
function mathv.ctof(n: number): number
	return (n * 1.8) + 32
end


--[[ mathv.ftoc(n)
	PARAMETERS: 
	- <number> n: The temperature in fahrenheit.

	RETURNS:
	- <number> x: The temperature in celsius.

	Returns the temperature in celsius, converted from fahrenheit. ]] 
function mathv.ftoc(n: number): number
	return (n - 32) * (5/9)
end


--[[ mathv.ftok(n)
	PARAMETERS: 
	- <number> n: The temperature in fahrenheit.

	RETURNS:
	- <number> x: The temperature in kelvin.

	Returns the temperature in kelvin, converted from fahrenheit. ]] 
function mathv.ftok(n: number): number
	return (n - 32) * (5/9) + 273.15 
end


--[[ mathv.ktoc(n)
	PARAMETERS: 
	- <number> n: The temperature in kelvin.

	RETURNS:
	- <number> x: The temperature in celsius.

	Returns the temperature in celsius, converted from kelvin. ]] 
function mathv.ktoc(n: number): number
	return n - 273.15
end


--[[ mathv.ktof(n)
	PARAMETERS: 
	- <number> n: The temperature in kelvin.

	RETURNS:
	- <number> x: The temperature in fahrenheit.

	Returns the temperature in fahrenheit, converted from kelvin. ]] 
function mathv.ktof(n: number): number
	return (n - 273.15) * (9/5) + 32
end


--[[ mathv.mulseq(a, b)
	PARAMETERS: 
	- <number> a: The integer to begin multiplying.
	- <number> b: The integer to end multiplying.

	RETURNS:
	- <number> x: The result after multiplying numbers in a sequence from a to b.

	Returns the result of multiplying numbers in a sequence from a to b. Eg: 1 * 2 * 3 * 4... ]] 
function mathv.mulseq(a: number, b: number): number
	if a % 1 ~= 0 or b % 1 ~= 0 then error("Attempt to supply non-natural/non-integer number.") end
	
	local x = 0
	for i = a, b do
		x *= i
	end
	return x
end


--[[ mathv.addseq(a, b)
	PARAMETERS: 
	- <number> a: The integer to begin adding.
	- <number> b: The integer to end adding.

	RETURNS:
	- <number> x: The result after adding numbers in a sequence from a to b.

	Returns the result of adding numbers in a sequence from a to b. Eg: 1 + 2 + 3 + 4... ]] 
function mathv.addseq(a: number, b: number): number
	if a % 1 ~= 0 or b % 1 ~= 0 then error("Attempt to supply non-natural/non-integer number.") end

	if a == b then return a end
	if a > b then a, b = b, a end

	return ((b - a + 1) * (a + b)) / 2
end


--[[ mathv.ncr(n, r)
	PARAMETERS: 
	- <number> n: The amount of items to select from.
	- <number> r: The amount of items to select.

	RETURNS:
	- <number> x: The amount of n combinations available from group r.
	
	FOOTNOTES:
	- Use this function if the order of which items are selected DO NOT matter.

	Returns the combinations available, given the selection count and a group. ]] 
function mathv.ncr(n: number, r: number): number
	local t = 1
	for i = n, r + 1, -1 do
		t *= i
	end
	
	local d = 1
	for i = 1, n - r do
		d *= i
	end
	
	return t / d
end


--[[ mathv.npr(n, r)
	PARAMETERS: 
	- <number> n: The amount of items to select from.
	- <number> r: The amount of items to select.

	RETURNS:
	- <number> x: The amount of n permutations available from group r.
	
	FOOTNOTES:
	- Use this function if the order of which items are selected DO matter.

	Returns the permutations available, given the selection count and a group. ]] 
function mathv.npr(n: number, r: number): number
	local t = 1
	
	for i = n, n - r + 1, -1 do
		t *= i
	end
	
	return t
end


--[[ mathv.vertex(a, b, c)
	PARAMETERS: 
	- <number> a: The "a" coefficient of the parabolic formula.
	- <number> b: The "b" coefficient of the parabolic formula.
	- <number> c: The "c" constant of the parabolic formula.

	RETURNS:
	- <number> x: The X coordinate of the vertex.
	- <number> y: The Y coordinate of the vertex.
	
	FOOTNOTES:
	- This returns a deserialized 2D vector for the "peak" of a given parabola.
	- This is based on the quadratic formula (ax^2 + bx + c).

	Returns the coordinates of the highest/lowest point of a given parabola. ]] 
function mathv.vertex(a: number, b: number, c: number): (number, number)
	return -b / (2 * a), -b^2 / (4 * a) + c
end



return mathv