--!native
--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions
local function gettabletotal(t: { [number]: number }): number
	local x = 0

	for _, v in t do
		if typeof(v) ~= "number" then error("Attempt to provide non-number in array.") end

		x += v
	end

	return x
end

local function getaverage(t: { [number]: number }): number
	return gettabletotal(t) / #t
end

local function getmedian(t: { [number]: number }): number
	local x = 0

	if #t % 2 == 0 then
		local first = t[#t / 2]
		local second = t[(#t / 2) + 1]

		x = (first + second) / 2
	else
		x = t[math.ceil(#t / 2)]
	end

	return x
end

local function splittable(t: { [number]: number }, a: number, b: number): { [number]: number }
	local x = {}
	
	for i = a, b, 1 do
		table.insert(x, t[i])
	end
	
	return x
end

local function sd(t: { [number]: number }, popn: boolean?): number
	popn = popn or true
	local mean = getaverage(t)
	local sum = 0

	for _, v in t do
		sum += (v - mean) ^ 2
	end

	return if popn == true then math.sqrt(sum / #t) else math.sqrt(sum / (#t - 1))
end


-- Module
local statistics = {}


--[[ Functions: 

	statistics.mean(t)
	statistics.median(t)
	statistics.mode(t)
	statistics.range(t)
	statistics.lowest(t)
	statistics.highest(t)
	statistics.stdev(t, popn)
	statistics.zscore(t, popn)
	statistics.mad(t)
	statistics.quartiles(t)
	statistics.iqrt(t)
	statistics.iqr(q1, q3)
	statistics.linreg(...)
	statistics.linregnext(x, slope, yint)
	
]]


--[[ statistics.mean(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> x: The mean of the values.

	Returns the mean or average value of the values within the provided dataset. ]] 
function statistics.mean(t: { [number]: number }): number
	return getaverage(t)
end


--[[ statistics.median(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> x: The median of the values.
	
	FOOTNOTES:
	- The dataset must be sorted in increasing order first.

	Returns the median/middle value within the provided dataset. ]] 
function statistics.median(t: { [number]: number }): number
	for _, v in t do
		if typeof(v) ~= "number" then error("Attempt to provide non-number in array.") end
	end
	
	return getmedian(t)
end


--[[ statistics.mode(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> x: The mode of the values.

	Returns the mode value, or the value with the most occurrences, within the provided dataset. ]] 
function statistics.mode(t: { [number]: number }): number?
	local tx = {}

	for _, v in t do
		if typeof(v) ~= "number" then error("Attempt to provide non-number in array.") end
		
		if tx[tostring(v)] == nil then 
			tx[tostring(v)] = 1 
		else
			tx[tostring(v)] += 1
		end
	end
	
	local index, count = "", 0
	for k, v in tx do
		if count < v then
			index = k
			count = v
		end
	end
	
	return tonumber(index)
end


--[[ statistics.range(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> x: The range of the values.

	Returns the difference between the maximum and minimum values of the provided dataset. ]] 
function statistics.range(t: { [number]: number }): number
	if #t < 2 then return 0 end
	
	local min, max = t[1], 0
	for _, v in t do
		if min > v then min = v end
		if max < v then max = v end
	end
	
	return max - min
end


--[[ statistics.lowest(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> x: The lowest of the values.

	Returns the lowest value of the provided dataset. ]] 
function statistics.lowest(t: { [number]: number }): number
	if #t < 1 then return 0 end

	local min = t[1]
	for _, v in t do
		if min > v then min = v end
	end

	return min
end


--[[ statistics.highest(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> x: The highest of the values.

	Returns the highest value of the provided dataset. ]] 
function statistics.highest(t: { [number]: number }): number
	if #t < 1 then return 0 end

	local max = 0
	for _, v in t do
		if max < v then max = v end
	end

	return max
end


--[[ statistics.stdev(t, popn)
	PARAMETERS: 
	- <table> t: An array of numbers.
	- <boolean?> popn: Whether the given table is a population or a sample. Defaults to true.

	RETURNS:
	- <number> x: The standard deviation of the dataset.
	
	FOOTNOTES:
	- Standard deviation; a measure of how dispersed the data points are from the average.

	Returns the standard deviation of the given dataset. Optionally declare if the table is a population or a sample. ]] 
function statistics.stdev(t: { [number]: number }, popn: boolean?): number
	return sd(t, popn)
end


--[[ statistics.zscore(t, popn)
	PARAMETERS: 
	- <table> t: An array of numbers.
	- <boolean?> popn: Whether the given table is a population or a sample. Defaults to true.

	RETURNS:
	- <table> result: A dictionary of all values, and their individual standard deviations.
	
	FOOTNOTES:
	- Indicates how far apart each value is from the mean, using standard deviation terms.
	- Generally, the higher the z-score, the further it is from the mean, and the less common it is.
	- Providing a stdev and/or mean argument will save time on this function.

	Returns the standard deviations of every value in comparison to the mean. Optionally declare if the table is a population or a sample. ]] 
function statistics.zscore(t: { [number]: number }, popn: boolean?): {[string]: number}
	local stdev, mean = sd(t, popn), getaverage(t)
	local result = {}
	
	for _, v in t do
		if result[tostring(v)] ~= nil then continue end
		
		result[tostring(v)] = (v - mean) / stdev
	end
	
	return result
end


--[[ statistics.mad(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> x: The mean average deviation of the dataset.
	
	FOOTNOTES:
	- Known as the mean absolute deviation (MAD) of a given dataset.
	- Useful for finding how "far apart" the data points are from the average.

	Returns the mean absolute deviation from the average of the given dataset. ]] 
function statistics.mad(t: { [number]: number }): number
	local mean = getaverage(t)
	local tx = {}
	
	for _, v in t do
		table.insert(tx, math.abs(v - mean))
	end
	
	return getaverage(tx)
end


--[[ statistics.quartiles(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> a: The lower quartile value of the dataset.
	- <number> b: The median value of the dataset.
	- <number> c: The upper quartile value of the dataset.
	
	FOOTNOTES:
	- The dataset must be sorted in increasing order first.
	- Developers may want to use statistics.median if they are only interested in the middle value of the dataset.

	Returns the quartile values of the dataset. ]] 
function statistics.quartiles(t: { [number]: number }): (number, number, number)
	for i = 1, #t - 1, 1 do
		if t[i] > t[i + 1] then error("Attempt to call statistics.quartile on a table that is not sorted in increasing order.") end
		if typeof(t[i]) ~= "number" or typeof(t[i + 1]) ~= "number" then error("Attempt to provide non-number in statistics.quartile.") end
	end
	
	local a, b, c = 0, 0, 0
	
	a = getmedian(splittable(t, 1, math.floor(#t / 2)))
	b = getmedian(t)
	c = getmedian(splittable(t, math.ceil(#t / 2) + 1, #t))
	
	return a, b, c
end


--[[ statistics.iqrt(t)
	PARAMETERS: 
	- <table> t: An array of numbers.

	RETURNS:
	- <number> iqr: The interquartile range of the dataset.
	
	FOOTNOTES:
	- The dataset must be sorted in increasing order first.
	- Known as interquartile range; indicates how dispersed the quartiles are.

	Returns the interquartile range of the dataset. ]] 
function statistics.iqrt(t: { [number]: number }): number
	for i = 1, #t - 1, 1 do
		if t[i] > t[i + 1] then error("Attempt to call statistics.quartile on a table that is not sorted in increasing order.") end
		if typeof(t[i]) ~= "number" or typeof(t[i + 1]) ~= "number" then error("Attempt to provide non-number in statistics.iqrt.") end
	end

	local q1, q3 = 0, 0

	q1 = getmedian(splittable(t, 1, math.floor(#t / 2)))
	q3 = getmedian(splittable(t, math.ceil(#t / 2) + 1, #t))

	return q3 - q1
end


--[[ statistics.iqr(q1, q3)
	PARAMETERS: 
	- <number> q1: The lower quartile.
	- <number> q3: The higher quartile.

	RETURNS:
	- <number> iqr: The interquartile range of the dataset.
	
	FOOTNOTES:
	- The dataset must be sorted in increasing order first.
	- Known as interquartile range; indicates how dispersed the quartiles are.

	Returns the interquartile range, given 2 quartiles. ]] 
function statistics.iqr(q1: number, q3: number): number
	return q3 - q1
end


--[[ statistics.linreg(...)
	PARAMETERS: 
	- <table> ...: The data points to analyze. Each data point must be an array of 2 numbers.

	RETURNS:
	- <number> slope: The trend of the dataset when regressed linearly. Positive means the values tend to increase, decrease otherwise.
	- <number> yint: The value when x is 0.
	- <number> r: Indicates how well the "line" fits the dataset.
	
	FOOTNOTES:
	- The dataset must be sorted in increasing order first.
	- Provides a linear "slope" to the dataset; indicates the general trend of the data.
	- r indicates how well the linear "slope" fits the dataset; the higher the value, the less fitting.
	- Use this as a precursor to predict your next data using statistics.linregnext.

	Returns the trend, y-intercept and "closeness" of the dataset. ]] 
function statistics.linreg(...: { [number]: number }): (number, number, number)
	local t = {...}
	local x, y = {}, {}
	
	for i, v in t do
		table.insert(x, v[1])
		table.insert(y, v[2])
	end

	local xmean = getaverage(x)
	local ymean = getaverage(y)
	local xstdev = sd(x, true)
	local ystdev = sd(y, true)

	local xysum = 0
	for i = 1, #x do
		xysum += (x[i] - xmean) * (y[i] - ymean)
	end
	
	local xsum, ysum = 0,0
	for i = 1, #x do
		xsum += (x[i] - xmean)^2
		ysum += (y[i] - ymean)^2
	end
	
	local r = xysum / math.sqrt(math.abs(xsum * ysum))
	local slope = r * (ystdev / xstdev)
	local yint = ymean - (slope * xmean)
	
	return slope, yint, r
end


--[[ statistics.linregnext(x, slope, yint)
	PARAMETERS: 
	- <number> x: The expected independent data.
	- <number> slope: The trend of the data.
	- <number> yint: The value when x is 0.

	RETURNS:
	- <number> expected: The predicted dependent data based on the slope.
	
	FOOTNOTES:
	- Use statistics.linreg to get slope and yint.
	- This lets you predict the next data point, given the linear regression variables and independent data.

	Returns the best possible prediction of the next data point. See footnotes for more details. ]] 
function statistics.linregnext(x: number, slope: number, yint: number): number
	return (slope * x) + yint 
end


return statistics