package;

import flixel.FlxG;
import flixel.FlxStrip;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.geom.Point;
import openfl.Vector;

/**
 * ...
 * @author jon
*/
class CurvyTerrain extends FlxStrip {
	public var spline:Array<FlxPoint>;
	public var angles:Array<Float>;
	
	public var endPoint:FlxPoint;
	public var endUV:Float = 0;
	public var startUV:Float = 0;

	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset) {
		super(X, Y, SimpleGraphic);
		spline = [];
		endPoint = FlxPoint.get();
	}

/**
	 * Generate the ground
	 * @param	width width of the ground
	 * @param	hSegments amount of horizontal steps
	 * @param	turbX how many hills
	 * @param	turbY how high or low the hills are
	 */

	public function generate(width:Float, stepAmount:Int, hillAmount:Int, minHeight:Float, maxHeight:Float, endY:Float):Void {
		spline = [];
		var direction:Int = -1;

		var pos:FlxPoint = FlxPoint.weak();
		var hillWidth:Float = width / hillAmount;
		var curveWidth:Float = hillWidth / 2;
		var curveAmount:Int = Std.int(hillAmount * 2);
		var curvePointAmount:Int = Std.int(stepAmount / curveAmount);


		for (i in 0...curveAmount) {
			var yVar:Float = FlxG.random.float(minHeight, maxHeight) * direction;
			if (i == curveAmount - 1) {
				yVar = endY - this.y;
			}
			var curve:Array<FlxPoint> = createCurve(pos.x, pos.y, pos.x + curveWidth, yVar, curvePointAmount);
			pos.copyFrom(curve[curve.length - 1]);
			if (i < curveAmount - 1) {
				curve.pop();
			}

			spline = spline.concat(curve);


			direction *= -1;
		}
		
		endPoint.copyFrom(spline[spline.length - 1]);

/**
		 * Calculate Angles for points
		 */
		calculateAngles();

/**
		 * Generate Vertices
		 */
		generateVerts();
	}

/**
	 * Calculate the angles for each point.
	 * These will be stored in a seperate point array
	 */

	function calculateAngles():Void {
		var prev:FlxPoint;
		var cur:FlxPoint;
		var next:FlxPoint;

		var dist1:Float;
		var dist2:Float;
		var distPerc:Float;

		angles = [];

		for (i in 0...spline.length) {
			if (i > 0 && i < spline.length - 1) {
				prev = spline[i - 1];
				cur = spline[i];
				next = spline[i + 1];

				dist1 = prev.distanceTo(cur);
				dist2 = cur.distanceTo(next);
				distPerc = dist1 / (dist1 + dist2);
				angles.push(prev.angleBetween(next));
//trace(prev.angleBetween(cur) + " - " + cur.angleBetween(next) + " - " + prev.angleBetween(next));
			} else {
				angles.push(90);
			}
		}
	}


/**
	 * Create a hill based on start, end, and height variance
	 * @param	start starting point
	 * @param	end ending point
	 * @param	amount amount of segments
	 * @param	minHeight minimum height variance in pixels
	 * @param	maxHeight maximum height variance in pixels
	 * @return Array of points
	 */

	function createHill(start:FlxPoint, end:FlxPoint, amount:Int, minHeight:Float, maxHeight:Float):Array<FlxPoint> {
		var points:Array<FlxPoint> = [];

		var width:Float = Math.abs(end.x - start.x);
		var middlePoint:FlxPoint = FlxPoint.weak(start.x + (width / 2), start.y + FlxG.random.float(minHeight, maxHeight));

/**
		 * Let's make the first half
		 */
		points = points.concat(createCurve(start.x, start.y, middlePoint.x, middlePoint.y, Std.int(amount / 2)));

		points.pop(); // Remove the last point so we don't have duplicates

/**
		 * Second Half
		 */
		points = points.concat(createCurve(middlePoint.x, middlePoint.y, end.x, end.y, Std.int(amount - points.length)));

		return points;
	}

/**
	 * Create a curve segment to be connected to other segments
	 * @param	x1 start x position
	 * @param	y1 start y position
	 * @param	x2 end x position
	 * @param	y2 end y position
	 * @param	amount amount of points in curve
	 * @return	An array of points
	 */

	function createCurve(x1:Float, y1:Float, x2:Float, y2:Float, amount:Int):Array<FlxPoint> {
		var points:Array<FlxPoint> = [];
		var p:FlxPoint;
		for (i in 0...amount) {
			p = getCurvedPoint(x1, y1, x2, y2, i / (amount - 1));

			points.push(p);
		}

		return points;
	}

/**
	 * Returns a point on the curved path between two points
	 * @param	x1 start x position
	 * @param	y1 start y position
	 * @param	x2 end x position
	 * @param	y2 end y position
	 * @param	time interpolation amount (0-1)
	 * @return	a FlxPoint
	 */

	function getCurvedPoint(x1:Float, y1:Float, x2:Float, y2:Float, time:Float):FlxPoint {
		var p:FlxPoint = FlxPoint.get();
		var w:Float = x2 - x1;
		var h:Float = y2 - y1;

		var len:Float = w * time;
		var ymid:Float = (y1 + y2) / 2;
		var ampl:Float = (y1 - y2) / 2;
		var ycos:Float = Math.cos(Math.PI * time);

		p.x = x1 + (w * time);
		p.y = ymid + ampl * ycos;
		return p;
	}

	function getPointVerts(index:Int):Array<FlxPoint> {
		var p:FlxPoint = this.spline[index];
		var angle:Float = this.angles[index];

		var vTop:FlxPoint = FlxPoint.get(p.x, p.y - (this.pixels.height / 2));
		vTop.rotate(p, angle - 90);

		var vBottom:FlxPoint = FlxPoint.get(vTop.x, vTop.y);
		vBottom.rotate(p, 180);

		vTop.set(FlxMath.roundDecimal(vTop.x, 6), FlxMath.roundDecimal(vTop.y, 6));
		vBottom.set(FlxMath.roundDecimal(vBottom.x, 6), FlxMath.roundDecimal(vBottom.y, 6));

		return [vTop, vBottom];
	}


	function generateVerts():Void {
		var points:Array<FlxPoint> = getPointVerts(0);


		var vert:Array<Float> = [];
		var ind:Array<Int> = [];
		var uvt:Array<Float> = [];

		var i0:Int;
		var i1:Int;
		var i2:Int;
		var i3:Int;

		//make first two vert points with uvt
		vert = vert.concat([points[0].x, points[0].y, points[1].x, points[1].y]);
		uvt = uvt.concat([startUV, 0, startUV, 1]);
		trace("start uv: " + startUV);
		var uvpos:Float = startUV;
		for (i in 1...spline.length) {
			var newPoints:Array<FlxPoint> = getPointVerts(i);
			var pointDistance:Float = spline[i - 1].distanceTo(spline[i]);
			var imgPerc:Float = pointDistance / graphic.bitmap.width;
			points = points.concat(newPoints);

			i0 = points.length - 4;
			i1 = points.length - 3;
			i2 = points.length - 2;
			i3 = points.length - 1;
			
			
			//vert = vert.concat([points[i0].x, points[i0].y, points[i1].x, points[i1].y]);
			vert = vert.concat([points[i2].x, points[i2].y, points[i3].x, points[i3].y]);
			//var endPerc:Float = FlxMath.bound(uvpos + imgPerc, 0, 1);
			var past1:Bool = (uvpos + imgPerc) >= 1;
			
			
			
			

			ind = ind.concat([i0, i1, i2, i2, i3, i1]);
			
			
			//var endPerc:Float = FlxMath.bound(uvpos + imgPerc, 0, 1);
			
			
			//uvpos = uvpos % 1;
			//uvt = uvt.concat([endPerc, 0, endPerc, 1]);
			uvpos += imgPerc;
			uvt = uvt.concat([uvpos, 0, uvpos, 1]);
			trace("uvpos: " + uvpos);
			if (past1) {
				//vert = vert.concat([points[i2].x, points[i2].y, points[i3].x, points[i3].y]);
				//uvt = uvt.concat([0, 0,0, 1]);
				//uvpos = 0;
			}
			//uvpos = uvpos % 1;
			//trace(uvpos);
		}
		
		endUV = uvpos;

		this.vertices = Vector.ofArray(vert);
		this.indices = Vector.ofArray(ind);
		this.uvtData = Vector.ofArray(uvt);
	}

}