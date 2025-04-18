interface constraints {
	initializeModel: (model: Model, collisionGroup: string) => undefined;
	attachByMotor6D: (inst1: BasePart, inst2: BasePart, cf: CFrame) => Motor6D;
	attachByWeld: (inst1: BasePart, inst2: BasePart) => WeldConstraint;
}

declare const constraints: constraints;

export = constraints;
