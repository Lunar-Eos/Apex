import { BaseApexObject } from "../internals/BaseApexObject";

export class dState extends BaseApexObject {
	_Callbacks: { [name: string]: (old: unknown, next: unknown) => void } = {};

	Value: unknown = 0;

	constructor() {
		super("State");
	}

	Get() {
		return this.Value;
	}

	Set(a: unknown) {
		if (a === this.Value) return;

		const prev = this.Value;
		this.Value = a;

		for (const [_, callback] of pairs(this._Callbacks)) {
			callback(prev, this.Value);
		}
	}

	Update(fn: (old: unknown) => unknown) {
		const prev = this.Value;
		this.Value = fn(this.Value);

		for (const [_, callback] of pairs(this._Callbacks)) {
			callback(prev, this.Value);
		}
	}

	BindOnChange(name: string, callback: (old: unknown, next: unknown) => void) {
		this._Callbacks[name] = callback;
	}

	UnbindOnChange(name: string) {
		delete this._Callbacks[name];
	}
}
