-- Compiled with roblox-ts v3.0.0
local BaseApexObject
do
	BaseApexObject = {}
	function BaseApexObject:constructor()
		self.ClassName = ""
	end
	function BaseApexObject:Destroy()
		for k, v in pairs(self) do
			local _arg0 = self[k]
			local t = typeof(_arg0)
			if t == "RBXScriptConnection" then
				v:Disconnect()
			elseif t == "Instance" then
				v:Destroy()
			end
			self[k] = nil
		end
	end
end
return {
	BaseApexObject = BaseApexObject,
}
