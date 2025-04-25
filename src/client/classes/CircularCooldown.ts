import mathv from "../generics/mathv";

import { BaseApexObject } from "../internals/BaseApexObject";
import { TweenService } from "@rbxts/services";

const IMAGE_POSITIONS = [UDim2.fromScale(0, 0), UDim2.fromScale(-1, 0)];
const DEFAULT_SHOW_ON_DEFAULT = false;
const DEFAULT_COLOR = Color3.fromRGB(172, 172, 172);
const DEFAULT_TRANSPARENCY = 0;

export class CircularCooldown {
	private _CooldownObject: NumberValue = new Instance("NumberValue");
	private _ChangeEvent: BindableEvent = new Instance("BindableEvent");
	private _CompleteEvent: BindableEvent = new Instance("BindableEvent");
	private _Connection: RBXScriptConnection | undefined = undefined;
	private _Tween: Tween | undefined = undefined;

	readonly Changed: RBXScriptSignal | undefined = this._ChangeEvent.Event;
	readonly Completed: RBXScriptSignal | undefined = this._CompleteEvent.Event;

	public readonly Frame: Frame;

	public RemainingCooldown: number;
	public Cooldown: number;
	public Rate: number;
	public ReplayWhileActive: boolean;

	constructor(
		gui: GuiObject,
		cd: number,
		rate: number | undefined,
		playWhileActive: boolean | undefined,
		showOnCreation: boolean | undefined,
		color: Color3 | undefined,
		transparency: number | undefined,
	) {
		const folder = new Instance("Folder");
		folder.Name = "CircularCooldown";

		const mainFrame = new Instance("Frame");
		mainFrame.BackgroundTransparency = 1;
		mainFrame.Visible = showOnCreation || DEFAULT_SHOW_ON_DEFAULT;
		mainFrame.Size = UDim2.fromScale(1, 1);

		for (let i = 1; i >= 0; i--) {
			const frame = new Instance("Frame");
			frame.Name = tostring(i);
			frame.ClipsDescendants = true;
			frame.BackgroundTransparency = 1;
			frame.Position = UDim2.fromScale(i - 1, 0);
			frame.AnchorPoint = new Vector2(i - 1, 0);
			frame.Visible = showOnCreation || DEFAULT_SHOW_ON_DEFAULT;
			frame.Size = UDim2.fromScale(0.5, 1);

			const image = new Instance("ImageLabel");
			image.Name = "Shade";
			image.BackgroundTransparency = 1;
			image.Image = "rbxassetid://15478839340";
			image.ImageColor3 = color || DEFAULT_COLOR;
			image.ImageTransparency = transparency || DEFAULT_TRANSPARENCY;
			image.Size = UDim2.fromScale(2, 1);
			image.Position = IMAGE_POSITIONS[i];

			const gradient = new Instance("UIGradient");
			gradient.Transparency = new NumberSequence([
				new NumberSequenceKeypoint(0, 0),
				new NumberSequenceKeypoint(0.5, 0),
				new NumberSequenceKeypoint(0.501, 1),
				new NumberSequenceKeypoint(1, 1),
			]);
			gradient.Rotation = 180 * (i - 1);
			gradient.SetAttribute("StartRotation", 180 * (i - 1));
			gradient.SetAttribute("EndRotation", 180 * (i - 1) + 180);

			gradient.Parent = image;
			image.Parent = frame;
			frame.Parent = mainFrame;
		}

		mainFrame.Parent = folder;
		folder.Parent = gui;

		this.Frame = mainFrame;
		this.RemainingCooldown = cd;
		this.Cooldown = cd;
		this.Rate = rate || 1;
		this.ReplayWhileActive = playWhileActive || false;
	}

	Play() {
		if (this.ReplayWhileActive === false && this.RemainingCooldown > 0 && this.RemainingCooldown < this.Cooldown)
			return;

		// #region
		// First reset all frames and values.
		this.RemainingCooldown = this.Cooldown;
		this.Frame.Visible = true;

		for (const object of this.Frame.GetDescendants()) {
			if (object.IsA("Frame") === true) object.Visible = true;
			else if (object.IsA("UIGradient") === true)
				object.Rotation = object.GetAttribute("StartRotation") as number;
		}
		// #endregion

		// #region
		// Then play the cooldown.
		this.Frame.Visible = true;
		this._CooldownObject.Value = this.RemainingCooldown;

		if (this._Tween !== undefined) this._Tween.Destroy();

		this._Tween = TweenService.Create(
			this._CooldownObject,
			new TweenInfo(
				this.RemainingCooldown / this.Rate,
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

		// #region
		// Then toggle the halves based on the remaining cooldown duration.
		for (let i = 0; i <= 1; i++) {
			const frame = this.Frame.FindFirstChild(tostring(i)) as Frame;

			if (frame !== undefined) frame.Visible = false;
		}

		for (let i = math.ceil(mathv.normalize(this._CooldownObject.Value, 0, this.Cooldown) * 1); i >= 1; i--) {
			const frame = this.Frame.FindFirstChild(tostring(i)) as Frame;

			if (frame !== undefined) frame.Visible = true;
		}
		// #endregion

		// #region
		// Then count down the cooldown.
		if (this._Connection !== undefined) this._Connection.Disconnect();

		this._Connection = this._CooldownObject.Changed.Connect(() => {
			this.RemainingCooldown = this._CooldownObject.Value;
			this._ChangeEvent.Fire(this._CooldownObject.Value);

			const index = math.clamp(
				math.ceil(mathv.normalize(this._CooldownObject.Value, 0, this.Cooldown) * 2),
				1,
				2,
			);
			const gradient = this.Frame.FindFirstChild(tostring(index))
				?.FindFirstChild("Shade")
				?.FindFirstChild("UIGradient") as UIGradient;

			gradient.Rotation = mathv.lerp(
				gradient.GetAttribute("EndRotation") as number,
				gradient.GetAttribute("StartRotation") as number,
				mathv.normalize(
					this._CooldownObject.Value,
					(this.Cooldown / 2) * (index - 1),
					(this.Cooldown / 2) * index,
				),
			);

			for (let i = index + 1; i <= 2; i++) {
				const frame = this.Frame.FindFirstChild(tostring(i)) as Frame;

				if (frame !== undefined) frame.Visible = false;
			}
		});
		// #endregion

		// #region
		// Finally fire completion events and Destroy connections when complete.
		this._Tween.Completed.Connect(() => {
			const one = this.Frame.FindFirstChild("1") as Frame;
			const two = this.Frame.FindFirstChild("2") as Frame;

			if (one !== undefined) one.Visible = false;

			if (two !== undefined) two.Visible = false;

			this._CompleteEvent.Fire();

			if (this._Tween !== undefined) this._Tween.Destroy();

			if (this._Connection !== undefined) this._Connection.Disconnect();
		});
		// #endregion
	}

	Pause() {
		if (this._Tween !== undefined) this._Tween.Pause();
	}

	Cancel() {
		if (this._Tween !== undefined) {
			this._Tween.Cancel();
			this.RemainingCooldown = this.Cooldown;
		}
	}
}
