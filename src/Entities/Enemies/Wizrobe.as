package Entities.Enemies 
{
	import Entities.Player;
	import Entities.Parents.Enemy;
	import Entities.Parents.Mover;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Wizrobe extends Enemy
	{
		[Embed(source = '../../resources/images/wizrobe_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../../resources/images/wizrobe_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../../resources/images/wizrobe_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		
		public var invisTimer:int;
		public var visTimer:int;
		public var visTimerMax:int;
		
		private var solidX:int;
		private var solidY:int;
		private var solidWidth:int;
		private var solidHeight:int;
		
		public function Wizrobe(x:int, y:int, solidX:int = -1, solidY:int = -1, solidWidth:int = -1, solidHeight:int = -1)
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 2.0;
			hp = 3;
			currAniX = 3;
			atkPow = 1;
			
			currAniX = 2;
			invisTimer = 0;
			visTimerMax = 40;
			visTimer = visTimerMax/2;
			
			this.solidX = solidX;
			this.solidY = solidY;
			this.solidWidth = solidWidth;
			this.solidHeight = solidHeight;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
			if (state != HURT_BOUNCE) UpdateFacingWithVelocity();
			if (!visible){
				invisTimer--;
				if (invisTimer == 18){
					for (var i:int = 0; i < entities.length; i++){
						if (entities[i] is Player) RandomFacingAndPos(entities[i]);
					}
				}
				if (invisTimer <= 0){
					visible = true;
					visTimer = visTimerMax;
				}
			}else{
				if (visTimer == visTimerMax) entities.push(new MagicBeam(x, y, facing));
				visTimer--;
				if (visTimer <= 0 || invincibility == 1){
					invisTimer = 60;
					visible = false;
				}
			}
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			if (invincibility <= 0){
				if (!visible){
					if ((invisTimer <= 3) || (invisTimer >= 5 && invisTimer <= 7) 
						|| (invisTimer >= 9 && invisTimer <= 12) || (invisTimer >= 15 && invisTimer <= 18)){}
					else return;
				}
				else if ((visTimer <= 3) || (visTimer >= 5 && visTimer <= 7) 
					|| (visTimer >= 9 && visTimer <= 12) || (visTimer >= 15 && visTimer <= 18)) return;
			}
			
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
		
		public function RandomFacingAndPos(player:Player):void
		{
			var rand:int = Math.floor(Math.random()*2);
			if (rand == 0){
				x = player.x;
				y = Math.floor(Math.random()*176)+32;
				if (solidHeight >= 0){
					while ((y > solidY-16 && y+bb < solidY+solidHeight+16) && (x > solidX-16 && x+rb < solidX+solidWidth+16)){
						y = Math.floor(Math.random()*176)+32;
					}
				}
				if (y > player.y) facing = Global.UP;
				else if (y < player.y) facing = Global.DOWN;
			}else if (rand == 1){
				y = player.y;
				x = Math.floor(Math.random()*256)+32;
				if (solidHeight >= 0){
					while ((y > solidY-16 && y+bb < solidY+solidHeight+16) && (x > solidX-16 && x+rb < solidX+solidWidth+16)){
						x = Math.floor(Math.random()*256)+32;
					}
				}
				if (x > player.x) facing = Global.LEFT;
				else if (x < player.x) facing = Global.RIGHT;
			}
		}
		
		override public function GetHurtByObject(object:Mover, dmg:Number = 1):void
		{
			if (!visible) return;
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
	}
}