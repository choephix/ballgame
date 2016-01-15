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
		
		public function SparksEffect( clr:uint ) 
		{
			var o:Image;
			
			o = new Image( App.assets.getTexture( "spot") );
			o.color = clr;
			o.alignPivot();
			o.alpha = .2730;
			o.scaleX = o.scaleY = 9.5;
			addChild( o );
			
			o = new Image( App.assets.getTexture( "spark") );
			//o.color = clr;
			o.alignPivot();
			addChild( o );
			
			o = new Image( App.assets.getTexture( "spark") );
			//o.color = clr;
			o.alignPivot();
			addChild( o );
			o.scaleX = o.scaleY = .5;
			o.rotation = ( .100 +.300 * Math.random() );
			
			o = new Image( App.assets.getTexture( "spark") );
			//o.color = clr;
			o.alignPivot();
			addChild( o );
			o.scaleX = o.scaleY = .5;
			o.rotation = -(.100 +.300 * Math.random() );
			
			o = new Image( App.assets.getTexture( "wave") );
			o.color = clr;
			o.alignPivot();
			addChild( o );
			o.scaleX = o.scaleY = .5;
		}
		
		public function play():void
		{
			const TIME:Number = .290;
			
			var o:DisplayObject;
			for ( var i:int = 1; i < numChildren - 1; i++ ) 
			{
				o = getChildAt( i );
				Starling.juggler.tween( o, TIME, { scaleX : .010, scaleY : o.scaleY * 2.0, alpha : .0 , transition : Transitions.EASE_OUT } );
			}
			
			o = getChildAt( 0 );
			Starling.juggler.tween( o, TIME, { alpha : .0 } );
			
			o = getChildAt( numChildren - 1 );
			o.alpha = .40;
			o.scaleX = .2;
			o.scaleY = .2;
			Starling.juggler.tween( o, .440, { alpha : .0, scaleX : 5.0, scaleY : 5.0, transition : Transitions.LINEAR } );
			parent.addChild( o );
			o.x = x;
			o.y = y;
			o.rotation = rotation + Math.PI * .5;
			
			Starling.juggler.delayCall( removeFromParent, TIME + .100, true );
		}
		
	}

}