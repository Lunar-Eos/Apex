interface runservice {
	bindToStepped: (name: string, fn: (t: number, delta: number) => undefined) => undefined;
	bindToHeartbeat: (name: string, fn: (t: number, delta: number) => undefined) => undefined;
	bindToPreAnimation: (name: string, fn: (t: number, delta: number) => undefined) => undefined;
	bindToPreRender: (name: string, fn: (t: number, delta: number) => undefined) => undefined;
	bindToPreSimulation: (name: string, fn: (t: number, delta: number) => undefined) => undefined;
	bindToPostSimulation: (name: string, fn: (t: number, delta: number) => undefined) => undefined;
	unbindFromStepped: (name: string) => undefined;
	unbindFromHeartbeat: (name: string) => undefined;
	unbindFromPreAnimation: (name: string) => undefined;
	unbindFromPreRender: (name: string) => undefined;
	unbindFromPreSimulation: (name: string) => undefined;
	unbindFromPostSimulation: (name: string) => undefined;
}

declare const runservice: runservice;

export = runservice;
