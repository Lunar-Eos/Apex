import { TweenService } from "@rbxts/services";
import { BaseApexObject } from "../internals/BaseApexObject";

const TRANSPARENCY_SEQUENCE = new NumberSequence([
	new NumberSequenceKeypoint(0, 0),
	new NumberSequenceKeypoint(0.5, 0),
	new NumberSequenceKeypoint(0.501, 1),
	new NumberSequenceKeypoint(1, 1),
]);

export class dCircularCooldown extends BaseApexObject {
	private _CooldownObject: NumberValue = new Instance("NumberValue");

	private _CompleteEvent: BindableEvent = new Instance("BindableEvent");
	private _ChangeEvent: BindableEvent = new Instance("BindableEvent");

	private _Tween: Tween | undefined = undefined;

	readonly Completed: RBXScriptSignal = this._CompleteEvent.Event;
	readonly Changed: RBXScriptSignal = this._ChangeEvent.Event;

	public Object: Folder;

	public RemainingDuration: number = 1;
	public Duration: number = 1;
	public Rate: number = 1;

	constructor() {
		super("CircularCooldown");

		const folder = new Instance("Folder");
		folder.Name = "CircularCooldown";
		folder.SetAttribute("Color", new Color3(1, 1, 1));
		folder.SetAttribute("Transparency", 0);
		folder.SetAttribute("Visible", true);
		folder.SetAttribute("ZIndex", 1);

		folder.GetAttributeChangedSignal("Color").Connect(() => {
			const val: Color3 = folder.GetAttribute("Color") as Color3;

			(folder.FindFirstChild("Left") as ImageLabel).ImageColor3 = val;
			(folder.FindFirstChild("Right") as ImageLabel).ImageColor3 = val;
		});

		folder.GetAttributeChangedSignal("Transparency").Connect(() => {
			const val: number = folder.GetAttribute("Transparency") as number;

			(folder.FindFirstChild("Left") as ImageLabel).ImageTransparency = val;
			(folder.FindFirstChild("Right") as ImageLabel).ImageTransparency = val;
		});

		folder.GetAttributeChangedSignal("Visible").Connect(() => {
			const val: boolean = folder.GetAttribute("Visible") as boolean;

			(folder.FindFirstChild("Left") as ImageLabel).Visible = val;
			(folder.FindFirstChild("Right") as ImageLabel).Visible = val;
		});

		folder.GetAttributeChangedSignal("ZIndex").Connect(() => {
			const val: number = folder.GetAttribute("ZIndex") as number;

			(folder.FindFirstChild("Left") as ImageLabel).ZIndex = val;
			(folder.FindFirstChild("Right") as ImageLabel).ZIndex = val;
		});

		// #region Init
		this._CooldownObject.Changed.Connect(() => {
			this._ChangeEvent.Fire();

			// FLAG: implement circular spinny logic here
		});
		// #endregion

		// #region Create the semicircle images.
		const left = new Instance("ImageLabel");
		left.BackgroundTransparency = 1;
		left.AnchorPoint = new Vector2(0, 0.5);
		left.Position = new UDim2(0, 0, 0.5, 0);
		left.Size = new UDim2(0.5, 0, 1, 0);
		left.Image = "rbxassetid://134149598090509";
		left.ClipsDescendants = true;

		const right = new Instance("ImageLabel");
		right.BackgroundTransparency = 1;
		right.AnchorPoint = new Vector2(1, 0.5);
		right.Position = new UDim2(1, 0, 0.5, 0);
		right.Size = new UDim2(0.5, 0, 1, 0);
		right.Image = "rbxassetid://132382211808404";
		right.ClipsDescendants = true;
		// #endregion

		// #region Create the gradients.
		const leftGradient = new Instance("UIGradient");
		leftGradient.Transparency = TRANSPARENCY_SEQUENCE;
		leftGradient.Offset = new Vector2(0.5, 0);
		leftGradient.Rotation = 0;

		const rightGradient = new Instance("UIGradient");
		rightGradient.Transparency = TRANSPARENCY_SEQUENCE;
		rightGradient.Offset = new Vector2(-0.5, 0);
		rightGradient.Rotation = -180;
		// #endregion

		// #region Parent all instances to the folder.
		leftGradient.Parent = left;
		rightGradient.Parent = right;
		left.Parent = folder;
		right.Parent = folder;
		// #endregion

		this.Object = folder;
	}

	Init(object: GuiObject | undefined) {
		this.Object.Parent = object;
	}

	Play() {
		// #region Play the cooldown.
		this.Object.SetAttribute("Visible", true);
		this._CooldownObject.Value = this.RemainingDuration;

		if (this._Tween !== undefined) this._Tween.Destroy();
		this._Tween = TweenService.Create(
			this._CooldownObject,
			new TweenInfo(
				this.RemainingDuration / this.Rate,
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.InOut,
				0,
				false,
				0,
			),
			{ Value: 0 },
		);
		this._Tween.Play();
		// #endregion

		// #region Finally fire completion events and Destroy connections when complete.
		this._Tween.Completed.Connect(() => {
			this._CompleteEvent.Fire();

			if (this._Tween !== undefined) this._Tween.Destroy();
		});
		// #endregion
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
