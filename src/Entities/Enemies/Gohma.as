package Entities.Enemies 
{
	import Entities.Player;
	import Entities.Parents.Enemy;
	import Entities.Parents.Mover;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Gohma extends Enemy
	{
		[Embed(source = '../../resources/images/gohma_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../../resources/images/gohma_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../../resources/images/gohma_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		
		private var speed:Number;
		private var timer:int;
		public var fireCounter:int;
		
		public function Gohma(x:int, y:int)
		{
			super(x, y, 0, 0, 96, 32);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 96;
			frameHeight = 32;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 1.5;
			speed = topspeed;
			hp = 6;
			timer = 0;
			fireCounter = 10;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
			timer--;
			if (timer <= 0){
				speed *= -1;
				vel.x = speed;
				timer = 30;
			}
			
			fireCounter--;
			if (fireCounter <= 0){
				fireCounter = Math.floor(Math.random()*20)+80;
				for (var i:int = 0; i < entities.length; i++){
					if (entities[i] is Player && entities[i].y > y+bb){
						SoundManager.getInstance().playSfx("BombBlowSound", 0, 1);
						entities.push(new Fireball(x+32, y+8, entities[i].x, entities[i].y, 2));
						return;
					}
				}
			}
		}
		
		override public function GetHurtByObject(object:Mover, dmg:Number = 1):void
		{
			if (object.x < x+16 || object.x > x+rb-54 || object.y < y+8) return;
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