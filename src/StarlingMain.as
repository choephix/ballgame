package {
	import game.Game;
	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class StarlingMain extends Sprite {
		
		private static const MINIMUM_SPLASH_TIME:Number = 1.0;
		
		private var startLoadingTime:Number;
		
		public function StarlingMain() {
			
			blendMode = BlendMode.NORMAL; //CHANGE TO NONE WHEN POSSIBLE
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		private function onAddedToStage( e:Event = null ):void {
			
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			trace( "3:Hello, Starling! " );
			
			/// INIT APP CLASS
			
			App.stage = stage;
			App.assets = new AssetManager();
			App.assets.enqueue( "assets/o.png" );
			App.assets.loadQueue( onAssetsLoadingProgress );
			
		}
		
		private function onAssetsLoadingProgress( ratio:Number ):void {
			
			trace( "Load progress: " + int( ratio * 100 ) + "%" );
			
			if ( ratio == 1.0 ) {
				onAssetsLoaded();
			}
			
		}
		
		private function onAssetsLoaded():void {
			
			/// INIT GAME
			
			var g:Game = new Game();
			g.start();
			
		}
	
	}

}