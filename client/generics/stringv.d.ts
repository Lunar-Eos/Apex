interface stringv {
	escapestring: (s: string) => string;
	escapestringpattern: (s: string) => string;
	splitpattern: (s: string, ...patterns: [string]) => { split: string } | object;
	startswith: (s: string, prefix: string) => boolean;
	endswith: (s: string, suffix: string) => boolean;
	capitalize: (s: string, forceFind: boolean | undefined) => string;
	camelcase: (s: string) => string;
	kebabcase: (s: string) => string;
	snakecase: (s: string) => string;
	titlecase: (s: string) => string;
	pad: (s: string, len: number, direction: "Start" | "End" | "Both", sub: string | undefined) => string;
	trim: (s: string) => string;
	removestart: (s: string, n: number) => string;
	removeend: (s: string, n: number) => string;
	commanumber: (s: string | number) => string;
	numsuffix: (n: number) => string;
	numroman: (n: number) => string;
	numbinsuffix: (n: number, nd: number | undefined) => string;
	numpercent: (n: number, nd: number | undefined) => string;
}

declare const stringv: stringv;

export = stringv;
