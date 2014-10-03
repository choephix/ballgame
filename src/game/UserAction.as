package game {
	
	/**
	 * ...
	 * @author choephix
	 */
	public class UserAction {
		
		static public const SPLIT_VERTICAL:UserAction = new UserAction( "SPLIT_VERTICAL" );
		static public const SPLIT_HORISONTAL:UserAction = new UserAction( "SPLIT_HORISONTAL" );
		static public const ADD_BALL:UserAction = new UserAction( "ADD_BALL" );
		
		///
		
		public var name:String;
		public function UserAction( name:String ) {
			this.name = name;
		}
	
	}

}