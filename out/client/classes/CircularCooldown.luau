-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local mathv = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "generics", "mathv")
local TweenService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService
local IMAGE_POSITIONS = { UDim2.fromScale(0, 0), UDim2.fromScale(-1, 0) }
local DEFAULT_SHOW_ON_DEFAULT = false
local DEFAULT_COLOR = Color3.fromRGB(172, 172, 172)
local DEFAULT_TRANSPARENCY = 0
local CircularCooldown
do
	CircularCooldown = setmetatable({}, {
		__tostring = function()
			return "CircularCooldown"
		end,
	})
	CircularCooldown.__index = CircularCooldown
	function CircularCooldown.new(...)
		local self = setmetatable({}, CircularCooldown)
		return self:constructor(...) or self
	end
	function CircularCooldown:constructor(gui, cd, rate, playWhileActive, showOnCreation, color, transparency)
		self._CooldownObject = Instance.new("NumberValue")
		self._ChangeEvent = Instance.new("BindableEvent")
		self._CompleteEvent = Instance.new("BindableEvent")
		self._Connection = nil
		self._Tween = nil
		self.Changed = self._ChangeEvent.Event
		self.Completed = self._CompleteEvent.Event
		local folder = Instance.new("Folder")
		folder.Name = "CircularCooldown"
		local mainFrame = Instance.new("Frame")
		mainFrame.BackgroundTransparency = 1
		mainFrame.Visible = showOnCreation or DEFAULT_SHOW_ON_DEFAULT
		mainFrame.Size = UDim2.fromScale(1, 1)
		for i = 1, 0, -1 do
			local frame = Instance.new("Frame")
			frame.Name = tostring(i)
			frame.ClipsDescendants = true
			frame.BackgroundTransparency = 1
			frame.Position = UDim2.fromScale(i - 1, 0)
			frame.AnchorPoint = Vector2.new(i - 1, 0)
			frame.Visible = showOnCreation or DEFAULT_SHOW_ON_DEFAULT
			frame.Size = UDim2.fromScale(0.5, 1)
			local image = Instance.new("ImageLabel")
			image.Name = "Shade"
			image.BackgroundTransparency = 1
			image.Image = "rbxassetid://15478839340"
			image.ImageColor3 = color or DEFAULT_COLOR
			local _condition = transparency
			if not (_condition ~= 0 and _condition == _condition and _condition) then
				_condition = DEFAULT_TRANSPARENCY
			end
			image.ImageTransparency = _condition
			image.Size = UDim2.fromScale(2, 1)
			image.Position = IMAGE_POSITIONS[i + 1]
			local gradient = Instance.new("UIGradient")
			gradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(0.501, 1), NumberSequenceKeypoint.new(1, 1) })
			gradient.Rotation = 180 * (i - 1)
			gradient:SetAttribute("StartRotation", 180 * (i - 1))
			gradient:SetAttribute("EndRotation", 180 * (i - 1) + 180)
			gradient.Parent = image
			image.Parent = frame
			frame.Parent = mainFrame
		end
		mainFrame.Parent = folder
		folder.Parent = gui
		self.Frame = mainFrame
		self.RemainingCooldown = cd
		self.Cooldown = cd
		local _condition = rate
		if not (_condition ~= 0 and _condition == _condition and _condition) then
			_condition = 1
		end
		self.Rate = _condition
		self.ReplayWhileActive = playWhileActive or false
	end
	function CircularCooldown:Play()
		if self.ReplayWhileActive == false and self.RemainingCooldown > 0 and self.RemainingCooldown < self.Cooldown then
			return nil
		end
		-- #region
		-- First reset all frames and values.
		self.RemainingCooldown = self.Cooldown
		self.Frame.Visible = true
		for _, object in self.Frame:GetDescendants() do
			if object:IsA("Frame") == true then
				object.Visible = true
			elseif object:IsA("UIGradient") == true then
				object.Rotation = object:GetAttribute("StartRotation")
			end
		end
		-- #endregion
		-- #region
		-- Then play the cooldown.
		self.Frame.Visible = true
		self._CooldownObject.Value = self.RemainingCooldown
		if self._Tween ~= nil then
			self._Tween:Destroy()
		end
		self._Tween = TweenService:Create(self._CooldownObject, TweenInfo.new(self.RemainingCooldown / self.Rate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
			Value = 0,
		})
		self._Tween:Play()
		-- #endregion
		-- #region
		-- Then toggle the halves based on the remaining cooldown duration.
		for i = 0, 1 do
			local frame = self.Frame:FindFirstChild(tostring(i))
			if frame ~= nil then
				frame.Visible = false
			end
		end
		do
			local i = math.ceil(mathv.normalize(self._CooldownObject.Value, 0, self.Cooldown) * 1)
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i -= 1
				else
					_shouldIncrement = true
				end
				if not (i >= 1) then
					break
				end
				local frame = self.Frame:FindFirstChild(tostring(i))
				if frame ~= nil then
					frame.Visible = true
				end
			end
		end
		-- #endregion
		-- #region
		-- Then count down the cooldown.
		if self._Connection ~= nil then
			self._Connection:Disconnect()
		end
		self._Connection = self._CooldownObject.Changed:Connect(function()
			self.RemainingCooldown = self._CooldownObject.Value
			self._ChangeEvent:Fire(self._CooldownObject.Value)
			local index = math.clamp(math.ceil(mathv.normalize(self._CooldownObject.Value, 0, self.Cooldown) * 2), 1, 2)
			local _result = self.Frame:FindFirstChild(tostring(index))
			if _result ~= nil then
				_result = _result:FindFirstChild("Shade")
				if _result ~= nil then
					_result = _result:FindFirstChild("UIGradient")
				end
			end
			local gradient = _result
			gradient.Rotation = mathv.lerp(gradient:GetAttribute("EndRotation"), gradient:GetAttribute("StartRotation"), mathv.normalize(self._CooldownObject.Value, (self.Cooldown / 2) * (index - 1), (self.Cooldown / 2) * index))
			do
				local i = index + 1
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i <= 2) then
						break
					end
					local frame = self.Frame:FindFirstChild(tostring(i))
					if frame ~= nil then
						frame.Visible = false
					end
				end
			end
		end)
		-- #endregion
		-- #region
		-- Finally fire completion events and Destroy connections when complete.
		self._Tween.Completed:Connect(function()
			local one = self.Frame:FindFirstChild("1")
			local two = self.Frame:FindFirstChild("2")
			if one ~= nil then
				one.Visible = false
			end
			if two ~= nil then
				two.Visible = false
			end
			self._CompleteEvent:Fire()
			if self._Tween ~= nil then
				self._Tween:Destroy()
			end
			if self._Connection ~= nil then
				self._Connection:Disconnect()
			end
		end)
		-- #endregion
	end
	function CircularCooldown:Pause()
		if self._Tween ~= nil then
			self._Tween:Pause()
		end
	end
	function CircularCooldown:Cancel()
		if self._Tween ~= nil then
			self._Tween:Cancel()
			self.RemainingCooldown = self.Cooldown
		end
	end
end
return {
	CircularCooldown = CircularCooldown,
}
