import { RunService } from "@rbxts/services";
import { BaseApexObject } from "../internals/BaseApexObject";

function compareTimes(object: dTimer) {
	return function (delta: number) {
		object._ChangeFunction();

		object._SecondsLeft = math.clamp(object._SecondsLeft - delta * object.TimeScale, 0, object.Seconds);
		if (object._SecondsLeft > 0) return;

		object._EndFunction();
		(object._CountThread as RBXScriptConnection).Disconnect();
	};
}

export class dTimer extends BaseApexObject {
	_CountThread: RBXScriptConnection | undefined = undefined;
	_ChangeFunction: () => void = () => {};
	_EndFunction: () => void = () => {};
	_InterruptFunction: () => void = () => {};

	_SecondsLeft = 0;

	TimeScale = 1;
	Seconds = 0;

	constructor() {
		super("Timer");
	}

	Start() {
		this._SecondsLeft = this.Seconds;

		this._CountThread = RunService.Heartbeat.Connect(compareTimes(this));
	}

	Resume() {
		this._CountThread = RunService.Heartbeat.Connect(compareTimes(this));
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
