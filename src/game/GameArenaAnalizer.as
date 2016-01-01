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
		private var bounds:Rectangle;
		private var _helperPoint:Point;
		
		public function initialize( bounds:Rectangle, fidelityX:int=32, fidelityY:int=18 ):void
		{
			this.bounds = bounds;
			
			dots = new Vector.<GameArenaAnalizer_Point>();
			
			var ix:int;
			var iy:int;
			var o:GameArenaAnalizer_Point;
			
			for ( ix = 0; ix < fidelityX; ix++ ) 
			{
				for ( iy = 0; iy < fidelityY; iy++ ) 
				{
					o = new GameArenaAnalizer_Point();
					
					o.x = bounds.x + ( ix + .5 ) * bounds.width / fidelityX;
					o.y = bounds.y + ( iy + .5 ) * bounds.height / fidelityY;
					
					o.edgeDist = Math.pow( 1.0 - Math.max( Math.abs( 2.0 * o.x / bounds.width - 1.0 ), Math.abs( 2.0 * o.y / bounds.height - 1.0 ) ), 0.75 );
					
					dotsCount = dots.push( o );
				}
			}
			
			_helperPoint = new Point();
		}
		
		public function getPoint( ...rest ):GameArenaAnalizer_Point
		{
			return dots[ int( dotsCount * Math.random() ) ];
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
						dot.playerHeat += Math.pow( proximityManhattan( b, dot, 2560 ), 13.0 );
					}
					else
					if ( b.type == BallType.ENEMY )
					{
						dot.enemyHeat += Math.pow( proximityManhattan( b, dot, 2560 ), 13.0 );
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