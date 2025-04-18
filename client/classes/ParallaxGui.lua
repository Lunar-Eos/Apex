--!nonstrict

-- TODO:
-- There's notable typechecking bugs in the engine.
-- This object's typechecking will be disabled until the bugs are resolved.


-- Services
local _REPLICATEDSTORAGE = game:GetService("ReplicatedStorage")
local _TWEENSERVICE = game:GetService("TweenService")


-- Libraries
local ClientLibrary = _REPLICATEDSTORAGE.ClientLibrary

local Enums = require(ClientLibrary.Enums)
local mathv = require(ClientLibrary.Generics.mathv)
local ui = require(ClientLibrary.Generics.ui)


-- Upvalues


-- Constants


-- References


-- Variables
local guiCount = 0


-- Functions
local function SerializeVector(v: Vector2)
	return `{v.X} {v.Y}`
end
local function DeserializeVector(v: string)
	local s = string.split(v, " ")
	local x, y = tonumber(s[1]), tonumber(s[2])
	
	return Vector2.new(x, y)
end


-- Module
local ParallaxGui = {}
ParallaxGui.__index = ParallaxGui


export type ParallaxGui = typeof(setmetatable({} :: {
	Frame: GuiObject,
	Objects: { [string]: {GuiObject | UDim2} },
	Enabled: boolean,
	MaxLength: number,

	_Connection: RBXScriptConnection?,
}, ParallaxGui))


--[[ Constructors: 

	ParallaxGui.new(frame, maxLength, ignoreInset)
	
]]

--[[ Functions: 

	ParallaxGui:Insert(object, direction)
	ParallaxGui:Destroy()
]]


--[[ ParallaxGui.new(frame, maxLength, ignoreInset)
	[ MUTATIVE ]

	PARAMETERS: 
	- <GuiObject> frame: The frame to track mouse movement of for the parallax effect.
	- <number> maxLength: The furthest the parallax effect can go.
	- <number> t: The amount of time that the parallax effect can take.
	- <Enum.EasingStyle> easeStyle: The EasingStyle to use for animating the parallax effect.
	- <boolean> ignoreInset: Whether the ScreenGui is ignoring topbar offsets or not.

	RETURNS:
	- <ParallaxGui> gui: The resulting ParallaxGui object.
	
	FOOTNOTES:
	- ParallaxGui requires an existing frame in a ScreenGui. You may hide it if it is affecting your design.

	CONSTRUCTOR - Instantiates a new ParallaxGui object, allowing you to create parallax effects by inserting new GuiObjects into the object. ]] 
function ParallaxGui.new(frame: GuiObject, maxLength: number, t: number, easeStyle: Enum.EasingStyle, ignoreInset: boolean): ParallaxGui
	guiCount += 1
	
	local t = {
		Frame = frame,
		Objects = {},
		Enabled = true,
		
		Time = t,
		EasingStyle = easeStyle,
		MaxLength = maxLength,
	}
	
	t._Connection = frame.InputChanged:Connect(function(input)
		if t.Enabled == false then return end
		
		local mousev2 = Vector2.new(input.Position.X, input.Position.Y + (if ignoreInset == true then ui.topbaroffset * 2 else 0))
		local focusv2 = t.Frame.AbsoluteSize / 2
		local v2 = (focusv2 - mousev2)
		local x, y = v2.X, v2.Y
		
		for svector, collection in t.Objects do
			local sv = DeserializeVector(svector)
			local sx, sy = sv.X or 0, sv.Y or 0
			
			for _, group in collection do
				local object, position = group[1], group[2]
				
				_TWEENSERVICE:Create(object,
					TweenInfo.new(t.Time, t.EasingStyle, Enum.EasingDirection.Out, 0, false, 0),
					{
						Position = UDim2.new(
							position.X.Scale,
							position.X.Offset + (x * maxLength * sx),
							position.Y.Scale,
							position.Y.Offset + (y * maxLength * sy)
						)
					}
				):Play()
				--object.Position = UDim2.new(
				--	position.X.Scale,
				--	position.X.Offset + (x * maxLength * sx),
				--	position.Y.Scale,
				--	position.Y.Offset + (y * maxLength * sy)
				--)
			end
		end
	end)
	
	return setmetatable(t, ParallaxGui)
end


--[[ ParallaxGui:Reset()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.

	Resets the parallax effect. ]] 
function ParallaxGui:Reset()
	for _, direction in self.Objects do
		for _, collection in direction do
			collection[1].Position = collection[2]
		end
	end
end


--[[ ParallaxGui:Insert(object, direction)
	PARAMETERS: 
	- <GuiObject> object: The GuiObject to track.
	- <Vector2> direction: The direction to produce a parallax effect towards.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- The direction is not normalized; the higher the magnitude, the more notable the parallax effect.
	- The parallax effect also affects all children of the inserted object.
	- If this is an issue, insert the children objects with the magnitudinal opposite direction into the ParallaxGui, though doing so consumes memory notably.
	- Otherwise, redesign your UI such that the objects are not children of the inserted object.

	Adds an object into the tracking frame for the parallax effect. ]] 
function ParallaxGui:Insert(object: GuiObject, direction: Vector2)
	if self.Objects[SerializeVector(direction)] == nil then self.Objects[SerializeVector(direction)] = {} end
	
	table.insert(
		self.Objects[SerializeVector(direction)], 
		{ 
			object, object.Position 
		}
	)
end


--[[ ParallaxGui:Update(object, position, direction)
	PARAMETERS: 
	- <GuiObject> object: The GuiObject that is being tracked.
	- <UDim2> position: The new position of the GuiObject.
	- <Vector2> direction: The new direction to produce a parallax effect towards for that GuiObject.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- Use this method to ensure the effect still works when your object has been moved in position.

	Updates an existing GuiObject with new positions and directions. Ignored if the object does not exist. ]] 
function ParallaxGui:Update(object: GuiObject, position: UDim2, direction: Vector2)
	-- First check that the object does exist.
	local real = nil
	for _, direction in self.Objects do
		for i, group in direction do
			local obj, pos = group[1], group[2]
			
			if obj == object then 
				real = obj 
				direction[i] = nil
				
				break 
			end
		end
	end
	if real == nil then warn("Attempt to find object that has not been inserted into ParallaxGui. \nThis call has been ignored.") return end
	
	if self.Objects[SerializeVector(direction)] == nil then self.Objects[SerializeVector(direction)] = {} end
	
	table.insert(
		self.Objects[SerializeVector(direction)], 
		{ 
			object, object.Position 
		}
	)
end


--[[ ParallaxGui:Remove(object)
	PARAMETERS: 
	- <GuiObject> object: The GuiObject to remove.

	RETURNS:
	- nil.

	Removes an existing GuiObject. Ignored if the object does not exist. ]] 
function ParallaxGui:Remove(object: GuiObject)
	for _, direction in self.Objects do
		for i, group in direction do
			local obj = group[1]

			if obj == object then
				direction[i] = nil
				
				return
			end
		end
	end
	
	warn("Attempt to remove object that has not been inserted into ParallaxGui. \nThis call has been ignored.")
end


--[[ ParallaxGui:Destroy()
	PARAMETERS: 
	- nil.

	RETURNS:
	- nil.
	
	FOOTNOTES:
	- The connection is also disconnected upon destruction.
	- This method also freezes the object and removes the attached metatable, preventing any further interaction from the developer.
	- Use this to free memory.

	Destroys the ParallaxGui object. ]] 
function ParallaxGui:Destroy()
	self.Frame = nil
	self.Objects = nil
	self.Enabled = nil
	self._Connection:Disconnect()
	
	setmetatable(self, nil)
	table.freeze(self)
end


return ParallaxGui