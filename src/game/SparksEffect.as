package game 
{
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class SparksEffect extends DisplayObjectContainer 
	{
		
		public function SparksEffect() 
		{
			var o:Image;
			
			o = new Image( App.assets.getTexture( "spot") );
			o.alignPivot();
			o.alpha = .2730;
			o.scaleX = o.scaleY = 4.5;
			addChild( o );
			
			o = new Image( App.assets.getTexture( "spark") );
			o.alignPivot();
			addChild( o );
			
			o = new Image( App.assets.getTexture( "spark") );
			o.alignPivot();
			addChild( o );
			o.scaleX = o.scaleY = .5;
			o.rotation = ( .100 +.300 * Math.random() );
			
			o = new Image( App.assets.getTexture( "spark") );
			o.alignPivot();
			addChild( o );
			o.scaleX = o.scaleY = .5;
			o.rotation = -(.100 +.300 * Math.random() );
		}
		
		public function play():void
		{
			const TIME:Number = .290;
			var o:DisplayObject;
			for ( var i:int = 1; i < numChildren; i++ ) 
			{
				o = getChildAt( i );
				Starling.juggler.tween( o, TIME, { scaleX : .010, scaleY : o.scaleY * 2.0, alpha : .0 , transition : Transitions.EASE_OUT } );
			}
			Starling.juggler.tween( getChildAt(0), TIME, { alpha : .0 } );
			Starling.juggler.delayCall( removeFromParent, TIME + .100, true );
		}
		
	}

}