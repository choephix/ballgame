package game 
{
	/**
	 * ...
	 * @author choephix
	 */
	public class GameState 
	{
		public static const WAITING:GameState = new GameState("waiting");
		public static const ONGOING:GameState = new GameState("ongoing");
		public static const PAUSED:GameState = new GameState("paused");
		public static const FINISHED:GameState = new GameState("finito");
		
		///
		
		private var name:String;	
		public function GameState( name:String ) { this.name = name; }
	}

}