package game {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
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
		
		public var onDestroyedCallback:Function;
		
		private var arenaBounds:Rectangle;
		private var arena:DisplayObjectContainer;
		private var balls:Vector.<Ball>;
		private var ballsLen:int = 0;
		
		private var sections:Vector.<Section>;
		private var sectionsLen:int = 0;
		
		private var selectedAction:UserAction;
		
		private var layerSections:DisplayObjectContainer;
		private var layerDebug:DebugLayer;
		private var layerWalls:DisplayObjectContainer;
		private var layerBalls:DisplayObjectContainer;
		private var layerUI:DisplayObjectContainer;
		
		/// UI
		
		private var tAction:TextField;
		
		private var playerBall:Ball;
		private static var helperPoint:Point = new Point();
		
		private var state:GameState = GameState.WAITING;
		private var score:int = 0;
		private var analizer:GameArenaAnalizer;
		
		///
		
		public function Game() {
			
			arena = App.stage;
			
			sections = new Vector.<Section>();
			balls = new Vector.<Ball>();
			
			layerSections = new Sprite();
			layerDebug = new DebugLayer();
			layerWalls = new Sprite();
			layerBalls = new Sprite();
			layerUI = new Sprite();
			arena.addChild( layerSections );
			arena.addChild( layerDebug );
			arena.addChild( layerWalls );
			arena.addChild( layerBalls );
			arena.addChild( layerUI );
		}
		
		public function initialize():void {
			
			arenaBounds = createSection( 0, 50, App.stage.stageWidth, App.stage.stageHeight );
			
			analizer = new GameArenaAnalizer();
			analizer.initialize( arenaBounds );
			
			layerDebug.initialize( analizer );
			//layerDebug.x = arenaBounds.x;
			//layerDebug.y = arenaBounds.y;
			
			App.stage.addEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrame );
			App.stage.addEventListener( TouchEvent.TOUCH, onTouch );
			App.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			
			tAction = new TextField( 500, 100, "...", "Verdana", 32, 0xFFFFFF );
			tAction.vAlign = "top";
			layerUI.addChild( tAction );
			
			///
			
			//addNewBall( arenaBounds.width * 0.5, arenaBounds.height * 0.5, 0, 0 );
			//return;
			
			playerBall = addNewBall( .5 * arenaBounds.width, .5 * arenaBounds.height, .0, .0, 0x22CCFF, BallType.PLAYER );
				
			markThings();
			
			const INITIAL_ENEMY_POSITIONS:Array = [ 
													.2, .2,
													.8, .2,
													.5, .1,
													.2, .8,
													.8, .8,
													.5, .9,
													.5, .5
												  ];
			
			for ( var i:int = 0; i < 5; i++ ) 
			{
				addNewBall(
					arenaBounds.x + INITIAL_ENEMY_POSITIONS[ 2*i + 0 ] * arenaBounds.width,
					arenaBounds.y + INITIAL_ENEMY_POSITIONS[ 2*i + 1 ] * arenaBounds.height,
					Math.random() * Math.PI * 2.0,
					.44 * ( Math.random() + 1.0 ),
					//0.0,
					0xFF4444, BallType.ENEMY
					);
			}
			
			addNewBall(
				INITIAL_ENEMY_POSITIONS[ 2*5 + 0 ] * arenaBounds.width,
				INITIAL_ENEMY_POSITIONS[ 2*5 + 1 ] * arenaBounds.height,
				Math.random() * Math.PI * 2.0,
				2.0, 0xFF44FF, BallType.ENEMY
				);
			
			//spawnRegularEnemy();
			//spawnRegularEnemy();
			//spawnRegularEnemy();
			//spawnRegularEnemy();
			//spawnRegularEnemy();
			//spawnFastEnemy();
			
			spawnTarget();
		}
		
		private function destroy():void 
		{
			App.stage.removeEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrame );
			App.stage.removeEventListener( TouchEvent.TOUCH, onTouch );
			App.stage.removeEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			
			arenaBounds = null;
			
			layerSections.removeFromParent( true );
			layerSections = null;
			layerDebug.removeFromParent( true );
			layerDebug = null;
			layerWalls.removeFromParent( true );
			layerWalls = null;
			layerBalls.removeFromParent( true );
			layerBalls = null;
			layerUI.removeFromParent( true );
			layerUI = null;
			arena.removeFromParent( true );
			arena = null;
			
			balls.length = 0;
			balls = null;
			
			sections.length = 0;
			sections = null;
			
			selectedAction = null;
			
			tAction.removeFromParent( true );
			tAction = null;
			
			playerBall = null;
			state = null;
			
			onDestroyedCallback();
		}
		
		private function spawnTarget():void 
		{
			//HACK
			if ( arenaBounds == null )
				return;
			
			var p:GameArenaAnalizer_Point = analizer.getCenterishPoint( 0.0, -1.0, 0.0005 );
				
			addNewBall(
				p.x, p.y,
				Math.random() * Math.PI,
				0.2, 0xFFEE88, BallType.TARGET
				);
				
			markThings();
			
		}
		
		private function spawnRegularEnemy():Ball 
		{
			//HACK
			if ( arenaBounds == null )
				return null;
			
			var p:GameArenaAnalizer_Point = analizer.getCenterishPoint( -1.0, -1.0, 0.000125 );
				
			return addNewBall(
				p.x, p.y,
				Math.random() * Math.PI * 2.0,
				//.44 * ( Math.random() + 1.0 ),
				0.0,
				0xFF4444, BallType.ENEMY
				);
				
			markThings();
		}
		
		private function spawnFastEnemy():Ball 
		{
			//HACK
			if ( arenaBounds == null )
				return null;
			
			var p:GameArenaAnalizer_Point = analizer.getCenterishPoint( -1.0, -1.0, 0.000125 );
				
			return addNewBall(
				p.x, p.y,
				Math.random() * Math.PI * 2.0,
				2.0, 0xFF44FF, BallType.ENEMY
				);
				
			markThings();
		}
		
		///
		
		private function onEnterFrame( e:EnterFrameEvent ):void
		{
			if ( state == GameState.ONGOING )
			{
				var i:int;
				var j:int;
				for ( i = 0; i < ballsLen; i++) {
					with ( balls[ i ] ) {
						if ( stage == null ) 
							continue;
						loopUpdate( e.passedTime );
						for ( j = 0; j < ballsLen; j++) {
							if ( i == j ) 
								continue;
							checkForCollisionWithBall( balls[ j ] );
						}
					}
				}
				
				markThings();
			}
		}
		
		private function onTouch(e:TouchEvent):void {
			
			const SPD:Number = 2.5;
			
			var t:Touch;
			
			t = e.getTouch( App.stage, TouchPhase.BEGAN );
			if ( t != null )
			{
				playerBall.force.x *= 0.1;
				playerBall.force.y *= 0.1;
				
				if ( state == GameState.WAITING )
					start();
			}
			
			t = e.getTouch( App.stage, TouchPhase.MOVED );
			if ( t != null )
			{
				t.getMovement( App.stage, helperPoint );
				playerBall.force.x += helperPoint.x * SPD;
				playerBall.force.y += helperPoint.y * SPD;
			}
			
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			
			const a:Array = [ UserAction.SPLIT_VERTICAL, UserAction.SPLIT_HORISONTAL, UserAction.ADD_BALL ];
			
			if ( e.keyCode == Keyboard.SPACE ) {
				
				spawnRegularEnemy();
				return;
				
				if ( state == GameState.PAUSED || state == GameState.WAITING )
				{
					state = GameState.ONGOING;
					return;
				}
				
				if ( state != GameState.ONGOING )
				{
					return;
				}
				
				state = GameState.PAUSED
				
				//selectAction( a[ ( a.indexOf( selectedAction ) + 1 ) % a.length ] );
				
				markThings();
			}
			
		}
		
		private function markThings():void
		{
			analizer.update( balls );
			layerDebug.update();
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
		
		private function addNewBall( x:Number, y:Number, direction:Number, speed:Number, color:uint, type:BallType ):Ball {
			
			var o:Ball = new Ball();
			o.color = color;
			o.type = type;
			o.x = x;
			o.y = y;
			o.startMoving( direction, speed * 50 );
			layerBalls.addChild( o );
			balls.push( o );
			ballsLen++;
			updateBallSection( o );
			o.position.setTo( x, y );
			o.addEventListener( Event.REMOVED_FROM_STAGE, onBallDead );
			return o;
		}
		
		private function onBallDead( e:Event ):void
		{
			var ball:Ball = e.currentTarget as Ball;
			
			ball.removeEventListener(Event.REMOVED_FROM_STAGE, onBallDead);
			
			balls.splice( balls.indexOf( ball ), 1 );
			ballsLen--;
			
			if ( ball == playerBall )
				end();
			else
			if ( ball.type == BallType.TARGET )
			{
				tAction.text = (++score).toString();
				spawnTarget();
			}
		}
		
		/// GAMESTATE
		
		private function start():void
		{
			if ( state == GameState.ONGOING )
				return;
			
			state = GameState.ONGOING;
		}
		
		private function end():void
		{
			if ( state == GameState.FINISHED )
				return;
			
			state = GameState.FINISHED;
			
			Starling.juggler.delayCall( exit, 1.500 );
		}
		
		private function exit():void 
		{
			destroy();
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