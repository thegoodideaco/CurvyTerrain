package;

import flixel.FlxStrip;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author jon
 */
class CurvyTerrain extends FlxStrip {
	var spline:Array<FlxPoint>;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		spline = [];
	}
	
	/**
	 * Generate the ground
	 * @param	width width of the ground
	 * @param	hSegments amount of horizontal steps
	 * @param	turbX how many hills
	 * @param	turbY how high or low the hills are
	 */
	public function generate(width:Float, hSegments:Int, turbX:Int, turbY:Float):Void {
		spline = [];
		
		//draw hilltop points
		var hilltops:Array<FlxPoint>;
		for (i in 0...turbX) {
			
		}
	}
	
}