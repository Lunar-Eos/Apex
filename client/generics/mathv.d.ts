interface mathv {
	eulers: number;
	phi: number;
	tau: number;

	isnan: (a: number) => boolean;
	numtype: (a: number) => "float" | "integer";
	dpround: (n: number, d: number) => number;
	sfround: (n: number, sf: number) => number;
	ceil: (n: number, dp: number) => number;
	floor: (n: number, dp: number) => number;
	swap: (a: number, b: number) => LuaTuple<[number, number]>;
	lerp: (a: number, b: number, t: number) => number;
	normalize: (x: number, min: number, max: number) => number;
	circclamp: (x: number, min: number, max: number) => number;
	lcm: (a: number, b: number) => number;
	hcf: (a: number, b: number) => number;
	factorial: (a: number) => number;
	factors: (a: number) => { result: number };
	fibonaccinum: (n: number) => number;
	rootnum: (n: number) => number;
	ctok: (n: number) => number;
	ctof: (n: number) => number;
	ftoc: (n: number) => number;
	ftok: (n: number) => number;
	ktoc: (n: number) => number;
	ktof: (n: number) => number;
	mulseq: (a: number, b: number) => number;
	addseq: (a: number, b: number) => number;
	ncr: (n: number, r: number) => number;
	npr: (n: number, r: number) => number;
	vertex: (a: number, b: number, c: number) => LuaTuple<[number, number]>;
}

declare const mathv: mathv;

export = mathv;
