package game
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class BallEvent extends Event
	{
		/// Event type for a display object that is added to a parent.
		public static const DEAD:String = "dead";
		
		public function BallEvent( type:String, data:Object = null )
		{
			super( type, false, data );
		}
		
	}

}