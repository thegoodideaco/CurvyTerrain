package;

import flixel.addons.display.FlxExtendedSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author jon
 */
class DragPoint extends FlxExtendedSprite {

	public function new(X:Float=0, Y:Float=0, color:Int=0xffffff, radius:Float=10) 	{
		super(X, Y);
		loadGraphic("assets/images/point-bg.png");
		scale.set(.5, .5);
		updateHitbox();
		this.color = color;
		
		enableMouseDrag();
		
	}
	
}