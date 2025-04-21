export class BaseApexObject {
	readonly ClassName: string;

	constructor(className: string) {
		this.ClassName = className;
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
