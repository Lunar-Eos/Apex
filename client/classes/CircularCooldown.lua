--!nocheck


-- Services
local _REPLICATEDSTORAGE = game:GetService("ReplicatedStorage")
local _TWEENSERVICE = game:GetService("TweenService")


-- Libraries
local ClientLibrary = _REPLICATEDSTORAGE.ClientLibrary

local mathv = require(ClientLibrary.Generics.mathv)


-- Upvalues


-- Constants
local IMAGE_POSITIONS = { UDim2.fromScale(0, 0), UDim2.fromScale(-1, 0) }


-- Variables


-- Functions


-- Module
local CircularCooldown = {}
CircularCooldown.__index = CircularCooldown


type RBXScriptSignal = typeof(Instance.new("BindableEvent").Event)
export type CircularCooldown = typeof(setmetatable({} :: {
	Changed: RBXScriptSignal,
	Completed: RBXScriptSignal,

	Frame: Frame,
	RemainingCooldown: number,
	Cooldown: number,
	Rate: number,
	ReplayWhileActive: boolean,
}, CircularCooldown))


--[[ Functions: 

	CircularCooldown.new(gui, cd, rate, playWhileActive, color, transparency)
	CircularCooldown:Play()
	CircularCooldown:Pause()
	CircularCooldown:Cancel()
	CircularCooldown:Destroy()

]]


--[[ CircularCooldown.new(gui, cd, rate, playWhileActive, color, transparency)
	PARAMETERS: 
	- <GuiObject> gui: The GUI to parent the radial cooldown to.
	- <number> cd: The maximum cooldown.
	- <number?> rate: The rate of which the cooldown ticks down.
	- <boolean?> playWhileActive: Whether to allow subsequent play calls while the radial cooldown is still playing. Defaults to false.
	- <boolean?> showOnCreation: Whether to show the cooldown bar when you first create it. Defaults to false.
	- <Color3?> color: The color of the cooldown bar. Defaults to .fromRGB(172, 172, 172).
	- <number?> transparency: The transparency of the cooldown bar. Defaults to 0.

	RETURNS:
	- <CircularCooldown> result: The resulting CircularCooldown object.

	CONSTRUCTOR - Instantiates a new CircularCooldown object. ]] 
function CircularCooldown.new(gui: GuiObject, cd: number, rate: number?, playWhileActive: boolean?, showOnCreation: boolean?, color: Color3?, transparency: number?): CircularCooldown
	local changedEvent = Instance.new("BindableEvent")
	local completedEvent = Instance.new("BindableEvent")
	
	local folder = Instance.new("Folder")
	folder.Name = "CircularCooldown"
	
	local mainFrame = Instance.new("Frame")
	mainFrame.BackgroundTransparency = 1
	mainFrame.Visible = showOnCreation or false
	mainFrame.Size = UDim2.fromScale(1, 1)
	
	for i = 2, 1, -1 do
		local frame = Instance.new("Frame")
		frame.Name = tostring(i)
		frame.ClipsDescendants = true
		frame.BackgroundTransparency = 1
		frame.Position = UDim2.fromScale(i - 1, 0)
		frame.AnchorPoint = Vector2.new(i - 1, 0)
		frame.Visible = showOnCreation or false
		frame.Size = UDim2.fromScale(0.5, 1)
		
		local image = Instance.new("ImageLabel")
		image.Name = "Shade"
		image.BackgroundTransparency = 1
		image.Image = "rbxassetid://15478839340"
		image.ImageColor3 = color or Color3.fromRGB(172, 172, 172)
		image.ImageTransparency = transparency or 0
		image.Size = UDim2.fromScale(2, 1)
		image.Position = IMAGE_POSITIONS[i]
		
		local gradient = Instance.new("UIGradient")
		gradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(0.501, 1), NumberSequenceKeypoint.new(1, 1) })
		gradient.Rotation = 180 * (i - 1)
		gradient:SetAttribute("StartRotation", 180 * (i - 1))
		gradient:SetAttribute("EndRotation", (180 * (i - 1)) + 180)
		
		gradient.Parent = image
		image.Parent = frame
		frame.Parent = mainFrame
	end
	
	mainFrame.Parent = folder
	folder.Parent = gui
	
	return setmetatable({
		_CooldownObject = Instance.new("NumberValue"),
		_ChangeEvent = changedEvent,
		_CompleteEvent = completedEvent,
		_Connection = nil,
		_Tween = nil,
		
		Changed = changedEvent.Event,
		Completed = completedEvent.Event,
		
		Frame = mainFrame,
		RemainingCooldown = cd,
		Cooldown = cd,
		Rate = rate or 1,
		ReplayWhileActive = playWhileActive or false,
	}, CircularCooldown)
end


--[[ CircularCooldown:Play()
	PARAMETERS:
	- nil.

	RETURNS:
	- nil.

	Plays the radial cooldown. ]] 
function CircularCooldown:Play()
	if self.ReplayWhileActive == false and self.RemainingCooldown > 0 and self.RemainingCooldown < self.Cooldown then return end

	-- First reset all frames and values.
	do
		self.RemainingCooldown = self.Cooldown

		self.Frame.Visible = true

		for _, object in self.Frame:GetDescendants() do
			if object:IsA("Frame") == true then 
				object.Visible = true
			elseif object:IsA("UIGradient") then
				object.Rotation = object:GetAttribute("StartRotation")
			end
		end
	end
	
	-- Then play the cooldown.
	do
		self.Frame.Visible = true
		self._CooldownObject.Value = self.RemainingCooldown

		if self._Tween ~= nil then self._Tween:Destroy() end
		self._Tween = _TWEENSERVICE:Create(self._CooldownObject, TweenInfo.new(self.RemainingCooldown / self.Rate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), { Value = 0 })
		self._Tween:Play()
	end
	
	-- Then toggle the halves based on the remaining cooldown duration.
	do
		for i = 1, 2 do
			self.Frame[i].Visible = false
		end
		
		for i = math.ceil(mathv.normalize(self._CooldownObject.Value, 0, self.Cooldown) * 2), 1, -1 do
			self.Frame[i].Visible = true
		end
	end
	
	-- Then count down the cooldown.
	do
		if self._Connection ~= nil then self._Connection:Disconnect() end
		self._Connection = self._CooldownObject.Changed:Connect(function()
			self.RemainingCooldown = self._CooldownObject.Value
			self._ChangeEvent:Fire(self._CooldownObject.Value)
			
			local index = math.clamp(math.ceil(mathv.normalize(self._CooldownObject.Value, 0, self.Cooldown) * 2), 1, 2)
			local gradient = self.Frame[tostring(index)].Shade.UIGradient

			gradient.Rotation = mathv.lerp(
				gradient:GetAttribute("EndRotation"), 
				gradient:GetAttribute("StartRotation"),
				mathv.normalize(self._CooldownObject.Value, (self.Cooldown / 2) * (index - 1), (self.Cooldown / 2) * index)
			)

			for i = index + 1, 2 do
				self.Frame[tostring(i)].Visible = false
			end
		end)
	end
	
	-- Finally fire completion events and Destroy connections when complete.
	do
		self._Tween.Completed:Connect(function()
			self.Frame["1"].Visible = false
			self.Frame["2"].Visible = false
			
			self._CompleteEvent:Fire()
			self._Tween:Destroy()

			self._Connection:Disconnect()
		end)
	end
end


--[[ CircularCooldown:Pause()
	PARAMETERS:
	- nil.

	RETURNS:
	- nil.

	Pauses the radial cooldown object. ]] 
function CircularCooldown:Pause()
	if self._Tween ~= nil then self._Tween:Pause() end
end


--[[ CircularCooldown:Cancel()
	PARAMETERS:
	- nil.

	RETURNS:
	- nil.

	Cancels the radial cooldown object. ]] 
function CircularCooldown:Cancel()
	if self._Tween ~= nil then 
		self._Tween:Cancel() 
		self.RemainingCooldown = self.Cooldown
	end
end


--[[ CircularCooldown:Destroy()
	PARAMETERS:
	- nil.

	RETURNS:
	- nil.

	Destroys the radial cooldown object. ]] 
function CircularCooldown:Destroy()
	self._CooldownObject:Destroy()
	self.Frame.Parent:Destroy()
	self._ChangeEvent:Destroy()
	
	if self._Connection ~= nil then self._Connection:Disconnect() end
	if self._Tween ~= nil then self._Tween:Destroy() end
end


return CircularCooldown