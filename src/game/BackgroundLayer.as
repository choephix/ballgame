package game 
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class BackgroundLayer extends DisplayObjectContainer 
	{
		
		public function BackgroundLayer() 
		{
			super();
			addChild( new Quad( App.stage.stageWidth, App.stage.stageHeight, 0x333333 ) );
			addChild( new Quad( App.stage.stageWidth, 50, 0xEEEEEE ) );
		}
		
	}

}