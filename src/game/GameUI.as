package game 
{
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	import starling.text.TextField;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import utils.Maath;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class GameUI extends DisplayObjectContainer 
	{
		public var acc:Accelerometer;
		
		private var targetRotation:Number = 0.0;
		
		private var tScore:TextField;
		
		public function GameUI() 
		{
			super();
			
			var o:Image;
			o = new Image( App.assets.getTexture( "fakeui" ) );
			o.alignPivot();
			addChild( o );
			
			tScore = new TextField( o.width, .5 * o.height, "...", "sans" );
			tScore.fontSize = 96;
			tScore.color = 0x444455;
			tScore.hAlign = "center";
			tScore.vAlign = "center";
			tScore.alignPivot( "center", "bottom" );
			addChild( tScore );
			
			if ( Accelerometer.isSupported )
			{
				acc = new Accelerometer();
				acc.setRequestedUpdateInterval( 400 );
				acc.addEventListener( AccelerometerEvent.UPDATE, onAccelerometerUpdate );
				addEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrame );
			}
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		override public function dispose():void 
		{
			if ( acc != null ) {
				acc.removeEventListener( AccelerometerEvent.UPDATE, onAccelerometerUpdate );
				acc = null;
			}
			
			removeEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrame );
			
			super.dispose();
		}
		
		private function onAddedToStage( e:Event ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			this.x = .5 * App.stage.stageWidth;
			this.y = .5 * App.stage.stageHeight;
		}
		
		private function onEnterFrame( e:EnterFrameEvent ):void 
		{
			this.rotation = Maath.lerp( rotation, targetRotation, .35 );
		}
		
		private function onAccelerometerUpdate( e:AccelerometerEvent ):void 
		{
			if ( Math.abs( e.accelerationZ ) > .75 )
				return;
			
			var n:Number = e.accelerationX;
			
			n = n * ( 1.0 + 6.0 * Math.abs( e.accelerationZ ) );
			
			//n += ( n > 0.0 ? 1.0 : -1.0 ) * Math.pow( Math.abs( e.accelerationZ ), .50 );
			
			n = ( n > 1.0 ? 1.0 : ( n < -1.0 ? -1.0 : 0.0 ) );
			
			targetRotation = n * Math.PI * .5;
			
			DebugLayer.data = 
				"X " + e.accelerationX.toFixed(2) + 
				"\n" + 
				"Y " + e.accelerationY.toFixed(2) + 
				"\n" + 
				"Z " + e.accelerationZ.toFixed(2) + 
				"\n" + 
				"N " + n.toFixed(2);
		}
		
		public function setScore( value:int ):void
		{
			tScore.text = value.toString();
		}
		
	}

}