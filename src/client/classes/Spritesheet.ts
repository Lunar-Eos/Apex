import { BaseApexObject } from "../internals/BaseApexObject";

export class Spritesheet {
	protected _ChangedCallback = () => {};

	protected _SpritesPerRow = 10;
	protected _SpritesPerColumn = 10;

	public CurrentSprite = 0;
	public TotalSprites = 100;

	public Object = "image";

	public Size = new Vector2(140, 140);
	public SpriteSize = new Vector2(14, 14);
	public DirectionX = "Left";
	public DirectionY = "Down";
}
