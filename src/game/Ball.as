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
		public static const SPEED_MULTIPLIER:Number = 6.5;
		
		public var uid:uint = 0;
		
		public var radius:Number;
		public var diameter:Number;
		
		public var mass:Number = 1;
		public var position:Point;
		public var force:Point;
		public var type:BallType;
		
		public var sprite:Sprite;
		public var glall:Image;
		private var imgBody:Image;
		
		public var x:Number;
		public var y:Number;
		
		public var isDead:Boolean = false;
		
		public var __lastCollision:Number = 0.0;
		public var __v:Vector.<Ball> = new Vector.<Ball>();
		
		public var isCorporeal:Boolean;
		
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
			
			imgBody = new Image ( App.assets.getTexture( "o" ) );
			imgBody.blendMode = "add";
			imgBody.color = color;
			imgBody.width =
			imgBody.height = radius * 4.0;
			imgBody.alignPivot();
			sprite.addChild( imgBody );
			
			glall = new Image ( App.assets.getTexture( "glall" ) );
			glall.blendMode = "add";
			glall.width =
			glall.height = radius * 4.0;
			glall.alignPivot();
			sprite.addChild( glall );
			glall.alpha = 0.0;
			
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
		
		public function initialize():void 
		{
			if ( type == BallType.TARGET )
			{
				function generateGlow( scale:Number, color:uint, spinSpeed:Number ):Image
				{
					var rotation:Number = spinSpeed > 0 ? Math.PI * 2.0 : -Math.PI * 2.0;
					var spinTime:Number = 60.0 / Math.abs( spinSpeed );
					var glow:Image = new Image ( App.assets.getTexture( "rays-large-dark" ) );
					glow.alignPivot();
					glow.scaleX = 
					glow.scaleY = scale;
					glow.color = color;
					glow.blendMode = "add";
					glow.rotation = spinSpeed * Math.PI * 2.0;
					sprite.addChild( glow );
					Starling.juggler.tween( glow, spinTime, { rotation : glow.rotation + rotation, repeatCount : 0 } );
					return glow;
				}
				
				generateGlow( 1.0, 0x22DDFF, -.94 );
				generateGlow( 1.0, 0x22DDFF, 1.41 );
				
				generateGlow( 5.0, 0x0E15B8, -.94 );
				generateGlow( 5.0, 0x0E15B8, 1.41 );
				
				imgBody.scaleX *= .25;
				imgBody.scaleY *= .25;
			}
			
			isCorporeal = type != BallType.TARGET;
		}
		
		public function destroy():void
		{
			sprite.removeChildren( 0, -1, true );
			sprite.dispose();
			sprite = null;
			imgBody = null;
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
			
			if ( type == BallType.ENEMY && other.type == BallType.ENEMY )
			{
				//xplo( 0xFF1111 );
			}
			
			else
			
			if ( type == BallType.TARGET && other.type == BallType.PLAYER )
			{
				die();
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
			//if ( !sprite.parent )
				//return;
			
			var o:Image;
			o = new Image ( App.assets.getTexture( "o" ) );
			o.blendMode = "add";
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
		
		public function anim_OnGetTarget():void 
		{
			if ( !sprite.parent )
				return;
			
			var o:Image;
			o = new Image ( App.assets.getTexture( "score-up-glow" ) );
			o.width =
			o.height = radius * 6.0;
			o.alignPivot();
			o.blendMode = "add";
			
			sprite.addChild( o );
			Starling.juggler.tween( o, .440, { 
				alpha : 0.0,
				onComplete : o.removeFromParent, 
				onCompleteArgs : [true] } );
		}
		
	}

}