package game 
{
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class DebugLayer extends DisplayObjectContainer 
	{
		public static var data:String = "";
		
		private static const DOT_SIZE:Number = 4.0;
		
		private var analizer:GameArenaAnalizer;
		
		public var dots:Vector.<Quad>;
		
		public var temp:Sprite;
		
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
			
			temp = new Sprite();
			addChild( temp );
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
				//o.alpha = .05 + analizer.dots[ i ].temp;
				o.alpha = 0.0;
			}
		}
		
		public function mark( x:Number, y:Number, color:uint, time:Number = NaN ):void
		{
			//var o:Quad = new Quad( 4, 4, color );
			var o:Quad = new Image ( App.assets.getTexture( "o" ) );
			o.width  = 6.0;
			o.height = 6.0;
			o.color = color;
			o.x = x;
			o.y = y;
			o.alignPivot();
			temp.addChild( o );
			
			if ( !isNaN( time ) )
				Starling.juggler.delayCall( o.removeFromParent, time, true );
		}
		
		public function markBallAngle( b:Ball, fi:Number, color:uint, time:Number = NaN ):void
		{
			//var o:Quad = new Quad( 4, 4, color );
			var o:Quad = new Image ( App.assets.getTexture( "o" ) );
			o.width  = 6.0;
			o.height = 6.0;
			o.color = color;
			o.x = b.x + Math.cos( fi ) * ( b.radius );
			o.y = b.y + Math.sin( fi ) * ( b.radius );
			o.alignPivot();
			temp.addChild( o );
			
			if ( !isNaN( time ) )
				Starling.juggler.delayCall( o.removeFromParent, time, true );
		}
		
		public function clearTemp():void
		{
			temp.removeChildren( 0, -1, true );
		}
		
	}

}