package game 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author choephix
	 */
	public class CollisionsOverlord 
	{
		
		public function CollisionsOverlord() 
		{
			
		}
		
		public function advance( deltaTime:Number, balls:Vector.<Ball>, area:GameArea ):void
		{
			var ballsLen:int = balls.length;
			var i:int;
			var j:int;
			var b1:Ball;
			var b2:Ball;
			
			for ( i = 0; i < ballsLen; i++)
			{
				b1 = balls[ i ];
				
				// ORIENT
				
				b1.rotation = Math.atan2( b1.force.y, b1.force.x );
				
				// MOVE IT
				
				if ( area.width <= b1.radius * 2.0 )
					break;
					
				if ( area.height <= b1.radius * 2.0 )
					break;
				
				b1.move( deltaTime * b1.force.x, deltaTime * b1.force.y );
				
				// BOUNCE BOUNCE
				
				if ( b1.x <= area.left + b1.radius )
				{
					b1.x = area.left + b1.radius;
					b1.force.x = Math.abs( b1.force.x );
					b1.onEdgeCollision();
				}
				else
				if ( b1.x >= area.right - b1.radius )
				{
					b1.x = area.right - b1.radius;
					b1.force.x = -Math.abs( b1.force.x );
					b1.onEdgeCollision();
				}
				
				if ( b1.y <= area.top + b1.radius )
				{
					b1.y = area.top + b1.radius;
					b1.force.y = Math.abs( b1.force.y );
					b1.onEdgeCollision();
				}
				else
				if ( b1.y >= area.bottom - b1.radius )
				{
					b1.y = area.bottom - b1.radius;
					b1.force.y = -Math.abs( b1.force.y );
					b1.onEdgeCollision();
				}
				
				b1.position.setTo( b1.x, b1.y );
			}
			
			try {
			
			for ( i = 0; i < ballsLen; i++) {
				
				b1 = balls[ i ];
				
				for ( j = 0; j < ballsLen; j++) {
					
					if ( i == j ) 
						continue;
						
					b1.checkForCollisionWithBall( balls[ j ] );
					
				}
				
			}
			
			}catch (e:Error) { }
			
		}
		
	}

}