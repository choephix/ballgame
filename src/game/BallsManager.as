package game 
{
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import utils.Maath;
	/**
	 * ...
	 * @author choephix
	 */
	public class BallsManager 
	{
		private var v:Vector.<Ball>;
		private var vLen:int = 0;
		
		private var spritesContainer:DisplayObjectContainer;
		private var area:GameArea;
		
		public function initialize( spritesContainer:DisplayObjectContainer, area:GameArea ):void
		{
			this.spritesContainer = spritesContainer;
			this.area = area;	
			
			this.v = new Vector.<Ball>();
			this.vLen = 0;
		}
		
		public function advance( deltaTime:Number ):void
		{
			var i:int;
			var j:int;
			var b1:Ball;
			var b2:Ball;
			
			while ( i < vLen )
			{
				if ( v[ i ].isDead )
				{
					trace( "Destroying " + v[i] );
					v[ i ].destroy();
					v.splice( i, 1 );
					vLen--;
				}
				else
					i++;
			}
			
			for ( i = 0; i < vLen; i++)
			{
				b1 = v[ i ];
				
				// MOVE IT
				
				if ( area.width <= b1.radius * 2.0 )
					break;
					
				if ( area.height <= b1.radius * 2.0 )
					break;
				
				b1.move( deltaTime * b1.getForce().x, deltaTime * b1.getForce().y );
				
				// BOUNCE BOUNCE
				
				if ( b1.position.x <= area.left + b1.radius )
				{
					b1.setPosition( area.left + b1.radius, b1.position.y );
					b1.setForce( Math.abs( b1.getForce().x ), b1.getForce().y );
					b1.onEdgeCollision();
				}
				else
				if ( b1.position.x >= area.right - b1.radius )
				{
					b1.setPosition( area.right - b1.radius, b1.position.y );
					b1.setForce( -Math.abs( b1.getForce().x ), b1.getForce().y );
					b1.onEdgeCollision();
				}
				
				if ( b1.position.y <= area.top + b1.radius )
				{
					b1.setPosition( b1.position.x, area.top + b1.radius );
					b1.setForce( b1.getForce().x, Math.abs( b1.getForce().y ) );
					b1.onEdgeCollision();
				}
				else
				if ( b1.position.y >= area.bottom - b1.radius )
				{
					b1.setPosition( b1.position.x, area.bottom - b1.radius );
					b1.setForce( b1.getForce().x, -Math.abs( b1.getForce().y ) );
					b1.onEdgeCollision();
				}
				
				b1.__v.length = 0;
			}
			
			for ( i = 0; i < vLen; i++)
			{
				for ( j = i + 1; j < vLen; j++)
				{
					if ( checkForCollisionBetween( v[ i ], v[ j ] ) )
					{
						onBallsCollision( v[ j ], v[ i ] );
						//onBallsCollision( v[ i ], v[ j ] );
					}
				}
			}
			
		}
		
		public function checkForCollisionBetween( b1:Ball, b2:Ball ):Boolean
		{
			if ( b1.x - b1.radius > b2.x + b2.radius )
				return false;
			
			if ( b1.x + b1.radius < b2.x - b2.radius )
				return false;
			
			if ( b1.y - b1.radius > b2.y + b2.radius )
				return false;
			
			if ( b1.y + b1.radius < b2.y - b2.radius )
				return false;
			
			return true
			
			if ( ( b1.radius + b2.radius ) * ( b1.radius + b2.radius ) < ( b2.x - b1.x ) * ( b2.x - b1.x ) + ( b2.y - b1.y ) * ( b2.y - b1.y ) )
				return false;
				
			return true
		}
		
		public function onBallsCollision( b1:Ball, b2:Ball ):void
		{
			//if ( b1.type == BallType.PLAYER && b2.type == BallType.TARGET )
				//return;
			
			var radiusSum:Number = b1.radius + b2.radius;
			var radiusRatio1:Number = b1.radius / radiusSum;
			var radiusRatio2:Number = 1.0 - radiusRatio1;
				
			var midX:Number = Maath.lerp( b1.x, b2.x, radiusRatio1 );
			var midY:Number = Maath.lerp( b1.y, b2.y, radiusRatio1 );

			//var o:Quad = new Quad( 5, 5 );
			//o.x = midX;
			//o.y = midY;
			//o.alignPivot();
			//spritesContainer.addChild( o );
			//Starling.juggler.delayCall( o.removeFromParent, .045, true );
			
			bounceBall( b1, b2 );
			bounceBall( b2, b1 );
			
			const FIX:Number = 1.1;
			var fi:Number;
			fi = getAngle( b1.position.x, b1.position.y, b2.position.x, b2.position.y );
			b1.setPosition( midX - FIX * Math.cos( fi ) * b1.radius, midY - FIX * Math.sin( fi ) * b1.radius );
			b2.setPosition( midX + FIX * Math.cos( fi ) * b2.radius, midY + FIX * Math.sin( fi ) * b2.radius );
			
			//b1.onBallCollision( b2 );
			//b2.onBallCollision( b1 );
		}
		
		public function bounceBall( b1:Ball, b2:Ball ):void
		{
			const R180:Number = Math.PI;
			const R90:Number = R180 * .5;
			
			var alpha:Number = getAngle( b1.position.x, b1.position.y, b2.position.x, b2.position.y );
			var fi:Number = getAngle( 0.0, 0.0, b1.getForce().x, b1.getForce().y );
			
			var fiPrime:Number = alpha + Math.PI;
			var epsilon:Number = NaN;
			
			var diff:Number = getAngleDiff( fi, alpha );
			
			if ( diff < .0 && diff > -R90 )
			{
				epsilon = alpha + R90 - fi;
				fiPrime = fi + 2.0 * epsilon;
			}
			else
			if ( diff > .0 && diff < R90 )
			{
				epsilon = alpha - R90 + fi;
				fiPrime = fi + 2.0 * epsilon;
			}
			
			b1.startMoving( fiPrime, b1.force.length / Ball.SPEED_MULTIPLIER );
			
			const TIME:Number = 5.0;
			markBallAngle( b1, alpha, 0xFFFFFF, TIME );
			markBallAngle( b1, fi, 0x0, TIME );
			markBallAngle( b1, fiPrime, 0xFF8000, TIME );
			//Game.current.state = GameState.PAUSED;
		}
		
		private function markBallAngle( b:Ball, fi:Number, color:uint, time:Number = .033 ):void
		{
			var o:Quad = new Quad( 5, 5, color );
			o.x = b.x + Math.cos( fi ) * b.radius;
			o.y = b.y + Math.sin( fi ) * b.radius;
			o.alignPivot();
			spritesContainer.addChild( o );
			Starling.juggler.delayCall( o.removeFromParent, time, true );
		}
		
		private function getDotProduct( x1:Number, y1:Number, x2:Number, y2:Number ):Number
		{ return x1 * x2 + y1 * y2 }
		
		private function getAngle( x1:Number, y1:Number, x2:Number, y2:Number ):Number
		{ return Math.atan2( y2 - y1, x2 - x1 ); }
		
		private function getAngleDiff( a:Number, b:Number ):Number
		{ 
			var r:Number = a - b; 
			while (r < -Math.PI) r += 2*Math.PI;
			while (r > Math.PI) r -= 2*Math.PI;
			return -r;
		}
		///
		
		public function add( x:Number, y:Number, direction:Number, speed:Number, color:uint, type:BallType ):Ball
		{
			var o:Ball = new Ball( color );
			o.type = type;
			o.setPosition( x, y );
			o.startMoving( direction, speed * 50 );
			spritesContainer.addChild( o.sprite );
			vLen = v.push( o );
			return o;
		}
		
		public function purge():void 
		{
			for ( var i:int = 0; i < vLen; i++)
				v[ i ].destroy();
				
			vLen = v.length = 0;
			
			area = null;
			spritesContainer = null;
		}
		
		///
		
		public function getAll():Vector.<Ball> { return v }
		
	}

}