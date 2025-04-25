export class dState {
	_Callbacks: { [name: string]: (old: unknown, next: unknown) => undefined } = {};

	Value: unknown = 0;

	constructor() {}

	Test(this: void) {
		print("yes");
	}

	Get(this: dState) {
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

	BindOnChange(name: string, callback: (old: unknown, next: unknown) => undefined) {
		this._Callbacks[name] = callback;
	}

	UnbindOnChange(name: string) {
		delete this._Callbacks[name];
	}
}
