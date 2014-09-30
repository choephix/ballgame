package game {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class Ball extends DisplayObjectContainer {
		
		private static var NEXT_UID:uint = 1;
		private static const SPEED_MULTIPLIER:Number = 10;
		public var uid:uint = 0;
		public var radius:Number = 25.0;
		public var position:Point;
		public var force:Point;
		public var section:Section;
		
		public function Ball() {
			
			this.uid = NEXT_UID;
			NEXT_UID++;
			
			this.position = new Point();
			this.force = new Point();
			
			var q:DisplayObject;
			q = new Image ( App.assets.getTexture( "o" ) );
			//q = new Quad( 50, 50, 0xFf8800 );
			q.width =
			q.height = radius * 2.0;
			q.alignPivot();
			addChild( q );
			
			touchable = false;
			
		}
		
		public function setForce( x:Number, y:Number ):void {
			
			force.x = x;
			force.y = y;
			
		}
		
		public function startMoving( angle:Number, speed:Number ):void {
			
			speed *= SPEED_MULTIPLIER;
			setForce( Math.cos( angle ) * speed, -Math.sin( angle ) * speed );
			
		}
		
		public function loopUpdate( timeElapsed:Number ):void {
			
			x += timeElapsed * force.x;
			y += timeElapsed * force.y;
			
			if ( bounds.left <= section.left )  {
				bounds.left = 2.0 * section.left - bounds.left;
				force.x *= -1.0;
				onEdgeCollision();
			}  else
			if ( bounds.right >= section.right )  {
				bounds.right = 2.0 * section.right - bounds.right;
				force.x *= -1.0;
				onEdgeCollision();
			} else
			if ( bounds.top <= section.top )  {
				bounds.top = 2.0 * section.top - bounds.top;
				force.y *= -1.0;
				onEdgeCollision();
			}
			if ( bounds.bottom >= section.bottom )  {
				bounds.bottom = 2.0 * section.bottom - bounds.bottom;
				force.y *= -1.0;
				onEdgeCollision();
			}
			
			position.setTo( x, y );
			
		}
		
		private var blacklisted:Ball;
		public function checkForCollisionWithBall( subject:Ball ):void {
			
			if ( blacklisted == subject )
				return;
			
			if ( radius * 2.0 > Point.distance( position, subject.position ) ) {
				
				var fi:Number = getAngle( position.x, position.y, subject.x, subject.y );
				var fa:Number = getAngle( force.x, force.y );
				fa -= fi * 2.0;
				
				startMoving( fa, force.length / SPEED_MULTIPLIER );
				
				trace( "BAM!", this, subject );
				
				blacklisted = subject;
				
			}
			
		}
		
		private function onEdgeCollision():void {
			
		}
		
		public function die():void {
			
			removeFromParent( true );
			
		}
		
		public function toString():String {
			
			return uid.toString();
			
		}
		
		private function getAngle( x1:Number, y1:Number, x2:Number = 0.0, y2:Number = 0.0 ):Number{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.atan2( dy, dx );
		}
		
	}

}