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
		
		public function advance( deltaTime:Number, balls:Vector.<Ball>, bounds:Rectangle ):void
		{
			var ballsLen:int = balls.length;
			var i:int;
			var j:int;
			var b1:Ball;
			var b2:Ball;
			
			for ( i = 0; i < ballsLen; i++) {
				
				b1 = balls[ i ];
				b1.loopUpdate( e.passedTime );
				
				
				
				with ( balls[ i ] ) {
					if ( stage == null ) 
						continue;
					loopUpdate( e.passedTime );
					for ( j = 0; j < ballsLen; j++) {
						if ( i == j ) 
							continue;
						checkForCollisionWithBall( balls[ j ] );
					}
				}
				
			}
			
			markThings();
		}
		
	}

}