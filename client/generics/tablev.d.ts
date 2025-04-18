type Table<T1, T2> = Array<T1> | Map<string, T2>;
type Predicate<T> = (a: T) => boolean;

interface tablev {
	len: (t: Table<unknown, unknown>) => number;
	tabletype: (t: Table<unknown, unknown>) => "Empty" | "Array" | "Dictionary" | "Mixed";
	shuffle: (t: Array<unknown>) => unknown[];
	swap: (t: Array<unknown>, a: number, b: number) => undefined;
	fill: (t: Array<unknown>, val: unknown) => undefined;
	insert: (t: Array<unknown>, val: unknown, p: number) => undefined;
	remove: (t: Array<unknown>, predicate: Predicate<unknown>) => undefined;
	removeall: (t: Array<unknown>, predicate: Predicate<unknown>) => undefined;
	first: (t: Array<unknown>, predicate: Predicate<unknown>) => unknown;
	firstindex: (t: Array<unknown>, predicate: Predicate<unknown>) => unknown;
	last: (t: Array<unknown>, predicate: Predicate<unknown>) => unknown;
	lastindex: (t: Array<unknown>, predicate: Predicate<unknown>) => unknown;
	reorganize: (t: Array<unknown>) => undefined;
	deepcopy: (t: Array<unknown>) => undefined;
	deepfreeze: (t: Array<unknown>) => undefined;
	safefreeze: (t: Array<unknown>) => undefined;
	reverse: (t: Array<unknown>) => undefined;
	split: (t: Table<unknown, unknown>, x: number) => LuaTuple<[Table<unknown, unknown>, Table<unknown, unknown>]>;
	binsearch: (t: Array<number>, v: number) => number | undefined;
	same: (a: Table<unknown, unknown>, b: Table<unknown, unknown>) => boolean;
}

declare const tablev: tablev;

export = tablev;
