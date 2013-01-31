package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	import Entities.Parents.Mover;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Darknut extends Enemy
	{
		[Embed(source = '../../resources/images/darknut_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../../resources/images/darknut_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../../resources/images/darknut_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		
		private var randTimer:int;
		
		public function Darknut(x:int, y:int)
		{
			super(x, y, 1, 1, 15, 15);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 2.0;
			hp = 3;
			maxHP = 3;
			atkPow = 1;
			
			randTimer = 0;
			currAniX = 2;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
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
		
		override public function GetHurtByObject(object:Mover, dmg:Number = 1, invin:int = 0):void
		{
			if (CheckIfBlockSword(object)) return;
			hp -= 1;
			if (hp > 0){
				invincibility = 20;
				SoundManager.getInstance().playSfx("HitSound", 0, 1);
			}
			else{
				SoundManager.getInstance().playSfx("BossScream2Sound", 0, 1);
				delete_me = true;
			}
		}
		
		public function CheckIfBlockSword(sword:Mover):Boolean
		{
			var sx:int = 0;
			var sy:int = 0;
			if (sword.facing == Global.RIGHT || sword.facing == Global.DOWNRIGHT || sword.facing == Global.DOWNLEFT) sx = 8;
			else if (sword.facing == Global.LEFT || sword.facing == Global.UPLEFT || sword.facing == Global.UPRIGHT) sx = -8;
			if (sword.facing == Global.UP || sword.facing == Global.UPRIGHT || sword.facing == Global.UPLEFT) sy = -8;
			else if (sword.facing == Global.DOWN || sword.facing == Global.DOWNRIGHT || sword.facing == Global.DOWNLEFT) sy = 8;
			
			var killSword:Boolean = false;
			if (facing == Global.RIGHT && CheckRectIntersect(sword, x+rb+sx, y+tb, x+rb+vel.x+8, y+bb))
				killSword = true;
			else if (facing == Global.LEFT && CheckRectIntersect(sword, x+lb+vel.x-8, y+tb, x+lb+sx, y+bb))
				killSword = true;
			else if (facing == Global.UP && CheckRectIntersect(sword, x+lb, y+tb+vel.y-8, x+rb, y+tb+sy))
				killSword = true;
			else if (facing == Global.DOWN && CheckRectIntersect(sword, x+lb, y+bb+sy, x+rb, y+bb+vel.y+8))
				killSword = true;
			
			if (killSword){
				sword.hitSomething = true;
				SoundManager.getInstance().playSfx("ShieldSound", 0, 1);
				return true;
			}return false;
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
	}
}