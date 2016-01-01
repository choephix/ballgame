package game {
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class Section extends Rectangle {
		
		public var quad:DisplayObject;
		
		//public function Section( x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0 ) {
		public function Section( left:Number, top:Number, right:Number, bottom:Number ) {
			
			super( left, top, right - left, bottom - top );
			
			///THE DEBUG QUAD
			//var clr:uint = Math.random() * 0xFFFFFF;
			var clr:uint = 0xCCDDDD;
			quad = new Quad( width, height, clr );
			quad.x = x;
			quad.y = y;
			//quad.alpha = 0.333;
		}
	
	}

}