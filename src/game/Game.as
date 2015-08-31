package game {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author choephix
	 */
	public class Game {
		
		private var arenaBounds:Rectangle;
		private var arena:DisplayObjectContainer;
		private var balls:Vector.<Ball>;
		private var ballsLen:int = 0;
		
		private var sections:Vector.<Section>;
		private var sectionsLen:int = 0;
		
		private var selectedAction:UserAction;
		
		private var layerSections:DisplayObjectContainer;
		private var layerWalls:DisplayObjectContainer;
		private var layerBalls:DisplayObjectContainer;
		private var layerUI:DisplayObjectContainer;
		
		/// UI
		
		private var tAction:TextField;
		
		private var me:Ball;
		private static var helperPoint:Point = new Point();
		
		///
		
		public function Game() {
			
			arena = App.stage;
			
			sections = new Vector.<Section>();
			balls = new Vector.<Ball>();
			
			layerSections = new Sprite();
			layerWalls = new Sprite();
			layerBalls = new Sprite();
			layerUI = new Sprite();
			arena.addChild( layerSections );
			arena.addChild( layerWalls );
			arena.addChild( layerBalls );
			arena.addChild( layerUI );
			
		}
		
		public function start():void {
			
			arenaBounds = createSection( 0, 50, App.stage.stageWidth, App.stage.stageHeight );
			
			tAction = new TextField( 500, 50, "...", "Verdana", 32, 0x2299FF );
			layerUI.addChild( tAction );
			
			App.stage.addEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrame );
			App.stage.addEventListener( TouchEvent.TOUCH, onTouch );
			App.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			
			selectAction( UserAction.SPLIT_VERTICAL );
			
			///
			
			//addNewBall( arenaBounds.width * 0.5, arenaBounds.height * 0.5, 0, 0 );
			//return;
			
			me = addNewBall( .5 * arenaBounds.width, .5 * arenaBounds.height, .0, .0, 0x22CCFF );
			
			addNewRandomBall();
			addNewRandomBall();
			addNewRandomBall();
			addNewRandomBall();
			addNewRandomBall();
			addNewRandomBall();
			addNewRandomBall();
			addNewRandomBall();
			
		}
		
		///
		
		private function onEnterFrame( e:EnterFrameEvent ):void {
			
			for (var i:int = 0; i < ballsLen; i++) {
				with ( balls[ i ] ) {
					if ( stage == null ) 
						continue;
					loopUpdate( e.passedTime );
					for (var j:int = 0; j < ballsLen; j++) {
						if ( i == j ) 
							continue;
						checkForCollisionWithBall( balls[ j ] );
					}
				}
			}
			
		}
		
		private function onTouch(e:TouchEvent):void {
			
			const SPD:Number = 2.5;
			
			var t:Touch;
			
			t = e.getTouch( App.stage, TouchPhase.BEGAN );
			if ( t != null )
			{
				me.force.x *= 0.1;
				me.force.y *= 0.1;
			}
			
			t = e.getTouch( App.stage, TouchPhase.MOVED );
			if ( t != null )
			{
				t.getMovement( App.stage, helperPoint );
				me.force.x += helperPoint.x * SPD;
				me.force.y += helperPoint.y * SPD;
			}
			
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			
			const a:Array = [ UserAction.SPLIT_VERTICAL, UserAction.SPLIT_HORISONTAL, UserAction.ADD_BALL ];
			
			if ( e.keyCode == Keyboard.SPACE ) {
				
				selectAction( a[ ( a.indexOf( selectedAction ) + 1 ) % a.length ] );
				
			}
			
		}
		
		private function onSectionTouched( section:Section, location:Point ):void {
			
			if ( selectedAction == UserAction.SPLIT_VERTICAL ) {
				createSection( section.left, section.top, location.x, section.bottom );
				createSection( location.x, section.top, section.right, section.bottom );
			} else 
			if ( selectedAction == UserAction.SPLIT_HORISONTAL ) {
				createSection( section.left, section.top, section.right, location.y );
				createSection( section.left, location.y, section.right, section.bottom );
			}
			
			removeSection( section );
			
			for (var i:int = 0; i < ballsLen; i++) {
				updateBallSection( balls[ i ] );
			}
			
		}
		
		/// SECTIONS
		
		private function createSection( left:Number, top:Number, right:Number, bottom:Number ):Section {
			
			var r:Section = new Section( left, top, right, bottom );
			sections.push( r );
			sectionsLen++;
			layerSections.addChild( r.quad );
			return r;
			
		}
		
		private function removeSection( section:Section ):void {
			
			sections.splice( sections.indexOf( section ), 1 );
			section.quad.removeFromParent( true );
			sectionsLen--;
			
		}
		
		/// BALLS
		
		private function addNewRandomBall():Ball {
			
			return addNewBall(
				arenaBounds.x + arenaBounds.width * Math.random(),
				arenaBounds.y + arenaBounds.height * Math.random(),
				Math.random() * Math.PI, 
				.44 * ( Math.random() + 1 ),
				0xFF4444
				);
		}
		
		private function addNewBall( x:Number, y:Number, direction:Number, speed:Number, color:uint ):Ball {
			
			var o:Ball = new Ball();
			o.color = color;
			o.x = x;
			o.y = y;
			o.startMoving( direction, speed * 50 );
			layerBalls.addChild( o );
			balls.push( o );
			ballsLen++;
			updateBallSection( o );
			o.addEventListener( Event.REMOVED_FROM_STAGE, onBallDead );
			return o;
		}
		
		private function onBallDead( e:Event ):void {
			
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, onBallDead);
			
			balls.splice( balls.indexOf( e.currentTarget as Ball ), 1 );
			ballsLen--;
			
		}
		
		private function updateBallSection( ball:Ball ):void {

			for (var i:int = 0; i < sectionsLen; i++) {
				if ( sections[ i ].contains( ball.x, ball.y ) ) {
					ball.section = sections[ i ];
					break;
				}
			}
			
		}
		
		///
		
		private function selectAction( a:UserAction ):void {
			
			selectedAction = a;
			tAction.text = a.name;
			
		}
		
	}

}