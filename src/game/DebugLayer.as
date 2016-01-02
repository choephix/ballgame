package game 
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class DebugLayer extends DisplayObjectContainer 
	{
		private static const DOT_SIZE:Number = 4.0;
		
		private var analizer:GameArenaAnalizer;
		
		public var dots:Vector.<Quad>;
		
		public function initialize( analizer:GameArenaAnalizer ):void
		{
			this.analizer = analizer;
			dots = new Vector.<Quad>();
			
			var o:Quad;
			
			for ( var i:int = 0; i < analizer.dots.length; i++ ) 
			{
				o = new Quad( 1, 1 );
				o.color = 0x0;
				o.color = 0xFFFFFF;
				o.width = DOT_SIZE;
				o.height = DOT_SIZE;
				o.alignPivot();
				o.rotation = Math.PI * .25;
				
				o.x = analizer.dots[ i ].x;
				o.y = analizer.dots[ i ].y;
				
				o.alpha = analizer.dots[ i ].edgeDist;
				
				addChild( o );
				dots.push( o );
			}
		}
		
		public function update():void
		{
			var o:Quad;
			for ( var i:int = 0; i < analizer.dotsCount; i++ ) 
			{
				o = dots[ i ];
				//o.alpha = analizer.dots[ i ].edgeDist;
				//o.alpha = analizer.dots[ i ].playerHeat;
				//o.alpha = analizer.dots[ i ].enemyHeat;
				o.alpha = .05 + analizer.dots[ i ].temp;
			}
		}
		
	}

}