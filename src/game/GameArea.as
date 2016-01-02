package game 
{
	/**
	 * ...
	 * @author choephix
	 */
	public class GameArea 
	{
		private var _width:Number;
		private var _height:Number;
		
		public function GameArea( width:Number, height:Number ) 
		{
			this._width = width;
			this._height = height;
		}
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		
		public function get left():Number { return 0.0; }
		public function get top():Number { return 0.0; }
		public function get right():Number { return _width; }
		public function get bottom():Number { return _height; }
		
	}

}