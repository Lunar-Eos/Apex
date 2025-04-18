--!strict


-- Services
local _HTTPSERVICE = game:GetService("HttpService")


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local security = {}


--[[ Functions: 

	security.generateRandomID()
 
]]


--[[ security.generateRandomID()
	PARAMETERS: 
	- nil.

	RETURNS:
	- <string> ID: The randomly generated ID.

	Returns a random ID. Useful for differentiating items. ]] 
function security.generateRandomID(): string
	return `{_HTTPSERVICE:GenerateGUID(false)}_{string.split(tostring(tick()), ".")[2]}`
end


return security