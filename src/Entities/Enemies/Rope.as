package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	import Entities.Player;
	
	public class Rope extends Enemy
	{
		[Embed(source = '../../resources/images/rope_sheet.png')]
		private var my_sprite_sheet:Class;
		private var randTimer:int;
		private var stopChaseTimer:int;
		
		public function Rope(x:int, y:int) 
		{
			super(x, y, 1, 1, 15, 15);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 4.0;
			randTimer = 0;
			stopChaseTimer = 0;
			atkPow = 0.5;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player && entities[i].invincibility <= 0){
					var p:Player = entities[i];
					if ((p.y+p.tb > y && p.y+p.tb < y+bb) || (p.y+p.bb > y && p.y+p.bb < y+bb)){
						if (p.x > x+4){
							facing = Global.RIGHT;
							vel.x = topspeed;
						}else if (p.x < x-4){
							facing = Global.LEFT;
							vel.x = -topspeed;
						}else vel.x = 0;
						if (p.y > y){
							vel.y = topspeed;
						}else{
							vel.y = -topspeed;
						}
						//vel.y = 0;
						if (hitSomething) stopChaseTimer = 30;
						return;
					}
				}
			}
			
			randTimer--;
			if (randTimer <= 0){
				vel.x = 0;
				vel.y = 0;
				
				var rand:int = Math.floor(Math.random()*4);
				switch(rand){
					case 0: vel.x = topspeed/2;
						break;
					case 1: vel.x = -topspeed/2;
						break;
					case 2: vel.y = topspeed/2;
						break;
					case 3: vel.y = -topspeed/2;
						break;
					default: break;
				}
				randTimer = Math.floor(Math.random()*8)+8;
			}
			if (state != HURT_BOUNCE) UpdateFacingWithVelocity();
		}
		
		override public function UpdateMovement(entities:Array, map:Array, keepMoving:Boolean = false, diagonal:Boolean = false):void
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
				CollideWithSolids(solids, false, diagonal);
			else{
				x += vel.x;
				if (vel.x == 0) y += vel.y;
			}
		}
		
		
		override public function CollideWithSolids(solids:Array, keepMoving:Boolean, diagonal:Boolean):void
		{
			hitSomething = false;
			var i:int;			
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
			
			if (vel.x != 0) return;
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
		}
	}
}