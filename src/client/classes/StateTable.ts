import { BaseApexObject } from "../internals/BaseApexObject";

export class StateTable<T> extends BaseApexObject {
	private _Callbacks: { [name: string]: (old: T, next: T) => undefined } = {};

	protected Value: { [name: string]: T };

	constructor(val: { [name: string]: T }) {
		super("StateTable");

		this.Value = val;
	}

	private fireCallbacks(a: T, b: T) {
		for (const [_, callback] of pairs(this._Callbacks)) {
			callback(a, b);
		}
	}

	Get(key: string) {
		return this.Value[key];
	}

	Set(key: string, a: T) {
		if (a === this.Value[key]) return;

		const prev = this.Value[key];
		this.Value[key] = a;

		this.fireCallbacks(prev, this.Value[key]);
	}

	Update(key: string, fn: (old: T) => T) {
		const prev = this.Value[key];
		this.Value[key] = fn(this.Value[key]);

		this.fireCallbacks(prev, this.Value[key]);
	}

	BindOnChange(name: string, callback: (old: T, next: T) => undefined) {
		this._Callbacks[name] = callback;
	}

	UnbindOnChange(name: string) {
		delete this._Callbacks[name];
	}
}
