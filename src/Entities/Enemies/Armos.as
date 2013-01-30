package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	import Entities.Parents.Mover;
	import Entities.Player;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Armos extends Enemy
	{
		[Embed(source = '../../resources/images/armos_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../../resources/images/armos_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../../resources/images/armos_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		
		private var checkArea:int;
		private var beginChase:int;
		private var aliveTime:int;
		private var directionTime:int;
		
		public function Armos(x:int, y:int)
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 3.0;
			atkPow = 1;
			hp = 2;
			
			checkArea = 48;
			beginChase = 0;
			aliveTime = 0;
			directionTime = 0;
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
					ChasePlayer(entities[i]);
				}
			}
		}
		
		public function ChasePlayer(hero:Player):void
		{
			//Activate if within certain square radius of player
			if (CheckRectIntersect(hero, x+lb-checkArea, y+tb-checkArea, x+rb+checkArea, y+bb+checkArea)
				&& aliveTime <= 0)
			{
				beginChase = 10;
				aliveTime = 20 + Math.floor(Math.random()*40);
				directionTime = 4;
				
				currAniY = 1;
				SoundManager.getInstance().playSfx("AwakenSound", 0, 1);
			}
			
			//chase player down
			if (aliveTime > 0){
				aliveTime--;
					
				if (beginChase <= 0){
					if (directionTime > 0){
						directionTime--;
						vel = new Point(0, 0);
						if (facing == Global.UP) vel.y = -1*topspeed;
						else if (facing == Global.DOWN) vel.y = topspeed;
						else if (facing == Global.LEFT) vel.x = -1*topspeed;
						else if (facing == Global.RIGHT) vel.x = topspeed;
					}
					else{
						directionTime = 4;
						WhichFacing(hero);
						vel = new Point(0, 0);
					}
				}
				else{
					beginChase--;
					WhichFacing(hero);
				}
			}
			else{
				currAniY = 0;
				vel = new Point(0, 0);
				directionTime = 0;
			}
		}
		
		public function WhichFacing(hero:Player):void
		{
			//if the hero is closer vertically than horizontally
			if (Math.abs(hero.x-x)>Math.abs(hero.y-y)){
				if (hero.x > x) facing = Global.RIGHT;
				else facing = Global.LEFT;
			}
			else{
				if (hero.y > y) facing = Global.DOWN;
				else facing = Global.UP;
			}
		}
		
		override public function GetHurtByObject(object:Mover, dmg:Number = 1):void
		{
			if (aliveTime <= 0) return;
			hp -= dmg;
			if (hp > 0){
				SoundManager.getInstance().playSfx("HitSound", 0, 1);
				state = HURT_BOUNCE;
				hurt = 7;
				invincibility = 20;
				vel.x = 0;
				vel.y = 0;
				var ofacing:int = object.facing;
				if (ofacing == Global.LEFT || ofacing == Global.UPLEFT) vel.x = -6.0;
				else if (ofacing == Global.RIGHT || ofacing == Global.DOWNRIGHT) vel.x = 6.0;
				else if (ofacing == Global.UP || ofacing == Global.UPRIGHT) vel.y = -6.0;
				else if (ofacing == Global.DOWN || ofacing == Global.DOWNLEFT) vel.y = 6.0;
			}
			else{
				SoundManager.getInstance().playSfx("KillSound", 0, 1);
				delete_me = true;
			}
		}
		
		override public function UpdateAnimation():void
		{
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
	}
}