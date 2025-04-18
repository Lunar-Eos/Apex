--!strict


-- Services


-- Libraries


-- Upvalues


-- Constants


-- Variables


-- Functions


-- Module
local constraints = {}


--[[ Functions: 

	constraints.initializeModel(model, collisionGroup)
	constraints.attachByMotor6D(inst1, inst2, cf)
	constraints.attachByWeld(inst1, inst2)
 
]]


--[[ constraints.initializeModel(model, collisionGroup)
	PARAMETERS: 
	- <Model> model: The model to initialize for character constraining.
	- <string?> collisionGroup: The collision group. Should be set to a character's collision group if any. Defaults to "Default".

	RETURNS:
	- nil.

	Initializes a given model such that it can be constrained to a character model properly. ]] 
function constraints.initializeModel(model: Model, collisionGroup: string?)
	for _, v in model:GetDescendants() do
		if v:IsA("BasePart") == true then
			local p: BasePart = v :: BasePart

			p.Massless = true
			p.Anchored = false
			p.CanCollide = collisionGroup ~= nil
			p.CollisionGroup = collisionGroup or "Default"
		end
	end
end


--[[ constraints.attachByMotor6D(inst1, inst2, cf)
	PARAMETERS: 
	- <BasePart> inst1: The part to be bound to by Motor6D.
	- <BasePart> inst2: The part to bind to by Motor6D.
	- <CFrame> cf: The CFrame of the Motor6D.

	RETURNS:
	- <Motor6D> m6d: The generated Motor6D.

	Binds a given part to another using a Motor6D. ]] 
function constraints.attachByMotor6D(inst1: BasePart, inst2: BasePart, cf: CFrame): Motor6D
	local m6d = Instance.new("Motor6D")
	
	m6d.C0 = cf
	m6d.Part0 = inst1
	m6d.Part1 = inst2
	m6d.Parent = inst1
	
	return m6d
end


--[[ constraints.attachByWeld(inst1, inst2)
	PARAMETERS: 
	- <BasePart> inst1: The part to be bound to by weld.
	- <BasePart> inst2: The part to bind to by weld.

	RETURNS:
	- <WeldConstraint> weld: The generated weld.

	Binds a given part to another using a WeldConstraint. ]] 
function constraints.attachByWeld(inst1: BasePart, inst2: BasePart): WeldConstraint
	local weld = Instance.new("WeldConstraint")

	weld.Part0 = inst1
	weld.Part1 = inst2
	weld.Parent = inst1

	return weld
end


return constraints