export class dStateTable {
	_Callbacks: { [name: string]: (old: unknown, next: unknown) => undefined } = {};

	Value: { [name: string]: unknown } = {};

	constructor() {}

	Get(key: string) {
		return this.Value[key];
	}

	Set(key: string, a: unknown) {
		if (a === this.Value[key]) return;

		const prev = this.Value[key];
		this.Value[key] = a;

		for (const [_, callback] of pairs(this._Callbacks)) {
			callback(prev, this.Value[key]);
		}
	}

	Update(key: string, fn: (old: unknown) => unknown) {
		const prev = this.Value[key];
		this.Value[key] = fn(this.Value[key]);

		for (const [_, callback] of pairs(this._Callbacks)) {
			callback(prev, this.Value[key]);
		}
	}

	BindOnChange(name: string, callback: (old: unknown, next: unknown) => undefined) {
		this._Callbacks[name] = callback;
	}

	UnbindOnChange(name: string) {
		delete this._Callbacks[name];
	}
}
