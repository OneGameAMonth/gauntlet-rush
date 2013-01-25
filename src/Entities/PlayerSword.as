package Entities 
{
	import Entities.Parents.Mover;
	import Entities.Parents.Enemy;
	import Entities.Parents.Projectile;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class PlayerSword extends Mover
	{
		[Embed(source = '../resources/images/sword_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public var hitEnemy:Boolean;
		
		public function PlayerSword(x:Number, y:Number, facing:int) 
		{
			super(x, y, 0, 0, 0, 0);
			frameWidth = 48;
			frameHeight = 48;
			frameDelay = 3;
			sprite_sheet = my_sprite_sheet;
			this.facing = facing;
			solid = false;
			
			hitEnemy = false;
			SetFacing();
		}

		override public function Update(entities:Array, map:Array):void
		{
			//Doing it like this is only okay because the player is always
			//at a lower index than the enemies in our entity arrays
			hitEnemy = false;
			for (var i:int = 0; i < entities.length; i++){
				if (getQualifiedClassName(entities[i]) == "Entities::Player"){
					if (entities[i].swordCharge <= 0 && entities[i].state != Player.SPIN_SWORD_ATTACK){
						delete_me = true;
						return;
					}else{
						var addx:int = 0, addy:int = 0;
						addy = entities[i].vel.y;
						if (entities[i].vel.y == 0) 
							addx = entities[i].vel.x;
						x = entities[i].x-16+addx;
						y = entities[i].y-16+addy;
						facing = entities[i].facing;
						SetFacing();
						if (entities[i].swordCharge >= 15) maxFrame = 2;
						else maxFrame = 1;
					}
				}else if (entities[i] is Enemy && entities[i].canBeHurt){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb) && 
							entities[i].invincibility <= 0){
						entities[i].GetHurtByObject(this);
						if (entities[i].hp > 0) hitEnemy = true;
					}
				}else if (entities[i] is Projectile){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb))
						entities.delete_me = true;
				}
			}
			
			UpdateAnimation();
		}
		
		override public function UpdateAnimation():void
		{
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
		
		public function SetFacing():void
		{
			if (facing == Global.DOWN){
				lb = 21;
				tb = 33;
				rb = 27;
				bb = 42;
				currAniY = 0;
			}else if (facing == Global.DOWNLEFT){
				lb = 10;
				tb = 25;
				rb = 24;
				bb = 39;
				currAniY = 1;
			}else if (facing == Global.LEFT){
				lb = 5;
				tb = 22;
				rb = 14;
				bb = 28;
				currAniY = 2;
			}else if (facing == Global.UPLEFT){
				lb = 10;
				tb = 10;
				rb = 24;
				bb = 24;
				currAniY = 3;
			}else if (facing == Global.UP){
				lb = 21;
				tb = 5;
				rb = 27;
				bb = 14;
				currAniY = 4;
			}else if (facing == Global.UPRIGHT){
				lb = 25;
				tb = 10;
				rb = 39;
				bb = 24;
				currAniY = 5;
			}else if (facing == Global.RIGHT){
				lb = 33;
				tb = 22;
				rb = 42;
				bb = 28;
				currAniY = 6;
			}else if (facing == Global.DOWNRIGHT){
				lb = 25;
				tb = 25;
				rb = 39;
				bb = 39;
				currAniY = 7;
			}
		}
	}
}