package game
{
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EventDispatcher;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Ball extends EventDispatcher
	{
		private static var NEXT_UID:uint = 1;
		public static const SPEED_MULTIPLIER:Number = 2;
		
		public var uid:uint = 0;
		
		public var radius:Number;
		public var diameter:Number;
		
		public var mass:Number = 1;
		public var position:Point;
		public var force:Point;
		public var type:BallType;
		
		public var sprite:Sprite;
		private var imgShadow:Image;
		private var imgBody:Image;
		
		public var x:Number;
		public var y:Number;
		
		public var isDead:Boolean = false;
		
		public var __lastCollision:Number = 0.0;
		public var __v:Vector.<Ball> = new Vector.<Ball>();
		
		public function Ball( color:uint, radius:Number = 24.0 )
		{
			this.radius = radius;
			this.diameter = radius * 2.0;
			this.position = new Point();
			this.force = new Point();
			this.uid = NEXT_UID;
			NEXT_UID++;
			
			sprite = new Sprite();
			sprite.touchable = false;
			
			imgShadow = new Image ( App.assets.getTexture( "o" ) );
			imgShadow.width =
			imgShadow.height = radius * 2.0;
			imgShadow.alignPivot();
			imgShadow.y = 2.0;
			imgShadow.alpha = .40;
			imgShadow.color = 0x0;
			sprite.addChild( imgShadow );
			
			imgBody = new Image ( App.assets.getTexture( "o" ) );
			imgBody.color = color;
			imgBody.width =
			imgBody.height = radius * 2.0;
			imgBody.alignPivot();
			sprite.addChild( imgBody );
			
			//var t:TextField = new TextField( radius * 2.0, radius * 2.0, uid.toString() );
			//t.bold = true;
			//t.fontSize = 22.0;
			//t.color  = 0x7788aa;
			//t.color  = 0xAABBDD;
			//t.hAlign = HAlign.CENTER;
			//t.vAlign = VAlign.CENTER;
			//t.alignPivot();
			//addChild( t );
		}
		
		public function destroy():void
		{
			sprite.removeChildren( 0, -1, true );
			sprite.dispose();
			sprite = null;
			removeEventListeners();
		}
		
		public function startMoving( angle:Number, speed:Number ):void
		{
			speed *= SPEED_MULTIPLIER;
			setForce( Math.cos( angle ) * speed, -Math.sin( angle ) * speed );
		}
		
		public function setForce( x:Number, y:Number ):void
		{
			imgBody.rotation = Math.atan2( y, x );
			force.x = x;
			force.y = y;
		}
		
		public function getForce():Point
		{
			return force;
		}
		
		public function move( dx:Number, dy:Number ):void 
		{
			setPosition( position.x + dx, position.y + dy );
		}
		
		public function setPosition( x:Number, y:Number ):void
		{
			this.x = x;
			this.y = y;
			
			position.setTo( x, y );
			sprite.x = x;
			sprite.y = y;
		}
		
		public function onBallCollision( other:Ball ):void
		{
			//return;
			
			if ( type == BallType.PLAYER && other.type == BallType.ENEMY )
			{
				xplo( 0xFF1111, .000 );
				xplo( 0xFF1111, .100 );
				xplo( 0xFF1111, .200 );
				xplo( 0xFF1111, .300 );
				die();
			}
			
			else
			
			if ( type == BallType.TARGET && other.type == BallType.PLAYER )
			{
				xplo( 0xFFFFFF );
				die();
			}
			
			else
			
			if ( type == BallType.ENEMY )
			{
				xplo( 0xFF1111 );
			}
		}
		
		public function onEdgeCollision():void
		{
			xplo( 0xFF1111 );
		}
		
		public function die():void
		{
			isDead = true;
			dispatchEvent( new BallEvent( BallEvent.DEAD ) );
			sprite.removeFromParent();
		}
		
		//TODO onDestroyed()
		
		private function xplo( color:uint=0xFF1111, delay:Number=0.0 ):void
		{
			if ( !sprite.parent )
				return;
			
			var o:Image;
			o = new Image ( App.assets.getTexture( "o" ) );
			o.alpha = 0.85;
			o.color = color;
			o.width =
			o.height = radius * 2.0;
			o.alignPivot();
			
			o.scaleX = 0.0;
			o.scaleY = 0.0;
			o.x = position.x;
			o.y = position.y;
			sprite.parent.addChild( o );
			Starling.juggler.tween( o, .200, { 
				delay : delay, alpha : 0.0, scaleX : 2.0, scaleY : 2.0, 
				onComplete : o.removeFromParent, onCompleteArgs : [true] } );
		}
		
		public function toString():String
		{ return "B#"+uid.toString(); }
		
	}

}