package game 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author choephix
	 */
	public class BallsManager 
	{
		
		public function BallsManager() 
		{
			
		}
		
		public function advance( deltaTime:Number, balls:Vector.<Ball>, area:GameArea ):void
		{
			var bLen:int;
			var i:int;
			var j:int;
			var b1:Ball;
			var b2:Ball;
			
			bLen = balls.length;
			
			while ( i < bLen )
			{
				if ( balls[ i ].isDead )
				{
					trace( "Destroying " + balls[i] );
					balls[ i ].destroy();
					balls.splice( i, 1 );
					bLen--;
				}
				else
					i++;
			}
			
			for ( i = 0; i < bLen; i++)
			{
				b1 = balls[ i ];
				
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
			}
			
			for ( i = 0; i < bLen; i++) {
				
				b1 = balls[ i ];
				
				for ( j = 0; j < bLen; j++) {
					
					if ( i == j ) 
						continue;
						
					b1.checkForCollisionWithBall( balls[ j ] );
					
				}
				
			}
			
		}
		
	}

}