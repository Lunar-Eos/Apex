import { TweenService } from "@rbxts/services";
import { BaseApexObject } from "../internals/BaseApexObject";
import mathv from "../generics/mathv";

const TRANSPARENCY_SEQUENCE = new NumberSequence([
	new NumberSequenceKeypoint(0, 0),
	new NumberSequenceKeypoint(0.5, 0),
	new NumberSequenceKeypoint(0.501, 1),
	new NumberSequenceKeypoint(1, 1),
]);

function playCooldown(obj: dRadialCooldown) {
	if (obj._Tween !== undefined) obj._Tween.Destroy();
	obj._Tween = TweenService.Create(
		obj._CooldownObject,
		new TweenInfo(
			obj.RemainingDuration / obj.Rate,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.InOut,
			0,
			false,
			0,
		),
		{ Value: 0 },
	);
	obj._Tween.Play();

	obj._Tween.Completed.Connect(() => {
		obj._CompleteEvent.Fire();

		if (obj._Tween !== undefined) obj._Tween.Destroy();
	});
}

export class dRadialCooldown extends BaseApexObject {
	_CooldownObject: NumberValue = new Instance("NumberValue");

	_CompleteEvent: BindableEvent = new Instance("BindableEvent");
	_ChangeEvent: BindableEvent = new Instance("BindableEvent");

	_Tween: Tween | undefined = undefined;

	readonly Completed: RBXScriptSignal = this._CompleteEvent.Event;
	readonly Changed: RBXScriptSignal = this._ChangeEvent.Event;

	Object: Folder;

	RemainingDuration: number = 1;
	Duration: number = 1;
	Rate: number = 1;

	constructor() {
		super("RadialCooldown");

		const folder = new Instance("Folder");
		folder.Name = "CircularCooldown";
		folder.SetAttribute("Color", new Color3(1, 1, 1));
		folder.SetAttribute("Transparency", 0);
		folder.SetAttribute("Visible", true);
		folder.SetAttribute("ZIndex", 1);

		folder.GetAttributeChangedSignal("Color").Connect(() => {
			const val: Color3 = folder.GetAttribute("Color") as Color3;

			(folder.FindFirstChild("Left") as Frame).BackgroundColor3 = val;
			(folder.FindFirstChild("Right") as Frame).BackgroundColor3 = val;
		});

		folder.GetAttributeChangedSignal("Transparency").Connect(() => {
			const val: number = folder.GetAttribute("Transparency") as number;

			(folder.FindFirstChild("Left") as Frame).BackgroundTransparency = val;
			(folder.FindFirstChild("Right") as Frame).BackgroundTransparency = val;
		});

		folder.GetAttributeChangedSignal("Visible").Connect(() => {
			const val: boolean = folder.GetAttribute("Visible") as boolean;

			(folder.FindFirstChild("Left") as Frame).Visible = val;
			(folder.FindFirstChild("Right") as Frame).Visible = val;
		});

		folder.GetAttributeChangedSignal("ZIndex").Connect(() => {
			const val: number = folder.GetAttribute("ZIndex") as number;

			(folder.FindFirstChild("Left") as Frame).ZIndex = val;
			(folder.FindFirstChild("Right") as Frame).ZIndex = val;
		});

		// #region Create the semicircle images.
		const left = new Instance("Frame");
		left.AnchorPoint = new Vector2(0, 0.5);
		left.Position = new UDim2(0, 0, 0.5, 0);
		left.Size = new UDim2(0.5, 0, 1, 0);
		left.ClipsDescendants = true;

		const right = new Instance("Frame");
		right.AnchorPoint = new Vector2(1, 0.5);
		right.Position = new UDim2(1, 0, 0.5, 0);
		right.Size = new UDim2(0.5, 0, 1, 0);
		right.ClipsDescendants = true;
		// #endregion

		// #region Create the gradients.
		const leftGradient = new Instance("UIGradient");
		leftGradient.Transparency = TRANSPARENCY_SEQUENCE;
		leftGradient.Offset = new Vector2(0.5, 0);
		leftGradient.Rotation = 0; // range: 0 to 180

		const rightGradient = new Instance("UIGradient");
		rightGradient.Transparency = TRANSPARENCY_SEQUENCE;
		rightGradient.Offset = new Vector2(-0.5, 0);
		rightGradient.Rotation = -180; // range: -180 to 0
		// #endregion

		// #region Parent all instances to the folder.
		leftGradient.Parent = left;
		rightGradient.Parent = right;
		left.Parent = folder;
		right.Parent = folder;
		// #endregion

		// #region Connect changed event to the internal countdown object.
		this._CooldownObject.Changed.Connect(() => {
			this._ChangeEvent.Fire();

			this.RemainingDuration = this._CooldownObject.Value;

			if (this.RemainingDuration > this.Duration / 2) {
				leftGradient.Rotation = 0;

				const norm = mathv.normalize(this.RemainingDuration, this.Duration / 2, this.Duration);
				const rotation = mathv.lerp(0, -180, norm);

				rightGradient.Rotation = rotation;
			} else {
				rightGradient.Rotation = 0;

				const norm = mathv.normalize(this.RemainingDuration, 0, this.Duration / 2);
				const rotation = mathv.lerp(180, 0, norm);

				leftGradient.Rotation = rotation;
			}
		});
		// #endregion

		this.Object = folder;
	}

	Init(object: GuiObject | undefined) {
		this.Object.Parent = object;
	}

	Play() {
		this.RemainingDuration = this.Duration;
		this.Object.SetAttribute("Visible", true);
		this._CooldownObject.Value = this.RemainingDuration;

		playCooldown(this);
	}

	Resume() {
		this.Object.SetAttribute("Visible", true);
		this._CooldownObject.Value = this.RemainingDuration;

		playCooldown(this);
	}

	Pause() {
		if (this._Tween === undefined) return;

		this._Tween.Pause();
	}

	Cancel() {
		if (this._Tween === undefined) return;

		this._Tween.Cancel();
		this.RemainingDuration = this.Duration;
	}
}
