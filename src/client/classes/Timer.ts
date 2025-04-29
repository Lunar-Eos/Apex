import { RunService } from "@rbxts/services";
import { BaseApexObject } from "../internals/BaseApexObject";

export class dTimer extends BaseApexObject {
	private _CountThread: RBXScriptConnection | undefined = undefined;
	private _ChangeFunction: () => void = () => {};
	private _EndFunction: () => void = () => {};
	private _InterruptFunction: () => void = () => {};

	private _SecondsLeft = 0;

	public TimeScale = 1;
	public Seconds = 0;

	private CompareTimes(object: dTimer) {
		return function (delta: number) {
			object._ChangeFunction();

			object._SecondsLeft = math.clamp(object._SecondsLeft - delta * object.TimeScale, 0, object.Seconds);
			if (object._SecondsLeft > 0) return;

			object._EndFunction();
			(object._CountThread as RBXScriptConnection).Disconnect();
		};
	}

	constructor() {
		super("Timer");
	}

	Start() {
		this._SecondsLeft = this.Seconds;

		this._CountThread = RunService.Heartbeat.Connect(this.CompareTimes(this));
	}

	Resume() {
		this._CountThread = RunService.Heartbeat.Connect(this.CompareTimes(this));
	}

	Pause() {
		this._InterruptFunction();
		(this._CountThread as RBXScriptConnection).Disconnect();
	}

	Stop() {
		this._InterruptFunction();
		(this._CountThread as RBXScriptConnection).Disconnect();

		this._SecondsLeft = this.Seconds;
	}

	GetRemaining() {
		return this._SecondsLeft;
	}

	BindToChanged(callback: () => void) {
		this._ChangeFunction = callback;
	}

	BindToCompleted(callback: () => void) {
		this._EndFunction = callback;
	}

	BindToInterrupted(callback: () => void) {
		this._InterruptFunction = callback;
	}
}
