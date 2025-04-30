import { dState } from "./State";
import { dCircularCooldown } from "./CircularCooldown";
import { dStateTable } from "./StateTable";
import { dTimer } from "./Timer";
import { dRadialCooldown } from "./RadialCooldown";

export class Prototype {
	constructor(className: ClassNames) {
		switch (className) {
			case "State": {
				return new dState();
			}

			case "StateTable": {
				return new dStateTable();
			}

			case "CircularCooldown": {
				return new dCircularCooldown();
			}

			case "RadialCooldown": {
				return new dRadialCooldown();
			}

			case "Timer": {
				return new dTimer();
			}

			default: {
				error("Attempt to create an instance of unknown class name or type.");
			}
		}
	}
}

type ClassNames = "State" | "StateTable" | "Timer" | "CircularCooldown" | "RadialCooldown";

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

	Init(object: GuiObject | undefined): void;
	Play(): void;
	Resume(): void;
	Pause(): void;
	Cancel(): void;
	Destroy(): void;
}
