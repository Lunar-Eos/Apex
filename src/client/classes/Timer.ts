import { RunService } from "@rbxts/services";
import { BaseApexObject } from "../internals/BaseApexObject";

export class Timer extends BaseApexObject {
	private _CountThread: RBXScriptConnection | undefined = undefined;
	private _ChangeFunction: () => undefined = () => {};
	private _EndFunction: () => undefined = () => {};
	private _InterruptFunction: () => undefined = () => {};

	private _SecondsLeft = 0;

	public TimeScale = 1;
	public Seconds = 0;

	private CompareTimes(object: Timer) {
		return function (delta: number) {
			object._ChangeFunction();

			object._SecondsLeft = math.clamp(object._SecondsLeft - delta * object.TimeScale, 0, object.Seconds);
			if (object._SecondsLeft > 0) return;

			object._EndFunction();
			(object._CountThread as RBXScriptConnection).Disconnect();
		};
	}

	constructor(seconds: number, scale: number) {
		super("Timer");

		this._SecondsLeft = seconds;

		this.TimeScale = scale;
		this.Seconds = seconds;
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

	BindToChanged(callback: () => undefined) {
		this._ChangeFunction = callback;
	}

	BindToCompleted(callback: () => undefined) {
		this._EndFunction = callback;
	}

	BindToInterrupted(callback: () => undefined) {
		this._InterruptFunction = callback;
	}
}
