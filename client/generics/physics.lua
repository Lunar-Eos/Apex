--!native
--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local physics = {
	g = 6.674e-11,
	gearth = 9.80665,
}


--[[ Functions: 

	physics.maxheight(magnitude, direction, g)
	physics.traveltime(magnitude, direction, g)
	physics.traveldistance(magnitude, direction, g)
	
]]


--[[ physics.maxheight(magnitude, direction, g)
	PARAMETERS: 
	- <number> magnitude: The strength of the force, otherwise known as velocity.
	- <number> direction: The angle of launch, in radians.
	- <number?> g: The strength of the gravitational pull. If not provided, it will default to physics.gearth.

	RETURNS:
	- <number> x: The maximum height of a projectile given its launch properties, velocity, direction, and gravitational pull.

	Returns the maximum height of a projectile given its launch velocity, direction, and gravitational pull, in meters. ]] 
function physics.maxheight(magnitude: number, direction: number, g: number?): number
	return (magnitude * math.sin(direction))^2 / (2 * (g or physics.gearth))
end


--[[ physics.traveltime(magnitude, direction, g)
	PARAMETERS: 
	- <number> magnitude: The strength of the force, otherwise known as velocity.
	- <number> direction: The angle of launch, in radians.
	- <number?> g: The strength of the gravitational pull. If not provided, it will default to physics.gearth.

	RETURNS:
	- <number> x: The maximum travel time of a projectile given its launch properties, velocity, direction, and gravitational pull.

	Returns the maximum travel time of a projectile given its launch velocity, direction, and gravitational pull, in seconds. ]] 
function physics.traveltime(magnitude: number, direction: number, g: number?): number
	return (2 * magnitude * math.sin(direction)) / (g or physics.gearth)
end


--[[ physics.traveldistance(magnitude, direction, g)
	PARAMETERS: 
	- <number> magnitude: The strength of the force, otherwise known as velocity.
	- <number> direction: The angle of launch, in radians.
	- <number?> g: The strength of the gravitational pull. If not provided, it will default to physics.gearth.

	RETURNS:
	- <number> x: The maximum travel distance of a projectile given its launch properties, velocity, direction, and gravitational pull.

	Returns the maximum travel distance of a projectile given its launch velocity, direction, and gravitational pull, in meters. ]] 
function physics.traveldistance(magnitude: number, direction: number, g: number?): number
	return (magnitude ^ 2 * math.sin(2 * direction)) / (g or physics.gearth)
end


return physics