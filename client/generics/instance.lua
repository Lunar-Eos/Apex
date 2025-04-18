--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local instance = {}


--[[ Functions: 

	instance.getChildrenOfClass(inst, ...)
	instance.getDescendantsOfClass(inst, ...)
	instance.getChildrenWhichIsA(inst, ...)
	instance.getDescendantsWhichIsA(inst, ...)
	instance.getChildrenOfConditions(inst, fn)
	instance.getDescendantsOfConditions(inst, fn)
	instance.findFirstChildOfConditions(inst, fn)
	instance.findFirstDescendantOfConditions(inst, fn)
 
]]


--[[ instance.getChildrenOfClass(inst, ...)
	PARAMETERS: 
	- <Instance> inst: The instance to find the children of.
	- <string> ...: The class names to match for all of the children of the given instance.

	RETURNS:
	- <table> t: The table of children that matches the given class.

	Returns an array of children under a given instance that matches either of the given classes. ]] 
function instance.getChildrenOfClass(inst: Instance, ...: string): { [number]: Instance }
	local t = {}
	
	for _, v in inst:GetChildren() do
		if table.find({...}, v.ClassName) == nil then continue end
		
		table.insert(t, v)
	end
	
	return t
end


--[[ instance.getDescendantsOfClass(inst, ...)
	PARAMETERS: 
	- <Instance> inst: The instance to find the children of.
	- <string> ...: The class names to match for all of the children of the given instance.

	RETURNS:
	- <table> t: The table of children that matches the given class.

	Returns an array of descendants under a given instance that matches the given class. ]] 
function instance.getDescendantsOfClass(inst: Instance, ...: string): { [number]: Instance }
	local t = {}

	for _, v in inst:GetDescendants() do
		if table.find({...}, v.ClassName) == nil then continue end

		table.insert(t, v)
	end

	return t
end


--[[ instance.getChildrenWhichIsA(inst, ...)
	PARAMETERS: 
	- <Instance> inst: The instance to find the children of.
	- <string> ...: The class names to match for all of the children of the given instance.

	RETURNS:
	- <table> t: The table of children that matches the given class.

	Returns an array of children under a given instance that matches the given class, respecting inheritance. ]] 
function instance.getChildrenWhichIsA(inst: Instance, ...: string): { [number]: Instance }
	local x = {}

	for _, v in inst:GetChildren() do
		for _, t in {...} do
			if v:IsA(t) == true then
				table.insert(x, v)
				break
			end
		end
	end

	return x
end


--[[ instance.getDescendantsWhichIsA(inst, ...)
	PARAMETERS: 
	- <Instance> inst: The instance to find the children of.
	- <string> ...: The class names to match for all of the children of the given instance.

	RETURNS:
	- <table> t: The table of children that matches the given class.

	Returns an array of descendants under a given instance that matches the given class, respecting inheritance. ]] 
function instance.getDescendantsWhichIsA(inst: Instance, ...: string): { [number]: Instance }
	local x = {}

	for _, v in inst:GetDescendants() do
		for _, t in {...} do
			if v:IsA(t) == true then
				table.insert(x, v)
				break
			end
		end
	end

	return x
end


--[[ instance.getChildrenOfConditions(inst, fn)
	PARAMETERS: 
	- <Instance> inst: The instance to find the children of.
	- <Function> fn: A callback function that returns either true or false based on the conditions. Accepts an instance as the parameter.

	RETURNS:
	- <table> t: The table of children that matches the given class.

	Returns an array of children under a given instance that fulfills the given conditions. ]] 
function instance.getChildrenOfConditions(inst: Instance, fn: (Instance) -> boolean): { [number]: Instance }
	local x = {}

	for _, v in inst:GetChildren() do
		if fn(v) == true then 
			table.insert(x, v) 
			continue 
		end
	end

	return x
end


--[[ instance.getDescendantsOfConditions(inst, fn)
	PARAMETERS: 
	- <Instance> inst: The instance to find the children of.
	- <Function> fn: A callback function that returns either true or false based on the conditions. Accepts an instance as the parameter.

	RETURNS:
	- <table> t: The table of children that matches the given class.

	Returns an array of descendants under a given instance that fulfills the given conditions. ]] 
function instance.getDescendantsOfConditions(inst: Instance, fn: (Instance) -> boolean): { [number]: Instance }
	local x = {}

	for _, v in inst:GetDescendants() do
		if fn(v) == true then 
			table.insert(x, v) 
			continue 
		end
	end

	return x
end


--[[ instance.findFirstChildOfConditions(inst, fn)
	PARAMETERS: 
	- <Instance> inst: The instance to search a given child for.
	- <function> fn: A callback function that returns either true or false based on the conditions. Accepts an instance as the parameter.

	RETURNS:
	- <Instance?> t: The first instance that matches the conditions given.

	Returns the first child under a given instance that fulfills the given conditions, or nil if no such instances are found. ]] 
function instance.findFirstChildOfConditions(inst: Instance, fn: (Instance) -> boolean): Instance?
	local new = nil
	
	for _, child in inst:GetChildren() do
		if fn(child) == true then return child end
	end
	
	return new
end


--[[ instance.findFirstDescendantOfConditions(inst, fn)
	PARAMETERS: 
	- <Instance> inst: The instance to search a given descendant for.
	- <function> fn: A callback function that returns either true or false based on the conditions. Accepts an instance as the parameter.

	RETURNS:
	- <Instance?> t: The first instance that matches the conditions given.

	Returns the first descendant under a given instance that fulfills the given conditions, or nil if no such instances are found. ]] 
function instance.findFirstDescendantOfConditions(inst: Instance, fn: (Instance) -> boolean): Instance?
	local new = nil

	for _, child in inst:GetDescendants() do
		if fn(child) == true then return child end
	end

	return new
end


return instance