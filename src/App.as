package
{
	import starling.display.Stage;
	import starling.events.KeyboardEvent;
	import starling.utils.AssetManager;
	
	public class App
	{
		public static var stage:Stage;
		public static var assets:AssetManager;
		
		public static var isDownShift:Boolean;
		public static var isDownCtrl:Boolean;
		public static var isDownAlt:Boolean;
		
		static public function initialize():void
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		}
		
		static private function onKeyUp( e:KeyboardEvent ):void
		{
			isDownShift = e.shiftKey;
			isDownCtrl = e.ctrlKey;
			isDownAlt = e.altKey;
		}
		
		static private function onKeyDown( e:KeyboardEvent ):void
		{
			isDownShift = e.shiftKey;
			isDownCtrl = e.ctrlKey;
			isDownAlt = e.altKey;
		}
	
	}

}