interface statistics {
	mean: (t: number[]) => number;
	median: (t: number[]) => number;
	mode: (t: number[]) => number;
	range: (t: number[]) => number;
	lowest: (t: number[]) => number;
	highest: (t: number[]) => number;
	stdev: (t: number[], popn: boolean | undefined) => number;
	zscore: (t: number[], popn: boolean | undefined) => number;
	mad: (t: number[]) => number;
	quartiles: (t: number[]) => LuaTuple<[number, number, number]>;
	iqrt: (t: number[]) => number;
	iqr: (q1: number, q3: number) => number;
	linreg: (...points: [number, number]) => LuaTuple<[number, number, number]>;
	linregnext: (x: number, slope: number, yint: number) => number;
}

declare const statistics: statistics;

export = statistics;
