package;

import flixel.addons.plugin.FlxMouseControl;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.Lib;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	
	
	
	var p1:DragPoint;
	var p2:DragPoint;
	var line:FlxSprite;
	var c:CurvyTerrain;
var ls:LineStyle = {
			thickness: 5,
			color: FlxColor.WHITE
		};
	override public function create():Void {
		super.create();
		
		
		
		if (FlxG.plugins.get(FlxMouseControl) == null) {
			FlxG.plugins.add(new FlxMouseControl());
		}
		
		c = new CurvyTerrain(0, FlxG.game.height / 2, "assets/images/sand.png");
		add(c);
		
		
		
		c.generate(FlxG.width * .5, 10, 4, 5);
		
	}
	

	override public function destroy():Void	{
		super.destroy();
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		FlxG.camera.scroll.x += .01;
	}
}