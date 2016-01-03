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
		
		private var gameArea:GameArea;
		private var rootSprite:DisplayObjectContainer;
		private var balls:Vector.<Ball>;
		private var ballsLen:int = 0;
		
		private var layerBackground:BackgroundLayer;
		private var layerDebug:DebugLayer;
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
			
			rootSprite = App.stage;
			
			balls = new Vector.<Ball>();
			
			layerBackground = new BackgroundLayer();
			layerDebug = new DebugLayer();
			layerBalls = new Sprite();
			layerUI = new Sprite();
			rootSprite.addChild( layerBackground );
			rootSprite.addChild( layerDebug );
			rootSprite.addChild( layerBalls );
			rootSprite.addChild( layerUI );
		}
		
		public function initialize():void {
			
			gameArea = new GameArea( App.stage.stageWidth, App.stage.stageHeight - 50 );
			layerDebug.y = 50;
			layerBalls.y = 50;
			
			analizer = new GameArenaAnalizer();
			analizer.initialize( gameArea );
			layerDebug.initialize( analizer );
			
			tAction = new TextField( 500, 100, "...", "Verdana", 32, 0xFFFFFF );
			tAction.vAlign = "top";
			layerUI.addChild( tAction );
			
			App.stage.addEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrame );
			App.stage.addEventListener( TouchEvent.TOUCH, onTouch );
			App.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			
			///
			
			//addNewBall( arenaBounds.width * 0.5, arenaBounds.height * 0.5, 0, 0 );
			//return;
			
			playerBall = addNewBall( .5 * gameArea.width, .5 * gameArea.height, .0, .0, 0x22CCFF, BallType.PLAYER );
				
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
					INITIAL_ENEMY_POSITIONS[ 2*i + 0 ] * gameArea.width,
					INITIAL_ENEMY_POSITIONS[ 2*i + 1 ] * gameArea.height,
					Math.random() * Math.PI * 2.0,
					.44 * ( Math.random() + 1.0 ),
					//0.0,
					0xFF4444, BallType.ENEMY
					);
			}
			
			addNewBall(
				INITIAL_ENEMY_POSITIONS[ 2*5 + 0 ] * gameArea.width,
				INITIAL_ENEMY_POSITIONS[ 2*5 + 1 ] * gameArea.height,
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
			
			for ( var i:int = 0; i < ballsLen; i++)
				balls[ i ].removeEventListener( Event.REMOVED_FROM_STAGE, onBallDead );
			
			layerBackground.removeFromParent( true );
			layerBackground = null;
			layerDebug.removeFromParent( true );
			layerDebug = null;
			layerBalls.removeFromParent( true );
			layerBalls = null;
			layerUI.removeFromParent( true );
			layerUI = null;
			rootSprite.removeFromParent( true );
			rootSprite = null;
			
			balls.length = 0;
			balls = null;
			
			tAction.removeFromParent( true );
			tAction = null;
			
			playerBall = null;
			state = null;
			
			onDestroyedCallback();
		}
		
		private function spawnTarget():void 
		{
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
						loopUpdate( e.passedTime, gameArea );
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
			o.position.setTo( x, y );
			o.addEventListener( BallEvent.DEAD, onBallDead );
			return o;
		}
		
		private function onBallDead( e:Event ):void
		{
			var ball:Ball = e.currentTarget as Ball;
			
			ball.removeEventListener( BallEvent.DEAD, onBallDead);
			
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
		
	}

}