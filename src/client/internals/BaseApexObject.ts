import Object from "@rbxts/object-utils";

import { CircularCooldown } from "../classes/CircularCooldown";
import { Spritesheet } from "../classes/Spritesheet";
import { dState } from "../classes/State";
import { StateTable } from "../classes/StateTable";
import { Timer } from "../classes/Timer";

export class BaseApexObject {
	readonly ClassName: string;

	constructor(className: string) {
		switch (className) {
			case "State": {
				const object: dState = new dState();
				this.ClassName = "Test";

				return Object.assign(this, object) as State;
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

	Get: () => unknown;
	Set: (next: unknown) => undefined;
	Update: (fn: (old: unknown) => unknown) => undefined;
	BindOnChange: (name: string, callback: (old: unknown, next: unknown) => undefined) => undefined;
	UnbindOnChange: (name: string) => undefined;

	Destroy: () => undefined;
}
