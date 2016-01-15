package game 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author choephix
	 */
	public class PlayerControl 
	{
		public var history:Vector.<Point>;
		
		static public const MAX_LEN:int = 24;
		
		private var __p:Point;
		
		public function PlayerControl() 
		{
			history = new Vector.<Point>();
			__p = new Point();
		}
		
		public function addStep( x:Number, y:Number ):void 
		{
			const DAMP:Number = .500;
			
			for each ( var item:Point in history ) 
			{
				item.x *= DAMP;
				item.y *= DAMP;
			}
			
			history.unshift( new Point( x, y ) );
			
			if ( history.length > MAX_LEN )
				history.length = MAX_LEN;
		}
		
		public function getTotal():Point
		{
			__p.setTo( .0, .0 );
			
			const MUL:Number = 1.0 / history.length;
			
			for each ( var item:Point in history ) 
			{
				__p.x += item.x * MUL;
				__p.y += item.y * MUL;
			}
			
			//__p.x = processTotalDimension( __p.x );
			//__p.y = processTotalDimension( __p.y );
			
			//__p.normalize( 10.0 + __p.length * .400 );
			__p.normalize( 5.0 );
			
			return __p;
		}
		
		private function processTotalDimension( value:Number ):Number 
		{
			return value;
			return Math.pow( Math.abs( value ) * .99, .50 ) * ( value > .0 ? 1.0 : -1.0 ) * 5.0;
		}
		
		public function clear():void 
		{
			history.length = 0;
		}
		
	}

}