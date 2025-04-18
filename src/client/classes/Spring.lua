--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants
local ITERATIONS = 8


-- Variables


-- Functions


-- Types


-- Module
local Spring = {}
Spring.__index = Spring


export type Spring = typeof(setmetatable({} :: {
	Target: Vector3,
	Position: Vector3,
	Velocity: Vector3,

	Mass: number,
	Force: number,
	Damping: number,
	Speed: number,
}, Spring))


--[[ Functions: 

	Spring.new(mass, force, damping, speed)
	Spring:Shove(force)
	Spring:Update(delta)
	
]]


--[[ Spring.new(mass, force, damping, speed)
	PARAMETERS: 
	- <number?> mass: The "resistance" of the spring. Defaults to 5.
	- <number?> force: How easily affected by shoves the spring is. Defaults to 50.
	- <number?> damping: How much the spring will return to its resting position. Defaults to 4.
	- <number?> speed: How fast the spring will return to its resting position. Defaults to 4.

	RETURNS:
	- <Spring> spring: The resulting Spring object.

	CONSTRUCTOR - Instantiates a new Spring object that allows you to create spring motions easily. ]] 
function Spring.new(mass: number?, force: number?, damping: number?, speed: number?): Spring
	return setmetatable({
		Target = Vector3.new(),
		Position = Vector3.new(),
		Velocity = Vector3.new(),

		Mass = mass or 5,
		Force = force or 50,
		Damping	= damping or 4,
		Speed = speed or 4,
	}, Spring)
end


--[[ Spring:Shove(force)
	PARAMETERS:
	- <Vector3> force: The magnitude and direction to force the spring towards.

	RETURNS:
	- nil.

	Applies a force to the given spring. ]] 
function Spring:Shove(force: Vector3)
	local self: Spring = self
	
	local x, y, z = force.X, force.Y, force.Z
	
	if x ~= x or x == math.huge or x == -math.huge then x = 0 end
	if y ~= y or y == math.huge or y == -math.huge then y = 0 end
	if z ~= z or z == math.huge or z == -math.huge then z = 0 end
	
	self.Velocity += Vector3.new(x, y, z)
end


--[[ Spring:Update(delta)
	PARAMETERS:
	- <number> delta: The delta time. Typically used for when a spring would be updated via RunService events.

	RETURNS:
	- <Vector3> pos: The ending position based on the given time elapsed.

	FOOTNOTES:
	- Calling this on a RunService event, such as RenderStepped, is highly recommended.

	Updates the given spring over time. ]] 
function Spring:Update(delta: number)
	local self: Spring = self
	
	local scaledDeltaTime = delta * self.Speed / ITERATIONS
	
	for i = 1, ITERATIONS do
		local iterationForce = self.Target - self.Position
		local acceleration = (iterationForce * self.Force) / self.Mass

		acceleration -= self.Velocity * self.Damping

		self.Velocity += acceleration * scaledDeltaTime
		self.Position += self.Velocity * scaledDeltaTime
	end

	return self.Position
end


return Spring