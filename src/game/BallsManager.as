package game 
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import utils.Maath;
	
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
					if ( v[ j ].type == BallType.TARGET )
					{
						v[ i ].glall.alpha = 1.15 - ( Math.abs( v[ i ].x - v[ j ].x ) + Math.abs( v[ i ].y - v[ j ].y ) ) * .0033;
						v[ i ].glall.rotation = getAngle( v[ i ].x, v[ i ].y, v[ j ].x, v[ j ].y );
					}
						
					if ( checkForCollisionBetween( v[ i ], v[ j ] ) )
					{
						onCollisionBetween( v[ j ], v[ i ] );
						//onBallsCollision( v[ i ], v[ j ] );
					}
				}
			}
			
		}
		
		public function checkForCollisionBetween( b1:Ball, b2:Ball ):Boolean
		{
			//if ( getTimer() - b1.__lastCollision < 70 || getTimer() - b2.__lastCollision < 70 )
				//return false;
				
			///
			
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
		
		public function onCollisionBetween( b1:Ball, b2:Ball ):void
		{
			Game.current.layerDebug.clearTemp();
			
			if ( b1.isCorporeal && b2.isCorporeal )
			{
				if ( App.isDownCtrl && ( b1.type == BallType.PLAYER || b2.type == BallType.PLAYER ) )
				{
					Game.current.layerDebug.mark( b1.x, b1.y, 0x00FFFF );
					Game.current.layerDebug.mark( b2.x, b2.y, 0x00FFFF );
					Game.current.state = GameState.PAUSED;
				}
				
				bounceBall( b1, b2 );
				bounceBall( b2, b1 );
			
				var alpha:Number = getAngle( b1.position.x, b1.position.y, b2.position.x, b2.position.y );
				var midX:Number = Maath.lerp( b1.x, b2.x, .5 );
				var midY:Number = Maath.lerp( b1.y, b2.y, .5 );
				var s:SparksEffect;
				s = new SparksEffect( 0xFF0000 );
				s.x = midX;
				s.y = midY;
				s.rotation = alpha;
				spritesContainer.addChild( s );
				s.play();
			}
			
			b1.onBallCollision( b2 );
			b2.onBallCollision( b1 );
		}
		
		public function bounceBall( b1:Ball, b2:Ball ):void
		{
			b1.__lastCollision = getTimer();
			
			const R180:Number = Math.PI;
			const R90:Number = R180 * .5;
			
			var alpha:Number = getAngle( b1.position.x, b1.position.y, b2.position.x, b2.position.y );
			var fi:Number = getAngle( 0.0, 0.0, b1.getForce().x, b1.getForce().y );
			
			var fiPrime:Number = Math.PI + alpha;
			var epsilon:Number = NaN;
			
			var diff:Number = getAngleDiff( fi, alpha );
			
			if ( diff < .0 && diff > -R90 )
				fiPrime = 2.0 * alpha + R180 - fi;
			else
			if ( diff > .0 && diff < R90 )
				fiPrime = 2.0 * alpha - R180 - fi;
			
			var fLen:Number = b1.force.length ;
			var fX:Number = Math.cos( fiPrime ) * fLen;
			var fY:Number = Math.sin( fiPrime ) * fLen;
			
			b1.setForce( fX, fY );
			//b1.startMoving( fiPrime, b1.force.length / Ball.SPEED_MULTIPLIER );
			
			if ( App.isDownShift && b1.type == BallType.PLAYER )
			{
				const TIME:Number = NaN;
				Game.current.layerDebug.markBallAngle( b1, alpha, 0xFFFFFF, TIME );
				Game.current.layerDebug.markBallAngle( b1, fi, 0x0, TIME );
				Game.current.layerDebug.markBallAngle( b1, fiPrime, 0xFF8000, TIME );
				Game.current.state = GameState.PAUSED;
			}
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
			o.initialize();
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