import Object from "@rbxts/object-utils";

import { CircularCooldown } from "../classes/CircularCooldown";
import { Spritesheet } from "../classes/Spritesheet";
import { dState } from "../classes/State";
import { dStateTable } from "../classes/StateTable";
import { Timer } from "../classes/Timer";
import { dTest } from "../classes/Test";

export class BaseApexObject {
	readonly ClassName: string;

	constructor(className: string) {
		switch (className) {
			case "State": {
				const object = new dState();

				this.ClassName = "State";

				return Object.assign(this, object) as State;
			}

			case "StateTable": {
				const object = new dStateTable();

				this.ClassName = "StateTable";

				return Object.assign(this, object) as StateTable;
			}

			case "Test": {
				const object = new dTest();
				print(Object.assign(this, object));

				this.ClassName = "Test";

				return Object.assign(this, object) as Test;
			}

			default: {
				this.ClassName = "BaseApexObject";
				error("Attempt to create an instance of unknown class name or type.");
			}
		}
	}

	Destroy() {
		for (const [k, v] of pairs(this)) {
			const t = typeOf(this[k as keyof this]);

			if (t === "RBXScriptConnection") (v as RBXScriptConnection).Disconnect();
			else if (t === "Instance") (v as Instance).Destroy();

			delete this[k as keyof this];
		}
	}
}

export interface State {
	ClassName: string;

	_Callbacks: { [name: string]: (old: unknown, next: unknown) => undefined };

	Value: unknown;

	Get(): unknown;
	Set(next: unknown): void;
	Update(fn: (old: unknown) => unknown): void;
	BindOnChange(name: string, callback: (old: unknown, next: unknown) => void): void;
	UnbindOnChange(name: string): void;

	Destroy(): undefined;
}

export interface StateTable {
	ClassName: string;

	_Callbacks: { [name: string]: (old: unknown, next: unknown) => undefined };

	Value: unknown;

	Get(key: string): unknown;
	Set(key: string, next: unknown): void;
	Update(key: string, fn: (old: unknown) => unknown): void;
	BindOnChange(name: string, callback: (old: unknown, next: unknown) => void): void;
	UnbindOnChange(name: string): void;

	Destroy(): undefined;
}

export interface Test {
	ClassName: string;

	Value: unknown;

	Get(): unknown;

	Destroy(): undefined;
}

/* TODO:
	- fix methods not being cloned into instances
	- remove all test classes and interfaces
*/
