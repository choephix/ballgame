package game 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author choephix
	 */
	public class GameArenaAnalizer 
	{
		public var dots:Vector.<GameArenaAnalizer_Point>;
		public var dotsCount:int;
		private var area:GameArea;
		private var _helperPoint:Point;
		private var _helperDot:GameArenaAnalizer_Point;
		
		public function initialize( area:GameArea, fidelityX:int=32, fidelityY:int=18 ):void
		{
			this.area = area;
			
			dots = new Vector.<GameArenaAnalizer_Point>();
			
			var ix:int;
			var iy:int;
			var o:GameArenaAnalizer_Point;
			
			for ( ix = 0; ix < fidelityX; ix++ ) 
			{
				for ( iy = 0; iy < fidelityY; iy++ ) 
				{
					o = new GameArenaAnalizer_Point();
					
					o.x =( ix + .5 ) * area.width / fidelityX;
					o.y =( iy + .5 ) * area.height / fidelityY;
					
					o.edgeDist = Math.pow( 1.0 - Math.max( Math.abs( 2.0 * o.x / area.width - 1.0 ), Math.abs( 2.0 * o.y / area.height - 1.0 ) ), 0.75 );
					
					dotsCount = dots.push( o );
				}
			}
			
			_helperPoint = new Point();
		}
		
		public function getPointRandom():GameArenaAnalizer_Point
		{
			return dots[ int( dotsCount * Math.random() ) ];
		}
		
		public function getCenterishPoint( enemyHeat:Number = 0.0, playerHeat:Number = 0.0, randomize:Number = 0.0 ):GameArenaAnalizer_Point
		{
			var currentPoint:GameArenaAnalizer_Point;
			var currentScore:Number;
			var bestPoint:GameArenaAnalizer_Point;
			var bestScore:Number;
			
			var i:int;
			var tempMin:Number = Number.MAX_VALUE;
			var tempMax:Number = -Number.MAX_VALUE;
			
			for ( i = 0; i < dotsCount; i++ ) 
			{
				currentPoint = dots[ i ];
				currentScore = currentPoint.edgeDist;
				currentScore = 0.0;
				
				currentScore += enemyHeat * currentPoint.enemyHeat;
				//currentScore += playerHeat * currentPoint.playerHeat;
				//currentScore += randomize * Math.random();
				currentScore += 0.01 * Math.random();
				
				if ( bestPoint == null || currentScore > bestScore )
				{
					bestPoint = currentPoint;
					bestScore = currentScore;
				}
				
				if ( currentScore > tempMax ) tempMax = currentScore;
				if ( currentScore < tempMin ) tempMin = currentScore;
				currentPoint.temp = currentScore;
				
				//trace( currentScore );
			}
			
			//trace( "- - - - - - - - - - - - - -" );
			
			for ( i = 0; i < dotsCount; i++ ) 
			{
				currentPoint = dots[ i ];
				currentPoint.temp = ( currentPoint.temp - tempMin ) / ( tempMax - tempMin );
			}
			
			return bestPoint;
		}
		
		public function getPointOppositeToPlayer():GameArenaAnalizer_Point
		{
			//_helperDot.x = bounds.width - player
			return null;
		}
		
		public function update( balls:Vector.<Ball> ):void 
		{
			var dst:Number;
			var str:Number;
			var dot:GameArenaAnalizer_Point;
			var b:Ball;
			
			for ( var i:int = 0; i < dotsCount; i++ ) 
			{
				dot = dots[ i ];
				_helperPoint.setTo( dot.x, dot.y );
				
				dot.enemyHeat = 0.0;
				dot.playerHeat = 0.0;
				
				for ( var ib:int = 0, len:int = balls.length; ib < len; ib++ )
				{
					b = balls[ ib ];
					if ( b.type == BallType.PLAYER )
					{
						//dot.playerHeat += Math.pow( proximityManhattan( b, dot, 2560 ), 13.0 );
						dot.playerHeat += Math.pow( proximityManhattan( b, dot, 600 ), 2.0 );
					}
					else
					if ( b.type == BallType.ENEMY )
					{
						//dot.enemyHeat += Math.pow( proximityManhattan( b, dot, 2560 ), 13.0 );
						dot.enemyHeat += Math.pow( proximityManhattan( b, dot, 100 ), 2.0 );
					}
				}
			}
			
		}
		
		private function proximityRadial( ball:Ball, dot:GameArenaAnalizer_Point, radius:Number ):Number
		{
			_helperPoint.setTo( ball.position.x - _helperPoint.x, ball.position.y - _helperPoint.y );
			return Math.max( 0.0, 1.0 - _helperPoint.length / radius );
		}
		
		private function proximityManhattan( ball:Ball, dot:GameArenaAnalizer_Point, max:Number ):Number
		{
			return Math.max( 0.0, 1.0 - ( Math.abs( ball.position.x - dot.x ) + Math.abs( ball.position.y - dot.y ) ) / max );
		}
		
	}

}