interface world {
	raycastBetweenVectors: (
		v1: Vector3,
		v2: Vector3,
		raycastParams: RaycastParams | undefined,
		displayRay: boolean | undefined,
	) => RaycastResult | undefined;
	raycastAtDirection: (
		origin: Vector3,
		dir: Vector3,
		raycastParams: RaycastParams | undefined,
		displayRay: boolean | undefined,
	) => RaycastResult | undefined;
}

declare const world: world;

export = world;
