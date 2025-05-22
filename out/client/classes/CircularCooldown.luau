-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local TweenService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService
local BaseApexObject = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "internals", "BaseApexObject").BaseApexObject
local mathv = TS.import(script, game:GetService("ReplicatedStorage"), "Imports", "generics", "mathv")
local TRANSPARENCY_SEQUENCE = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(0.501, 1), NumberSequenceKeypoint.new(1, 1) })
local function playCooldown(obj)
	if obj._Tween ~= nil then
		obj._Tween:Destroy()
	end
	obj._Tween = TweenService:Create(obj._CooldownObject, TweenInfo.new(obj.RemainingDuration / obj.Rate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
		Value = 0,
	})
	obj._Tween:Play()
	obj._Tween.Completed:Connect(function()
		obj._CompleteEvent:Fire()
		if obj._Tween ~= nil then
			obj._Tween:Destroy()
		end
	end)
end
local dCircularCooldown
do
	local super = BaseApexObject
	dCircularCooldown = setmetatable({}, {
		__tostring = function()
			return "dCircularCooldown"
		end,
		__index = super,
	})
	dCircularCooldown.__index = dCircularCooldown
	function dCircularCooldown.new(...)
		local self = setmetatable({}, dCircularCooldown)
		return self:constructor(...) or self
	end
	function dCircularCooldown:constructor()
		super.constructor(self, "CircularCooldown")
		self._CooldownObject = Instance.new("NumberValue")
		self._CompleteEvent = Instance.new("BindableEvent")
		self._ChangeEvent = Instance.new("BindableEvent")
		self._Tween = nil
		self.Completed = self._CompleteEvent.Event
		self.Changed = self._ChangeEvent.Event
		self.RemainingDuration = 1
		self.Duration = 1
		self.Rate = 1
		local folder = Instance.new("Folder")
		folder.Name = "CircularCooldown"
		folder:SetAttribute("Color", Color3.new(1, 1, 1))
		folder:SetAttribute("Transparency", 0)
		folder:SetAttribute("Visible", true)
		folder:SetAttribute("ZIndex", 1)
		folder:GetAttributeChangedSignal("Color"):Connect(function()
			local val = folder:GetAttribute("Color");
			(folder:FindFirstChild("Left")).ImageColor3 = val;
			(folder:FindFirstChild("Right")).ImageColor3 = val
		end)
		folder:GetAttributeChangedSignal("Transparency"):Connect(function()
			local val = folder:GetAttribute("Transparency");
			(folder:FindFirstChild("Left")).ImageTransparency = val;
			(folder:FindFirstChild("Right")).ImageTransparency = val
		end)
		folder:GetAttributeChangedSignal("Visible"):Connect(function()
			local val = folder:GetAttribute("Visible");
			(folder:FindFirstChild("Left")).Visible = val;
			(folder:FindFirstChild("Right")).Visible = val
		end)
		folder:GetAttributeChangedSignal("ZIndex"):Connect(function()
			local val = folder:GetAttribute("ZIndex");
			(folder:FindFirstChild("Left")).ZIndex = val;
			(folder:FindFirstChild("Right")).ZIndex = val
		end)
		-- #region Create the semicircle images.
		local left = Instance.new("ImageLabel")
		left.BackgroundTransparency = 1
		left.AnchorPoint = Vector2.new(0, 0.5)
		left.Position = UDim2.new(0, 0, 0.5, 0)
		left.Size = UDim2.new(0.5, 0, 1, 0)
		left.Image = "rbxassetid://134149598090509"
		left.ClipsDescendants = true
		local right = Instance.new("ImageLabel")
		right.BackgroundTransparency = 1
		right.AnchorPoint = Vector2.new(1, 0.5)
		right.Position = UDim2.new(1, 0, 0.5, 0)
		right.Size = UDim2.new(0.5, 0, 1, 0)
		right.Image = "rbxassetid://132382211808404"
		right.ClipsDescendants = true
		-- #endregion
		-- #region Create the gradients.
		local leftGradient = Instance.new("UIGradient")
		leftGradient.Transparency = TRANSPARENCY_SEQUENCE
		leftGradient.Offset = Vector2.new(0.5, 0)
		leftGradient.Rotation = 0
		local rightGradient = Instance.new("UIGradient")
		rightGradient.Transparency = TRANSPARENCY_SEQUENCE
		rightGradient.Offset = Vector2.new(-0.5, 0)
		rightGradient.Rotation = -180
		-- #endregion
		-- #region Parent all instances to the folder.
		leftGradient.Parent = left
		rightGradient.Parent = right
		left.Parent = folder
		right.Parent = folder
		-- #endregion
		-- #region Connect changed event to the internal countdown object.
		self._CooldownObject.Changed:Connect(function()
			self._ChangeEvent:Fire()
			self.RemainingDuration = self._CooldownObject.Value
			if self.RemainingDuration > self.Duration / 2 then
				leftGradient.Rotation = 0
				local norm = mathv.normalize(self.RemainingDuration, self.Duration / 2, self.Duration)
				local rotation = mathv.lerp(0, -180, norm)
				rightGradient.Rotation = rotation
			else
				rightGradient.Rotation = 0
				local norm = mathv.normalize(self.RemainingDuration, 0, self.Duration / 2)
				local rotation = mathv.lerp(180, 0, norm)
				leftGradient.Rotation = rotation
			end
		end)
		-- #endregion
		self.Object = folder
	end
	function dCircularCooldown:SetParent(object)
		self.Object.Parent = object
	end
	function dCircularCooldown:Play()
		self.RemainingDuration = self.Duration
		self.Object:SetAttribute("Visible", true)
		self._CooldownObject.Value = self.RemainingDuration
		playCooldown(self)
	end
	function dCircularCooldown:Resume()
		self.Object:SetAttribute("Visible", true)
		self._CooldownObject.Value = self.RemainingDuration
		playCooldown(self)
	end
	function dCircularCooldown:Pause()
		if self._Tween == nil then
			return nil
		end
		self._Tween:Pause()
	end
	function dCircularCooldown:Cancel()
		if self._Tween == nil then
			return nil
		end
		self._Tween:Cancel()
		self.RemainingDuration = self.Duration
	end
end
return {
	dCircularCooldown = dCircularCooldown,
}
