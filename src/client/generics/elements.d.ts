interface elements {
	preload: (t: GuiObject[]) => undefined;
	// eslint-disable-next-line prettier/prettier
	getTextDimensions: (text: string, font: Font, size: number, frameSize: number, yield: boolean | undefined) => undefined;
}

declare const elements: elements;

export = elements;
