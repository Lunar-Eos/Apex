import { dState } from "../classes/State";

export class Prototype {
	constructor(className: ClassNames) {
		switch (className) {
			case "State": {
				return new dState();
			}

			default: {
				error("Attempt to create an instance of unknown class name or type.");
			}
		}
	}
}

type ClassNames = "State" | "StateTable" | "CircularCooldown" | "Spritesheet" | "Timer";

export interface State {
	_Callbacks: { [name: string]: (old: unknown, next: unknown) => undefined };

	Value: unknown;

	ClassName: string;

	Get(this: State): unknown;
	Set(a: unknown): void;
	Update(fn: (old: unknown) => unknown): void;
	BindOnChange(name: string, callback: (old: unknown, next: unknown) => undefined): void;
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

	CompareTimes(object: Timer): (delta: number) => void;

	Start(): void;
	Resume(): void;
	Pause(): void;
	Stop(): void;
	GetRemaining(): number;
	BindToChanged(callback: () => void): void;
	BindToCompleted(callback: () => void): void;
	BindToInterrupted(callback: () => void): void;
}
