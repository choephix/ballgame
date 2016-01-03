package game 
{
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	/**
	 * ...
	 * @author choephix
	 */
	public class BallsManager 
	{
		private var v:Vector.<Ball>;
		private var vLen:int = 0;
		
		private var spritesContainer:DisplayObjectContainer;
		private var area:GameArea;
		
		public function initialize( spritesContainer:DisplayObjectContainer, area:GameArea ):void
		{
			this.spritesContainer = spritesContainer;
			this.area = area;	
			
			this.v = new Vector.<Ball>();
			this.vLen = 0;
		}
		
		public function advance( deltaTime:Number ):void
		{
			var i:int;
			var j:int;
			var b1:Ball;
			var b2:Ball;
			
			while ( i < vLen )
			{
				if ( v[ i ].isDead )
				{
					trace( "Destroying " + v[i] );
					v[ i ].destroy();
					v.splice( i, 1 );
					vLen--;
				}
				else
					i++;
			}
			
			for ( i = 0; i < vLen; i++)
			{
				b1 = v[ i ];
				
				// MOVE IT
				
				if ( area.width <= b1.radius * 2.0 )
					break;
					
				if ( area.height <= b1.radius * 2.0 )
					break;
				
				b1.move( deltaTime * b1.getForce().x, deltaTime * b1.getForce().y );
				
				// BOUNCE BOUNCE
				
				if ( b1.position.x <= area.left + b1.radius )
				{
					b1.setPosition( area.left + b1.radius, b1.position.y );
					b1.setForce( Math.abs( b1.getForce().x ), b1.getForce().y );
					b1.onEdgeCollision();
				}
				else
				if ( b1.position.x >= area.right - b1.radius )
				{
					b1.setPosition( area.right - b1.radius, b1.position.y );
					b1.setForce( -Math.abs( b1.getForce().x ), b1.getForce().y );
					b1.onEdgeCollision();
				}
				
				if ( b1.position.y <= area.top + b1.radius )
				{
					b1.setPosition( b1.position.x, area.top + b1.radius );
					b1.setForce( b1.getForce().x, Math.abs( b1.getForce().y ) );
					b1.onEdgeCollision();
				}
				else
				if ( b1.position.y >= area.bottom - b1.radius )
				{
					b1.setPosition( b1.position.x, area.bottom - b1.radius );
					b1.setForce( b1.getForce().x, -Math.abs( b1.getForce().y ) );
					b1.onEdgeCollision();
				}
			}
			
			for ( i = 0; i < vLen; i++) {
				
				b1 = v[ i ];
				
				for ( j = 0; j < vLen; j++) {
					
					if ( i == j ) 
						continue;
						
					b1.checkForCollisionWithBall( v[ j ] );
					
				}
				
			}
			
		}
		
		public function add( x:Number, y:Number, direction:Number, speed:Number, color:uint, type:BallType ):Ball
		{
			var o:Ball = new Ball( color );
			o.type = type;
			o.setPosition( x, y );
			o.startMoving( direction, speed * 50 );
			spritesContainer.addChild( o.sprite );
			vLen = v.push( o );
			return o;
		}
		
		public function purge():void 
		{
			for ( var i:int = 0; i < vLen; i++)
				v[ i ].destroy();
				
			vLen = v.length = 0;
			
			area = null;
			spritesContainer = null;
		}
		
		///
		
		public function getAll():Vector.<Ball> { return v }
		
	}

}