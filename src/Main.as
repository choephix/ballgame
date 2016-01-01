package {
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author choephix
	 */
	
	//[SWF(width="960", height="640", backgroundColor="#000000", frameRate="60")]
	//[SWF(width="1136", height="640", backgroundColor="#000000", frameRate="60")]
	//[SWF(width="1024", height="768", backgroundColor="#000000", frameRate="60")]
	//[SWF(width="2048", height="1536", backgroundColor="#000000", frameRate="60")]
	//[SWF(width="1920", height="1080", backgroundColor="#000000", frameRate="60")]
	//[SWF(width="1280", height="800", backgroundColor="#000000", frameRate="60")]
	//[SWF(width="800",height="480",backgroundColor="#00000",frameRate="60")]
	//[SWF(width="400",height="240",backgroundColor="#00000",frameRate="60")]
	[SWF(width="1280", height="720", backgroundColor="#000000", frameRate="60")]
	public class Main extends Sprite {
		
		private var starling:Starling;
		private var initWidth:Number;
		private var initHeight:Number;
		private var mStage3D:Stage3D;
		
		public function Main():void {
			if ( stage )
				init();
			else
				addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( e:Event = null ):void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align 	= StageAlign.TOP_LEFT;
			stage.quality 	= StageQuality.LOW;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			var iOS:Boolean = Capabilities.manufacturer.indexOf( "iOS" ) != -1;
			
			Starling.multitouchEnabled = true; // useful on mobile devices
			Starling.handleLostContext = !iOS; // not necessary on iOS. Saves a lot of memory!
			
			mStage3D = stage.stage3Ds[0];
			
            mStage3D.addEventListener( Event.CONTEXT3D_CREATE, onContextCreated, false, 0, true );
			mStage3D.addEventListener( ErrorEvent.ERROR, onStage3DError );
            mStage3D.requestContext3D();
			
			initWidth = stage.stageWidth;
			initWidth = stage.stageHeight;
			
			stage.addEventListener(Event.DEACTIVATE, onDeactivated);
			stage.addEventListener(Event.ACTIVATE, onActivated);
			stage.addEventListener(Event.RESIZE, onResize);
			
		}
		
		private function onStage3DError( e:ErrorEvent ):void {
			
			trace( "3:Hello, error! " + e.text );
			
		}
		
        private function onContextCreated(event:Event):void {
			
			trace( "4:CONTEXT3D CREATED" );
			
			mStage3D.context3D.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, false );
			
			if ( !starling ) {
				
				initStarling();
				
			} else {
				
				stopStarling();
				
			}
			
        }

        private function initStarling():void {
			
			if ( starling ) {
				
				giantError( "Starling already exists!!" );
				return;
				
			}
			
			starling = new Starling( StarlingMain, stage, new Rectangle( 0, 0, 320, 480 ) );
			starling.addEventListener( "rootCreated", onStarlingReady );
			
			starling.antiAliasing = 0;
			starling.simulateMultitouch = true;
			
			//starling.showStatsAt("right", "top");

			initWidth = stage.stageWidth;
			initHeight = stage.stageHeight;
			
			onResize();
			
			stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		private function onStarlingReady( e:* = null) :void {
			
			starling.removeEventListener( "rootCreated", onStarlingReady );
			
			onResize();
			starling.start();
			
		}
		
		private function onEnterFrame(e:Event):void {
			
			if ( starling.isStarted && starling.context ) {
				
				//Tempo.onEnterAlternativeFrame();
				mStage3D.context3D.clear();
				starling.nextFrame();
				mStage3D.context3D.present();
				
			}
			
		}
		
		private function onResize(e:Event = null):void {
			
			if ( starling && mStage3D.context3D && stage ) {
			
				mStage3D.context3D.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, false );
				
				starling.viewPort.width = stage.stageWidth;
				starling.stage.stageWidth =	stage.stageWidth;
				
				starling.viewPort.height = stage.stageHeight;
				starling.stage.stageHeight = stage.stageHeight;
				
			}
		
		}
		
		private function onDeactivated( e:Event ):void {
			
			trace( "4:DEACTIVATED" );
			
			stopStarling();
			
		}
		
		private function onActivated( e:Event ):void {
			
			trace( "4:ACTIVATED" );
			
			resumeStarling();
			
		}
		
		private function resumeStarling():void {
			
			if ( !starling ) {
				
				return;
				
			}
			
			if ( starling.isStarted ) {
				
				return;
				
			}
			
			trace( "- - - > RESUMING STARLING < - - -" );
			
			if ( starling ) {
				
				starling.start();
				
			}
			
		}
		
		private function stopStarling():void {
			
			if ( starling ) {
				
				starling.stop();
				
			}
			
		}
		
		private function giantError( text:String ):void {
			
			var tf:TextField = new TextField();
			tf.y = Math.random() * 100;
			tf.scaleX = 4;
			tf.scaleY = 4;
			tf.width  = ( stage.stageWidth  >> 2 );
			tf.height = ( stage.stageHeight >> 2 ) - tf.y;
			tf.textColor = 0xEE2222;
			//tf.backgroundColor = 0x00000099;
			//tf.opaqueBackground = 0x00000000;
			tf.wordWrap = true;
			tf.text = text;
			addChild( tf );
			
		}
		
	}

}