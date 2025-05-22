import instance from "../generics/instance";
import { BaseApexObject } from "../internals/BaseApexObject";

type CallbackTable = { [name: string]: (...args: unknown[]) => void };
type ConnectionTable = { [name: string]: RBXScriptConnection };

export class dPanel extends BaseApexObject {
	_Connections: Map<Instance, ConnectionTable> = new Map<Instance, ConnectionTable>();
	_Callbacks: Map<Instance, CallbackTable> = new Map<Instance, CallbackTable>();
	_Instructions: { [name: string]: () => void } = {};
	_Hooks: { [name: string]: (...args: unknown[]) => unknown[] } = {};

	_Default: (() => void) | undefined = undefined;

	Parent: ScreenGui | undefined = undefined;

	constructor() {
		super("Panel");
	}

	SetParent(gui: ScreenGui) {
		const old = this.Parent;

		this.Parent = gui;
	}

	WriteInstruction(name: string, callback: () => void) {
		if (this._Instructions[name] !== undefined) {
			warn(`Panel - Overwritten instruction of name ${name}.`);
		}

		this._Instructions[name] = callback;
	}

	DeleteInstruction(name: string) {
		delete this._Instructions[name];
	}

	ClearInstructions() {
		for (const [k] of pairs(this._Instructions)) {
			delete this._Instructions[k];
		}
	}

	Connect(instance: Instance, eventName: string, callback: (...args: unknown[]) => RBXScriptConnection) {
		// Table of connections and callbacks could be Null for new instances - initialize one first.
		if (this._Callbacks.get(instance) === undefined) {
			this._Callbacks.set(instance, {});
		}

		// Is eventName a valid event for provided instance?
		assert(
			typeOf(instance[eventName as never]) === "RBXScriptSignal",
			"Panel - Attempt to access a non-event for the provided instance.",
		);

		(this._Callbacks.get(instance) as CallbackTable)[eventName] = callback;

		this._Callbacks.set(instance, this._Callbacks.get(instance) as CallbackTable);
	}

	Disconnect(instance: Instance, eventName: string) {
		const connectionTable = this._Connections.get(instance) as ConnectionTable;

		connectionTable[eventName].Disconnect();
		delete connectionTable[eventName];
	}

	Execute() {
		const clearConnections = () => {
			for (const [_, events] of pairs(this._Connections)) {
				for (const [_, connection] of pairs(events)) {
					connection.Disconnect();
				}
			}
		};
		const addConnections = () => {
			for (const [instance, events] of pairs(this._Callbacks)) {
				for (const [eventName, callback] of pairs(events)) {
					if (this._Connections.get(instance) === undefined) {
						this._Connections.set(instance, {});
					}

					(this._Connections.get(instance) as ConnectionTable)[eventName] = (
						instance[eventName as never] as RBXScriptSignal
					).Connect(callback);
				}
			}
		};
		const runInstructions = () => {
			for (const [_, instruction] of pairs(this._Instructions)) {
				instruction();
			}
		};
		const execute = () => {
			if (this._Default !== undefined) {
				this._Default();
			}

			if (this.Parent?.Enabled === true) {
				clearConnections();
				addConnections();
				runInstructions();
			} else {
				clearConnections();
			}
		};

		execute();
		this.Parent?.GetPropertyChangedSignal("Enabled").Connect(execute);
	}

	Default(callback: () => void) {
		this._Default = callback;
	}

	Hook(name: string, callback: (...args: unknown[]) => unknown[]) {
		this._Hooks[name] = callback;
	}

	Unhook(name: string) {
		delete this._Hooks[name];
	}

	Fire(name: string, ...args: unknown[]) {
		this._Hooks[name](...args);
	}
}
