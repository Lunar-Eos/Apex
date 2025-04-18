--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local world = {}


--[[ Functions: 

	world.raycastBetweenVectors(v1, v2, raycastParams, displayRay)
	world.raycastAtDirection(origin, dir, raycastParams, displayRay)
 
]]


--[[ world.raycastBetweenVectors(v1, v2, raycastParams, displayRay)
	PARAMETERS:
	- <Vector3> v1: The Vector3 to start the ray from.
	- <Vector3> v2: The Vector3 to end the ray on.
	- <RaycastParams?> raycastParams: The parameters to set for the raycast.
	- <boolean?> displayRay: Whether to display the ray using a part or not. Can be nil, in which case the ray will never be displayed.

	RETURNS:
	- <RaycastResult?> r: The resulting ray. Returns nil if no ray was created.

	Creates a new ray spanning between 2 Vector3s. Can optionally display the ray for debugging. ]] 
function world.raycastBetweenVectors(v1: Vector3, v2: Vector3, raycastParams: RaycastParams?, displayRay: boolean?): RaycastResult?
	local cf = CFrame.lookAt(v1, v2)
	local ray = workspace:Raycast(v1, cf.LookVector * 50, raycastParams)
	if ray == nil then return nil end
	
	if displayRay == true then
		local distance = (v1 - ray.Position).Magnitude
		
		local part = Instance.new("Part")
		part.Name = "RaycastDisplayPart"
		part.Anchored = true
		part.CanCollide = false
		part.Size = Vector3.new(0.1, 0.1, distance)
		part.CFrame = CFrame.lookAt(v1, ray.Position) * CFrame.new(0, 0, -distance/2)
		part.Color = Color3.fromRGB(255, 0, 0)
		part.Parent = workspace

		if raycastParams ~= nil then table.insert(raycastParams.FilterDescendantsInstances, part) end
	end
	
	return ray
end	


--[[ world.raycastAtDirection(origin, dir, raycastParams, displayRay)
	PARAMETERS:
	- <Vector3> origin: The Vector3 to start the ray from.
	- <Vector3> dir: The Vector3 to end the ray on.
	- <RaycastParams?> raycastParams: The parameters to set for the raycast.
	- <boolean?> displayRay: Whether to display the ray using a part or not. Can be nil, in which case the ray will never be displayed.

	RETURNS:
	- <RaycastResult?> r: The resulting ray. Returns nil if no ray was created.

	Creates a new ray spanning between 2 Vector3s. Can optionally display the ray for debugging. ]] 
function world.raycastAtDirection(origin: Vector3, dir: Vector3, raycastParams: RaycastParams?, displayRay: boolean?): RaycastResult?
	local ray = workspace:Raycast(origin, dir, raycastParams)
	if ray == nil then return nil end

	if displayRay == true then
		local distance = (origin - ray.Position).Magnitude

		local part = Instance.new("Part")
		part.Name = "RaycastDisplayPart"
		part.Anchored = true
		part.CanCollide = false
		part.Size = Vector3.new(0.1, 0.1, distance)
		part.CFrame = CFrame.lookAt(origin, ray.Position) * CFrame.new(0, 0, -distance/2)
		part.Color = Color3.fromRGB(255, 0, 0)
		part.Parent = workspace
		
		if raycastParams ~= nil and raycastParams.FilterType == Enum.RaycastFilterType.Exclude then table.insert(raycastParams.FilterDescendantsInstances, part) end
	end

	return ray
end	


return world