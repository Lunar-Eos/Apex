interface physics {
	g: number;
	gearth: number;

	maxheight: (magnitude: number, direction: number, g: number | undefined) => number;
	traveltime: (magnitude: number, direction: number, g: number | undefined) => number;
	traveldistance: (magnitude: number, direction: number, g: number | undefined) => number;
}

declare const physics: physics;

export = physics;
