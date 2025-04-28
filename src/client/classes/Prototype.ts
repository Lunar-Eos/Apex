import { BaseApexObject } from "../internals/BaseApexObject";
import { State } from "../classes/State";

export class Prototype extends BaseApexObject {
	constructor(className: string) {
		super();

		switch (className) {
			case "State": {
				this.ClassName = "State";

				return new State();
			}

			default: {
				this.ClassName = "BaseApexObject";
				error("Attempt to create an instance of unknown class name or type.");
			}
		}
	}
}
