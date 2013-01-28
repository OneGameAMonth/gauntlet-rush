package Entities 
{
	import Entities.Parents.LifeForm;
	import Entities.Parents.Mover;
	import Entities.Parents.Enemy;
	import Entities.Enemies.Bubble;
	import Entities.Parents.Projectile;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Player extends LifeForm
	{
		public var rest:int;
		public var rollRest:int;
		public var swordCharge:int;
		public var spinSword:int;
		public var noSwordCounter:int;
		
		public var lowHealthBeep:int;
		
		public static const SWORD_ATTACK:int = 2;
		public static const SPIN_SWORD_ATTACK:int = 3;
		public static const ROLL_ATTACK:int = 4;
		
		[Embed(source = '../resources/images/player_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../resources/images/player_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../resources/images/player_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		
		public function Player(x:int, y:int)
		{
			super(x, y, 2, 2, 14, 14);
			sprite_sheet = my_sprite_sheet;
			facing = Global.UP;
			
			rest = 0;
			rollRest = 0;
			swordCharge = 0;
			spinSword = 0;
			noSwordCounter = 0;
			lowHealthBeep = 0;
		}
		
		public function Restart(x:Number, y:Number, facing:int):void
		{
			this.x = x;
			this.y = y;
			this.facing = facing;
			
			Global.HP = Global.MAX_HP;
			
			rest = 0;
			rollRest = 0;
			swordCharge = 0;
			spinSword = 0;
			noSwordCounter = 0;
			state = NORMAL;
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
			
			var color:ColorTransform = new ColorTransform();
			if (noSwordCounter > 0){
				color.blueOffset = 255;
				color.redOffset = 0;
				color.greenOffset = 0;
			}
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix, color);
		}
		
		override public function Update(entities:Array, map:Array):void
		{		
			if (Global.HP <= Global.MAX_HP/2){ 
				lowHealthBeep -= 1;
				if (lowHealthBeep <= 0){
					lowHealthBeep = 25;
					SoundManager.getInstance().playSfx("LowHealthSound", 0, 1); 
				}
			}
			
			if (invincibility > 0) invincibility -= 1;
			InteractWithEntities(entities);
			UpdateMovement(entities, map);
			
			if (noSwordCounter > 0){
				noSwordCounter--;
				spinSword = 0;
				swordCharge = 0;
			}
			if (state == NORMAL && swordCharge == 0) 
				UpdateFacingWithVelocity();
			if (state == ROLL_ATTACK){
				if (hitSomething){
					SoundManager.getInstance().playSfx("ThudSound", 0, 1);
					state = NORMAL;
					rest = 5;
					vel.x = 0;
					vel.y = 0;
					currFrame = 0;
					frameCount = 0;
				}
			}if (state == SPIN_SWORD_ATTACK || spinSword > 0){
				if (spinSword < 40 || spinSword%3 == 0) NextFacing();
				if (spinSword <= 40 && spinSword%6 == 0) 
					SoundManager.getInstance().playSfx("SwordSound", 0, 1);
				spinSword++;
				if (spinSword == 40){
					state = NORMAL;
					rest = 40;
					vel.x = 0;
					vel.y = 0;
				}else if (spinSword >= 80){
					spinSword = 0;
				}
			}else CorrectFacing();
			
			if (hurt > 0){
				hurt--;
				if (hurt <= 0) state = NORMAL;
			}if (rest > 0) rest--;
			if (rollRest > 0){ 
				rollRest--;
				if (vel.x == 0 && vel.y == 0) rollRest = 0;
			}
			UpdateAnimation();
		}
		
		public function InteractWithEntities(entities:Array):void
		{
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is PlayerSword){
					if (entities[i].hitEnemy){
						SoundManager.getInstance().playSfx("ThudSound", 0, 1);
						if ((state != SWORD_ATTACK && state != SPIN_SWORD_ATTACK) || !(vel.x == 0 && vel.y == 0)){
							vel.x *= -0.5;
							vel.y *= -0.5;
							state = ROLL_ATTACK;
							currFrame = 1;
							frameCount = 0;
							swordCharge = 0;
							spinSword = 0;
							entities[i].x = x-16+vel.x;
							entities[i].y = y-16+vel.y;
							entities[i].delete_me = true;
						}else if (state == SWORD_ATTACK && vel.x == 0 && vel.y == 0){
							swordCharge = -1;
							entities[i].delete_me = true;
							rest = 10;
						}
					}
				}
				else if (entities[i] is Enemy && !(invincibility > 0 || hurt > 0)){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb)){
						if (entities[i].hurt <= 0 && entities[i].invincibility <= 0 && entities[i].visible){
							GetHurtByObject(entities[i], entities[i].atkPow);
						}
						break;
					}
				}else if (entities[i] is Projectile){
					TryToKillProjectile(entities[i]);
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb)
						&& !entities[i].delete_me && !(invincibility > 0 || hurt > 0)){
							GetHurtByObject(entities[i], entities[i].atkPow);
							entities[i].delete_me = true;
					}
				}
			}
		}
		
		public function TryToKillProjectile(p:Projectile):void
		{			
			var killProjectile:Boolean = false;
			if (state == NORMAL && p.canBeBlocked && swordCharge <= 0){
				if (facing == Global.RIGHT && (p.facing == Global.LEFT || p.facing == -1) &&
						CheckRectIntersect(p, x+rb, y+tb-12, x+rb+vel.x+2, y+bb+12))
					killProjectile = true;
				else if (facing == Global.LEFT && (p.facing == Global.RIGHT || p.facing == -1) &&
						CheckRectIntersect(p, x+lb+vel.x-2, y+tb-12, x+lb, y+bb+12))
					killProjectile = true;
				else if (facing == Global.UP && (p.facing == Global.DOWN || p.facing == -1) &&
						CheckRectIntersect(p, x+lb-12, y+tb+vel.y-2, x+rb+12, y+tb))
					killProjectile = true;
				else if (facing == Global.DOWN && (p.facing == Global.UP || p.facing == -1) &&
						CheckRectIntersect(p, x+lb-12, y+bb+2, x+rb+12, y+bb+vel.y))
					killProjectile = true;
			}
			
			if (killProjectile){
				p.delete_me = true;
				SoundManager.getInstance().playSfx("ShieldSound", 0, 1);
			}
		}
		
		override public function GetHurtByObject(object:Mover, dmg:Number = 1):void
		{
			Global.HP -= dmg;
			if (Global.HP > 0){
				SoundManager.getInstance().playSfx("HurtSound", 0, 1);
				state = HURT_BOUNCE;
				spinSword = 0;
				hurt = 7;
				invincibility = 40;
				swordCharge = 0;
				vel.x = 0;
				vel.y = 0;
				rest = 0;
				var ex:Number = object.x;
				var ey:Number = object.y;
				if (Math.abs(ex-x) > Math.abs(ey-y)){
					if (ex > x) vel.x = -topspeed * 2;
					else vel.x = topspeed * 2;
				}
				else{
					if (ey > y) vel.y = -topspeed * 2;
					else vel.y = topspeed * 2;
				}
				
				if (object is Bubble){
					noSwordCounter = 120;
				}
			}
			else{
				trace("Player has died!");
				SoundManager.getInstance().playSfx("DieSound", 0, 1);
			}
		}
		
		public function NextFacing():void
		{
			if (facing == Global.LEFT) facing = Global.UPLEFT;
			else if (facing == Global.UPLEFT) facing = Global.UP;
			else if (facing == Global.UP) facing = Global.UPRIGHT;
			else if (facing == Global.UPRIGHT) facing = Global.RIGHT;
			else if (facing == Global.RIGHT) facing = Global.DOWNRIGHT;
			else if (facing == Global.DOWNRIGHT) facing = Global.DOWN;
			else if (facing == Global.DOWN) facing = Global.DOWNLEFT;
			else if (facing == Global.DOWNLEFT) facing = Global.LEFT;
		}
		
		public function CorrectFacing():void
		{
			if (facing == Global.UPLEFT) facing = Global.LEFT;
			else if (facing == Global.UPRIGHT) facing = Global.UP;
			else if (facing == Global.DOWNRIGHT) facing = Global.RIGHT;
			else if (facing == Global.DOWNLEFT) facing = Global.DOWN;
		}
		
		override public function UpdateAnimation():void
		{
			if (facing == Global.UP) currAniY = 2;
			else if (facing == Global.DOWN) currAniY = 0;
			else if (facing == Global.LEFT) currAniY = 1;
			else if (facing == Global.RIGHT) currAniY = 3;
				
			if (state == NORMAL){ 
				currAniX = 0;
				if (swordCharge > 0) currAniX = 3
				maxFrame = 2;
				if (vel.x == 0 && vel.y == 0) frameDelay = 15;
				else frameDelay = 7;
			}else if (state == ROLL_ATTACK){ 
				currAniX = 5;
				maxFrame = 4;
				frameDelay = 3;
				rollRest = 5;
			}else if (state == SWORD_ATTACK){
				currAniX = 2;
				maxFrame = 1;
				frameDelay = 7;
			}else if (state == HURT_BOUNCE){
				currAniX = 0;
				maxFrame = 2;
				frameDelay = 3;
			}
			
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame){
					currFrame = 0;
					if (state == ROLL_ATTACK || state == SWORD_ATTACK) 
						state = NORMAL;
				}
				frameCount = 0;
			}
		}
	}
}