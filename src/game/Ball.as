package game {
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class Ball extends DisplayObjectContainer {
		
		private const SPEED_MULTIPLIER:Number = 10;
		
		public var forceX:Number;
		public var forceY:Number;
		
		public var section:Section;
		
		public function Ball() {
			
			var q:DisplayObject;
			
			q = new Image ( App.assets.getTexture( "o" ) );
			//q = new Quad( 50, 50, 0xFf8800 );
			q.width =
			q.height = 50;
			q.alignPivot();
			addChild( q );
			
			touchable = false;
			
		}
		
		public function setForce( x:Number, y:Number ):void {
			
			forceX = x;
			forceY = y;
			
		}
		
		public function startMoving( angle:Number, speed:Number ):void {
			
			speed *= SPEED_MULTIPLIER;
			setForce( Math.cos( angle ) * speed, Math.sin( angle ) * speed );
			
		}
		
		public function loopUpdate( timeElapsed:Number ):void {
			
			x += timeElapsed * forceX;
			y += timeElapsed * forceY;
			
			if ( x <= section.left )  {
				x = 2.0 * section.left - x;
				forceX *= -1.0;
			} 
			if ( x >= section.right )  {
				x = 2.0 * section.right - x;
				x = section.right;
				forceX *= -1.0;
			} 
			if ( y <= section.top )  {
				y = 2.0 * section.top - y;
				forceY *= -1.0;
			}
			if ( y >= section.bottom )  {
				y = 2.0 * section.bottom - y;
				forceY *= -1.0;
			}
			
		}
		
	}

}