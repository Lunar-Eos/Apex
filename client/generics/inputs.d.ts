interface inputs {
	getMousePosition: () => undefined;
	getPlatform: () => undefined;
	isNumberKey: (input: InputObject) => boolean;
}

declare const inputs: inputs;

export = inputs;
