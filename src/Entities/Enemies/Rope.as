package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	import Entities.Player;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Rope extends Enemy
	{
		[Embed(source = '../../resources/images/rope_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../../resources/images/rope_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../../resources/images/rope_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		private var randTimer:int;
		private var stopChaseTimer:int;
		
		public function Rope(x:int, y:int, currAniX:int = 0) 
		{
			super(x, y, 1, 1, 15, 15);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 4.0;
			randTimer = 0;
			stopChaseTimer = 0;
			
			this.currAniX = currAniX;
			if (currAniX > 0){
				atkPow = 1;
				hp = 2;
				maxHP = 2;
			}
			else atkPow = 0.5;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			if (!visible) return;
			
			sprite_sheet = my_sprite_sheet;
			if (invincibility > 0){
				if ((invincibility >= 4 && invincibility <= 8) || (invincibility >= 12 && invincibility <= 16) || 
					(invincibility >= 20 && invincibility <= 24) || (invincibility >= 28 && invincibility <= 32) || 
					(invincibility >= 36 && invincibility <= 40))
					sprite_sheet = hurt2_sprite_sheet;
				else sprite_sheet = hurt_sprite_sheet;
			}
			
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			DrawSpriteFromSheet(temp_image, temp_sheet);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix);
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