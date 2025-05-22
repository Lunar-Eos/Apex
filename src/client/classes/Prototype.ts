import { dState } from "./State";
import { dCircularCooldown } from "./CircularCooldown";
import { dStateTable } from "./StateTable";
import { dTimer } from "./Timer";
import { dRadialCooldown } from "./RadialCooldown";
import { dPanel } from "./Panel";

export class Prototype {
	/**
	 * Returns an instance of any Apex class.
	 *
	 * **This should be the only method for instantiating.**
	 *
	 * ## Details
	 * @param {ClassNames} className
	 * The name of the class to instantiate from.
	 *
	 * @returns {Classes}
	 * The instance created based on `className`.
	 *
	 * ## Exceptions
	 * @throws Errors if `className` does not correspond to the name of an Apex class.
	 *
	 * ## Examples
	 * @example
	 * const instance = new Prototype("State");
	 */
	constructor(className: ClassNames) {
		switch (className) {
			case "State": {
				return new dState();
			}

			case "StateTable": {
				return new dStateTable();
			}

			case "Timer": {
				return new dTimer();
			}

			case "CircularCooldown": {
				return new dCircularCooldown();
			}

			case "RadialCooldown": {
				return new dRadialCooldown();
			}

			case "Panel": {
				return new dPanel();
			}

			default: {
				error("Attempt to create an instance of unknown class name or type.");
			}
		}
	}
}

type ClassNames = "State" | "StateTable" | "Timer" | "CircularCooldown" | "RadialCooldown" | "Panel";

export interface State {
	_Callbacks: { [name: string]: (old: unknown, next: unknown) => void };

	Value: unknown;

	ClassName: string;

	Get(): unknown;
	Set(a: unknown): void;
	Update(fn: (old: unknown) => unknown): void;
	BindOnChange(name: string, callback: (old: unknown, next: unknown) => void): void;
	UnbindOnChange(name: string): void;
	Destroy(): void;
}
export interface StateTable {
	_Callbacks: { [name: string]: (old: unknown, next: unknown) => void };

	Value: unknown;

	ClassName: string;

	Get(key: string): unknown;
	Set(key: string, a: unknown): void;
	Update(key: string, fn: (old: unknown) => unknown): void;
	BindOnChange(name: string, callback: (old: unknown, next: unknown) => void): void;
	UnbindOnChange(name: string): void;
	Destroy(): void;
}
export interface Timer {
	_CountThread: RBXScriptConnection | undefined;
	_ChangeFunction: () => void;
	_EndFunction: () => void;
	_InterruptFunction: () => void;

	_SecondsLeft: number;

	TimeScale: number;
	Seconds: number;

	ClassName: string;

	CompareTimes(object: Timer): (delta: number) => void;

	Start(): void;
	Resume(): void;
	Pause(): void;
	Stop(): void;
	GetRemaining(): number;
	BindToChanged(callback: () => void): void;
	BindToCompleted(callback: () => void): void;
	BindToInterrupted(callback: () => void): void;
	Destroy(): void;
}
export interface CircularCooldown {
	_CooldownObject: NumberValue;

	_CompleteEvent: BindableEvent;
	_ChangeEvent: BindableEvent;

	_Tween: Tween | undefined;

	Completed: RBXScriptSignal;
	Changed: RBXScriptSignal;

	Object: Folder;

	RemainingDuration: number;
	Duration: number;
	Rate: number;

	ClassName: string;

	SetParent(gui: GuiObject | undefined): void;
	Init(object: GuiObject | undefined): void;
	Play(): void;
	Resume(): void;
	Pause(): void;
	Cancel(): void;
	Destroy(): void;
}
export interface RadialCooldown {
	_CooldownObject: NumberValue;

	_CompleteEvent: BindableEvent;
	_ChangeEvent: BindableEvent;

	_Tween: Tween | undefined;

	Completed: RBXScriptSignal;
	Changed: RBXScriptSignal;

	Object: Folder;

	RemainingDuration: number;
	Duration: number;
	Rate: number;

	ClassName: string;

	SetParent(gui: GuiObject | undefined): void;
	Init(object: GuiObject | undefined): void;
	Play(): void;
	Resume(): void;
	Pause(): void;
	Cancel(): void;
	Destroy(): void;
}
export interface Panel {
	_Connections: Map<Instance, { [name: string]: RBXScriptConnection }>;
	_Callbacks: Map<Instance, { [name: string]: (...args: unknown[]) => void }>;
	_Instructions: { [name: string]: () => void };
	_Hooks: { [name: string]: (...args: unknown[]) => unknown[] };

	_Default: (() => void) | undefined;

	Parent: ScreenGui | undefined;

	SetParent(gui: ScreenGui): void;
	WriteInstruction(name: string, callback: () => void): void;
	DeleteInstruction(name: string): void;
	ClearInstructions(): void;
	Connect(instance: Instance, eventName: string, callback: (...args: unknown[]) => RBXScriptConnection): void;
	Disconnect(instance: Instance, eventName: string): void;
	Execute(): void;
	Default(callback: () => void): void;
	Hook(name: string, callback: (...args: unknown[]) => unknown[]): void;
	Unhook(name: string): void;
	Fire(name: string, ...args: unknown[]): void;
}
