package game {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class Ball extends DisplayObjectContainer {
		
		public static var BALL_DEATH:String;
		
		///
		
		private static var NEXT_UID:uint = 1;
		private static const SPEED_MULTIPLIER:Number = 10;
		public var uid:uint = 0;
		public var radius:Number;
		public var position:Point;
		public var force:Point;
		public var section:Section;
		private var img:Image;
		
		public function Ball( radius:Number = 25.0 ) {
			
			this.radius = radius;
			this.position = new Point();
			this.force = new Point();
			this.uid = NEXT_UID;
			NEXT_UID++;
			
			img = new Image ( App.assets.getTexture( "o" ) );
			//q = new Quad( 50, 50, 0xFf8800 );
			img.width =
			img.height = radius * 2.0;
			img.alignPivot();
			addChild( img );
			
			touchable = false;
			
			var t:TextField = new TextField( radius * 2.0, radius * 2.0, uid.toString() );
			t.bold = true;
			t.fontSize = 22.0;
			t.color  = 0x7788aa;
			t.color  = 0xAABBDD;
			t.hAlign = HAlign.CENTER;
			t.vAlign = VAlign.CENTER;
			t.alignPivot();
			addChild( t );
			
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
			
			if ( section.width < radius * 2.0 || section.height < radius * 2.0 ) {
				return;
			}
			
			x += timeElapsed * force.x;
			y += timeElapsed * force.y;
			
			if ( bounds.left <= section.left )  {
				bounds.left = 2.0 * section.left - bounds.left;
				force.x = Math.abs( force.x );
				onEdgeCollision();
			}  else
			if ( bounds.right >= section.right )  {
				bounds.right = 2.0 * section.right - bounds.right;
				force.x = -Math.abs( force.x );
				onEdgeCollision();
			}
			
			if ( bounds.top <= section.top )  {
				bounds.top = 2.0 * section.top - bounds.top;
				force.y = Math.abs( force.y );
				onEdgeCollision();
			} else
			if ( bounds.bottom >= section.bottom )  {
				bounds.bottom = 2.0 * section.bottom - bounds.bottom;
				force.y = -Math.abs( force.y );
				onEdgeCollision();
			}
			
			position.setTo( x, y );
		}
		
		private var blacklisted:Ball; // must be vector
		public function checkForCollisionWithBall( subject:Ball ):void {
			
			if ( radius * 2.0 > Point.distance( position, subject.position ) ) {
				
				if ( blacklisted == subject )
					return;
				
				var fi:Number = getAngle( position.x, position.y, subject.x, subject.y );
				var fa:Number = getAngle( force.x, force.y );
				fa -= fi * 2.0;
				
				startMoving( fa, force.length / SPEED_MULTIPLIER );
				
				blacklisted = subject;
				
				onBallCollision();
				
			} else {
				if ( blacklisted == subject )
					blacklisted = null;
			}
			
		}
		
		private function onBallCollision():void {
			//trace( "BAM!", this, subject );
			
			var o:Image;
			o = new Image ( App.assets.getTexture( "o" ) );
			o.color = 0xFF1111;
			o.width =
			o.height = radius * 2.0;
			o.alignPivot();
			addChild( o );
			
			Starling.
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
		
		public function get color():uint {
			return img.color;
		}
		
		public function set color( value:uint ):void {
			img.color = value;
		}
		
	}

}