-- Compiled with roblox-ts v3.0.0
local dTest
do
	dTest = setmetatable({}, {
		__tostring = function()
			return "dTest"
		end,
	})
	dTest.__index = dTest
	function dTest.new(...)
		local self = setmetatable({}, dTest)
		return self:constructor(...) or self
	end
	function dTest:constructor()
		self.Value = 0
	end
	function dTest:Get()
		return self.Value
	end
end
return {
	dTest = dTest,
}
