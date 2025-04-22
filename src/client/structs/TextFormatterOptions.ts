export class TextFormatterOptions {
	Font = new Font("rbxasset://fonts/families/Arial.json");

	TextColor3 = new Color3(1, 1, 1);
	TextTransparency = 0;
	TextDirection = Enum.TextDirection.LeftToRight;
	TextSize = 24;

	TextStrokeColor3 = new Color3(0, 0, 0);
	TextStrokeTransparency = 1;

	TextXAlignment = Enum.HorizontalAlignment.Left;
	TextYAlignment = Enum.VerticalAlignment.Center;
	TextPaddingLeft = new UDim(0, 0);
	TextPaddingRight = new UDim(0, 0);
	TextPaddingTop = new UDim(0, 0);
	TextPaddingBottom = new UDim(0, 0);

	LineHeight = 24;
	BreakHeight = 48;

	FlexBehavior = Enum.UIFlexAlignment.None;

	LabelBackgroundColor3 = new Color3(0, 0, 0);
	LabelBackgroundTransparency = 0;
	LabelStrokeColor3 = new Color3(0, 0, 0);
	LabelStrokeSize = 1;
	LabelStrokeMode = Enum.BorderMode.Outline;

	constructor() {}
}
