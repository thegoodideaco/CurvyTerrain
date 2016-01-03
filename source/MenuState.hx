package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.util.FlxSpriteUtil;
import openfl.display.Sprite;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState {

	var c:CurvyTerrain;
	var c2:CurvyTerrain;
	var drawSpr:FlxSprite;

	var pos:Float = 0;

	public var SECTION_WIDTH:Float = 800;
	public var STEP_AMOUNT:Int = 20;
	public var HILL_AMOUNT:Int = 2;
	public var MIN_HEIGHT:Float = 0;
	public var MAX_HEIGHT:Float = 20;

	public var bFillSpr:Sprite;
	
	public var guy:FlxSprite;

	override public function create():Void {
		super.create();
		FlxG.debugger.precision = 2;
		SECTION_WIDTH = FlxG.width * 1.5;
		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.camera.antialiasing = true;
		FlxG.camera.pixelPerfectRender = false;
//FlxG.camera.canvas.cacheAsBitmap = true;
		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;

		bFillSpr = FlxSpriteUtil.flashGfxSprite;

		FlxG.watch.add(this, "SECTION_WIDTH");
		FlxG.watch.add(this, "HILL_AMOUNT");
		FlxG.watch.add(this, "STEP_AMOUNT");
		FlxG.watch.add(this, "MIN_HEIGHT");
		FlxG.watch.add(this, "MAX_HEIGHT");

//fixes repeat?
		FlxSpriteUtil.flashGfxSprite.cacheAsBitmap = true;


		c = new CurvyTerrain(0, FlxG.game.height / 2, "assets/images/road.jpg");
		c2 = new CurvyTerrain(0, FlxG.game.height / 2, "assets/images/road.jpg");


//c2 = new CurvyTerrain(0, FlxG.game.height / 2);
//c2.loadGraphicFromSprite(c);

		c.antialiasing = true;
		c2.antialiasing = true;
		add(c);
		add(c2);

//generate some hills
		c.generate(SECTION_WIDTH, STEP_AMOUNT, HILL_AMOUNT, MIN_HEIGHT, MAX_HEIGHT, FlxG.height / 2);
		c2.generate(SECTION_WIDTH, STEP_AMOUNT, HILL_AMOUNT, MIN_HEIGHT, MAX_HEIGHT, FlxG.height / 2);


		c2.setPosition(c.x + c.endPoint.x, c.y + c.endPoint.y);
		
		guy = new FlxSprite();
		guy.makeGraphic(10, 10);
		guy.screenCenter();
		add(guy);
		FlxG.camera.target = guy;
		
		guy.velocity.x = 1000;
	}


	override public function destroy():Void {
		super.destroy();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (FlxG.mouse.justPressed) {
			c.generate(SECTION_WIDTH, STEP_AMOUNT, HILL_AMOUNT, MIN_HEIGHT, MAX_HEIGHT, FlxG.height / 2);
		}

		//FlxG.camera.scroll.x += 3.5;


		pos = c.x + c.endPoint.x;
		if (pos - FlxG.camera.scroll.x < 0) {
			c.setPosition(c2.x + c2.endPoint.x, c2.y + c2.endPoint.y);
			c.startUV = c2.endUV % 1;
			c.generate(SECTION_WIDTH, STEP_AMOUNT, HILL_AMOUNT, MIN_HEIGHT, MAX_HEIGHT, FlxG.height / 2);
			var oldc = c;
			c = c2;
			c2 = oldc;
		}

		


//FlxSpriteUtil.drawLine(drawSpr, 0, 0, FlxG.mouse.x, FlxG.mouse.y, ls);


	}
}