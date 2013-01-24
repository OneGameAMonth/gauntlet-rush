package Entities 
{
	import Entities.Parents.Mover;
	import Entities.Parents.Enemy;
	import Entities.Parents.Projectile;
	
	public class Player extends Mover
	{
		public var hp:Number;
		public var hurt:int;
		public var invincibility:int;
		public var rest:int;
		public var rollRest:int;
		
		public var state:int;
		public const NORMAL:int = 0;
		public const SWORD_ATTACK:int = 1;
		public const ROLL_ATTACK:int = 2;
		public const HURT_BOUNCE:int = 3;
		
		[Embed(source = '../resources/images/player_sheet.png')]
		private var my_sprite_sheet:Class;
		
		[Embed(source = '../resources/images/hurt_player_sheet.png')]
		private var hurt_sprite_sheet:Class;
		
		public function Player(x:int, y:int)
		{
			super(x, y, 2, 2, 14, 14);
			hp = 6;
			hurt = 0;
			invincibility = 0;
			rest = 0;
			rollRest = 0;
			state = NORMAL;
			facing = Global.UP;
			sprite_sheet = my_sprite_sheet;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (invincibility > 0) invincibility -= 1;
			InteractWithEntities(entities);
			UpdateMovement(entities, map);
			if (state != HURT_BOUNCE && state != ROLL_ATTACK) UpdateFacingWithVelocity();
			if (state == ROLL_ATTACK){
				if (hitSomething){
					state = NORMAL;
					rest = 5;
					vel.x = 0;
					vel.y = 0;
					currFrame = 0;
					frameCount = 0;
				}
			}
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
			if (invincibility > 0 || hurt > 0) return;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is PlayerSword){
					if (entities[i].hitEnemy){
						if (vel.x != 0 || vel.y != 0){
							vel.x *= -0.5;
							vel.y *= -0.5;
							state = ROLL_ATTACK;
							currFrame = 1;
							frameCount = 0;
							entities[i].visible = false;
							entities[i].delete_me = true;
						}
					}
				}
				else if (entities[i] is Enemy){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb)){
						if (entities[i].hurt <= 0 && entities[i].invincibility <= 0)
						GetHurtByObject(entities[i]);
						break;
					}
				}else if (entities[i] is Projectile){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb)){
						entities[i].delete_me = true;
						if (!TryToKillProjectile(entities[i]) || state != NORMAL){
							GetHurtByObject(entities[i]);
							break;
						}
					}
				}
			}
		}
		
		public function TryToKillProjectile(projectile:Projectile):Boolean
		{
			if (!projectile.diagonal){
				if (projectile.facing == Global.LEFT && facing == Global.RIGHT){
					projectile.x += 10;
					return true;
				}if (projectile.facing == Global.RIGHT && facing == Global.LEFT){
					projectile.x -= 10;
					return true;
				}if (projectile.facing == Global.UP && facing == Global.DOWN){
					projectile.y += 10;
					return true;
				}if (projectile.facing == Global.DOWN && facing == Global.UP){
					projectile.y -= 10;
					return true;
				}
				return false;
			}
			
			if (Math.abs(projectile.x-x) > Math.abs(projectile.y-y)){
				if (projectile.x > x && facing == Global.RIGHT){
					projectile.x += 10;
					return true;
				}
				else if (projectile.x < x && facing == Global.LEFT){
					projectile.x -= 10;
					return true;
				}
			}
			else{
				if (projectile.y > y && facing == Global.DOWN){
					projectile.y += 10;
					return true;
				}
				else if (projectile.y < y && facing == Global.UP){
					projectile.y -= 10;
					return true;
				}
			}return false;
		}
		
		public function GetHurtByObject(enemy:Mover):void
		{
			hp -= 1;
			trace("Player HP: "+hp);
			if (hp > 0){
				state = HURT_BOUNCE;
				hurt = 7;
				invincibility = 20;
				vel.x = 0;
				vel.y = 0;
				var ex:Number = enemy.x;
				var ey:Number = enemy.y;
				if (Math.abs(ex-x) > Math.abs(ey-y)){
					if (ex > x) vel.x = -topspeed * 2;
					else vel.x = topspeed * 2;
				}
				else{
					if (ey > y) vel.y = -topspeed * 2;
					else vel.y = topspeed * 2;
				}
			}
			else{
				trace("Player has died!");
				hp = 3;
			}
		}
		
		override public function UpdateAnimation():void
		{
			if (facing == Global.UP) currAniY = 2;
			else if (facing == Global.DOWN) currAniY = 0;
			else if (facing == Global.LEFT) currAniY = 1;
			else if (facing == Global.RIGHT) currAniY = 3;
			
			if (invincibility <= 0) sprite_sheet = my_sprite_sheet;
			else sprite_sheet = hurt_sprite_sheet;
				
			if (state == NORMAL){ 
				currAniX = 0;
				maxFrame = 2;
				if (vel.x == 0 && vel.y == 0) frameDelay = 15;
				else frameDelay = 7;
			}else if (state == ROLL_ATTACK){ 
				currAniX = 3;
				maxFrame = 4;
				frameDelay = 3;
				rollRest = 5;
			}else if (state == SWORD_ATTACK){
				currAniX = 2;
				maxFrame = 1;
				frameDelay = 7;
				rest = 1;
			}else if (state == HURT_BOUNCE){
				currAniX = 0;
				maxFrame = 2;
				frameDelay = 3;
			}
			
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame){
					currFrame = 0;
					if (state != NORMAL && state != HURT_BOUNCE) 
						state = NORMAL;
				}
				frameCount = 0;
			}
		}
	}
}