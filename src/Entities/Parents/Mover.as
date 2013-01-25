package Entities.Parents 
{
	import flash.geom.Point;
	
	public class Mover extends GameSprite
	{
		public var topspeed:Number;
		public var vel:Point;
		public var facing:int;
		public var hitSomething:Boolean;
		
		public function Mover(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int)
		{
			super(x, y, lb, tb, rb, bb);
			topspeed = 3.0;
			vel = new Point(0, 0);
			facing = Global.DOWN;
			hitSomething = false;
		}
		
		public function UpdateMovement(entities:Array, map:Array, keepMoving:Boolean = false, diagonal:Boolean = false):void
		{
			var solids:Array = [];
			var i:int;
			for (i = 0; i < map.length; i++){
				for (var j:int = 0; j < map[i].length; j++){
					if (map[i][j].solid) solids.push(map[i][j]);
				}
			}for (i = 0; i < entities.length; i++){
				if (entities[i].solid) solids.push(entities[i]);
			}
			
			//Update movement
			if (solids.length > 0)
				CollideWithSolids(solids, keepMoving, diagonal);
			else{
				y += vel.y;
				if (vel.y == 0) x += vel.x;
			}
		}
		
		
		public function CollideWithSolids(solids:Array, keepMoving:Boolean, diagonal:Boolean):void
		{
			hitSomething = false;
			var i:int;
			for (i = 0; i < solids.length; i++){
				//vertical solid collisions (TOP)
				if (CheckRectIntersect(solids[i], x+lb, y+tb+vel.y, x+rb, y+tb)){
					if (keepMoving){ 
						vel.y *= -1;
						continue;
					}
					vel.y = 0;
					hitSomething = true;
					while (!CheckRectIntersect(solids[i], x+lb, y+tb-1, x+rb, y+tb))
						y--;
				}
				//vertical solid collisions (BOTTOM)
				if (CheckRectIntersect(solids[i], x+lb, y+bb, x+rb, y+bb+vel.y)){
					if (keepMoving){ 
						vel.y *= -1;
						continue;
					}
					vel.y = 0;
					hitSomething = true;
					while (!CheckRectIntersect(solids[i], x+lb, y+bb, x+rb, y+bb+1))
						y++;
				}
			}
			y += vel.y;
			
			if (vel.y != 0 && !diagonal) return;
			for (i = 0; i < solids.length; i++){
				//horizontal solid collisions (LEFT)
				if (CheckRectIntersect(solids[i], x+lb+vel.x, y+tb, x+lb, y+bb)){
					if (keepMoving){ 
						vel.x *= -1;
						continue;
					}
					vel.x = 0;
					hitSomething = true;
					while (!CheckRectIntersect(solids[i], x+lb-1, y+tb, x+lb, y+bb))
						x--;
				}
				//horizontal solid collisions (RIGHT)
				if (CheckRectIntersect(solids[i], x+rb, y+tb, x+rb+vel.x, y+bb)){
					if (keepMoving){ 
						vel.x *= -1;
						continue;
					}
					vel.x = 0;
					hitSomething = true;
					while (!CheckRectIntersect(solids[i], x+rb, y+tb, x+rb+1, y+bb))
						x++;
				}
			}
			x += vel.x;
		}
		
		public function UpdateFacingWithVelocity():void
		{
			if (vel.y > 0) facing = Global.DOWN;
			else if (vel.y < 0) facing = Global.UP;
			else if (vel.x > 0) facing = Global.RIGHT;
			else if (vel.x < 0) facing = Global.LEFT;
		}
		
		override public function UpdateAnimation():void
		{
			if (facing == Global.UP) currAniY = 2;
			else if (facing == Global.DOWN) currAniY = 0;
			else if (facing == Global.LEFT) currAniY = 1;
			else if (facing == Global.RIGHT) currAniY = 3;
			
			if (vel.x == 0 && vel.y == 0) frameDelay = 15;
			else frameDelay = 7;
			super.UpdateAnimation();
		}
	}
}