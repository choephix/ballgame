package game 
{
	import flash.system.ImageDecodingPolicy;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
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
			
			var img:Image = new Image( App.assets.getTexture( "bg" ) );
			img.width  = App.stage.stageWidth;
			img.height = App.stage.stageHeight;
			addChild( img );
			
			//addChild( new Quad( App.stage.stageWidth, App.stage.stageHeight, 0x202429 ) );
		}
		
	}

}