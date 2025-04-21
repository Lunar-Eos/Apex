import { BaseApexObject } from "../internals/BaseApexObject";

export class State<T> extends BaseApexObject {
	private _Callbacks: { [name: string]: (old: T, next: T) => undefined } = {};

	protected Value: T;

	constructor(val: T) {
		super("State");

		this.Value = val;
	}

	private fireCallbacks(a: T, b: T) {
		for (const [_, callback] of pairs(this._Callbacks)) {
			callback(a, b);
		}
	}

	Get() {
		return this.Value;
	}

	Set(a: T) {
		if (a === this.Value) return;

		const prev = this.Value;
		this.Value = a;

		this.fireCallbacks(prev, this.Value);
	}

	Update(fn: (old: T) => T) {
		const prev = this.Value;
		this.Value = fn(this.Value);

		this.fireCallbacks(prev, this.Value);
	}

	BindOnChange(name: string, callback: (old: T, next: T) => undefined) {
		this._Callbacks[name] = callback;
	}

	UnbindOnChange(name: string) {
		delete this._Callbacks[name];
	}
}
