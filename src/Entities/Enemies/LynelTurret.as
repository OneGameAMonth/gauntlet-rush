package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class LynelTurret extends Enemy
	{
		[Embed(source = '../../resources/images/lynel_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../../resources/images/lynel_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../../resources/images/lynel_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		
		private var randTimer:int;
		private var stopCounter:int;
		
		public function LynelTurret(x:int, y:int)
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 2.0;
			hp = 3;
			randTimer = 0;
			stopCounter = 0;
			atkPow = 1;
			
			currAniX = 2;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
			randTimer--;
			if (randTimer <= 0){
				vel.x = 0;
				vel.y = 0;
				stopCounter++;
				if (stopCounter >= 4){
					if (facing == Global.RIGHT) facing = Global.DOWN;
					else if (facing == Global.DOWN) facing = Global.LEFT;
					else if (facing == Global.LEFT) facing = Global.UP;
					else if (facing == Global.UP) facing = Global.RIGHT;
					entities.push(new MagicSword(x, y, facing));
					if (stopCounter >= 7){ 
						stopCounter = 0;
						randTimer = 32;
					}
					else randTimer = 4;
				}
				else{
					var rand:int = Math.floor(Math.random()*4);
					switch(rand){
						case 0: vel.x = topspeed;
							break;
						case 1: vel.x = -topspeed;
							break;
						case 2: vel.y = topspeed;
							break;
						case 3: vel.y = -topspeed;
							break;
						default: break;
					}
					randTimer = Math.floor(Math.random()*8)+8;
				}
			}
			if (state != HURT_BOUNCE) UpdateFacingWithVelocity();
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