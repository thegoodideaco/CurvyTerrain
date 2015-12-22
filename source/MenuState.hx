package;

import flixel.addons.plugin.FlxMouseControl;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.Timer;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState {
    
    var c:CurvyTerrain;
    var c2:CurvyTerrain;
	var drawSpr:FlxSprite;
    
	var pos:Float = 0;
	
	public var SECTION_WIDTH:Float = 800;
	public var STEP_AMOUNT:Int = 50;
	public var HILL_AMOUNT:Int = 2;
	public var MIN_HEIGHT:Float = 0;
	public var MAX_HEIGHT:Float = 50;
	
	public var bFillSpr:Sprite;

    override public function create():Void {
        super.create();
		//FlxG.debugger.precision = 2;
		SECTION_WIDTH = FlxG.width * 1.2;
		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.camera.antialiasing = true;
		
		bFillSpr = FlxSpriteUtil.flashGfxSprite;
		
		FlxG.watch.add(this,"SECTION_WIDTH");
		FlxG.watch.add(this,"HILL_AMOUNT");
		FlxG.watch.add(this,"STEP_AMOUNT");
		FlxG.watch.add(this,"MIN_HEIGHT");
		FlxG.watch.add(this, "MAX_HEIGHT");
		
		//fixes repeat?
		FlxSpriteUtil.flashGfxSprite.cacheAsBitmap = true;
		
		
		
        c = new CurvyTerrain(0, FlxG.game.height / 2, "assets/images/grass.png");
        c2 = new CurvyTerrain(0, FlxG.game.height / 2, "assets/images/grass.png");
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
    }
	
	


    override public function destroy():Void {
        super.destroy();
    }

    override public function update(elapsed:Float):Void {
		if (FlxG.mouse.justPressed) {
			c.generate(SECTION_WIDTH, STEP_AMOUNT, HILL_AMOUNT, MIN_HEIGHT, MAX_HEIGHT, FlxG.height / 2);
		}
		
		FlxG.camera.scroll.x += 3.5;
		
		
		
		pos = c.x + c.endPoint.x;
		if (pos - FlxG.camera.scroll.x < 0) {
			c.setPosition(c2.x + c2.endPoint.x, c2.y + c2.endPoint.y);
			c.startUV = c2.endUV % 1;
			c.generate(SECTION_WIDTH, STEP_AMOUNT, HILL_AMOUNT, MIN_HEIGHT, MAX_HEIGHT, FlxG.height / 2);
			var oldc = c;
			c = c2;
			c2 = oldc;
		}
		
        super.update(elapsed);
		
		
		
		//FlxSpriteUtil.drawLine(drawSpr, 0, 0, FlxG.mouse.x, FlxG.mouse.y, ls);

        
    }
}