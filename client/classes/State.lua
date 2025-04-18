--!nocheck
-- ROBLOX BUG: TYPECHECKING


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local State = {}
State.__index = State


export type State = typeof(setmetatable({} :: {
	_Callback: { (any) -> ()? },
	
	Value: any
}, State))


--[[ Constructors: 

	State.new(value)
	
]]

--[[ Functions: 

	State.new(value)
	State:Get()
	State:Set(new)
	State:RawSet(new)
	State:Update(fn)
	State:RawUpdate(fn)
	State:BindToOnChange(name, callback)
	State:UnbindFromOnChange(name)
	State:Destroy()
	
]]


--[[ State.new(value)
	PARAMETERS: 
	- <any> value: The value to store.

	RETURNS:
	- <State> state: The resulting State object.

	CONSTRUCTOR - Instantiates a new State object, allowing you to store values and track their changes. ]] 
function State.new(value: any): State
	return setmetatable({
		_Callback = {},
		
		Value = value,
	}, State)
end


--[[ State:Get()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.
	
	Returns the value in the State object. ]] 
function State:Get(new: any)
	return self.Value
end


--[[ State:Set(new)
	PARAMETERS: 
	- <any> new: The new value to set.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- If the new value is the same as the stored value, this call is ignored.
	- This method is always called if both the new and stored value are tables, regardless if their contents are the same.

	Sets the value in the State object. See footnotes for more details. ]] 
function State:Set(new: any)
	if new == self.Value then return end
	
	local old = self.Value
	
	self.Value = new
	
	for _, callback in self._Callback do
		callback(old, new)
	end
end


--[[ State:RawSet(new)
	PARAMETERS: 
	- <any> new: The new value to set.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- If the new value is the same as the stored value, this call is ignored.

	Sets the value in the State object, but will not invoke OnChanged callbacks. ]] 
function State:RawSet(new: any)
	if new == self.Value then return end

	self.Value = new
end


--[[ State:Update(fn)
	PARAMETERS: 
	- <function> fn: The function that will be executed to update the value. Must return the new value.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- This method invokes callbacks regardless if the value has changed or not.

	Updates the value in the State object. ]] 
function State:Update(fn: (any) -> (any))
	local old = self.Value
	
	self.Value = fn(self.Value)

	for _, callback in self._Callback do
		callback(old, self.Value)
	end
end


--[[ State:RawUpdate(fn)
	PARAMETERS: 
	- <function> fn: The function that will be executed to update the value. Must return the new value.

	RETURNS:
	- nil.

	Updates the value in the State object, but will not invoke OnChanged callbacks. ]] 
function State:RawUpdate(fn: (any) -> (any))
	self.Value = fn(self.Value)
end


--[[ State:BindToOnChange(callback)
	PARAMETERS: 
	- <string> name: The callback name to register.
	- <function> callback: The callback to invoke when the value is changed.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- The callback accepts 2 arguments - 1 that refers to the old value, and 1 that refers to the newly changed value.

	Attaches a callback that gets fired anytime the value is changed. Use this to track and process value changes. ]] 
function State:BindToOnChange(name: string, callback: (any, any) -> ())
	self._Callback[name] = callback
end


--[[ State:UnbindFromOnChange(callback)
	PARAMETERS: 
	- <string> name: The callback name to find and disconnect.

	RETURNS:
	- nil.

	Disconnects a callback that gets fired anytime the value is changed. ]] 
function State:UnbindFromOnChange(name: string)
	self._Callback[name] = nil
end


--[[ State:Destroy()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.

	Destroys the State object. ]] 
function State:Destroy()
	setmetatable(self, nil)
end


return State