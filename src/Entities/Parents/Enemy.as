package Entities.Parents 
{
	import Entities.PlayerSword;
	
	public class Enemy extends Mover
	{
		public var hp:int;
		public var invincibility:int;
		public var hurt:int;
		public var canBeHurt:Boolean;
		
		public var baseAniX:int;
		public var hurtAniX:int;
		
		public var state:int;
		public const NORMAL:int = 0;
		public const HURT_BOUNCE:int = 1;
		
		public function Enemy(x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			hp = 1;
			invincibility = 0;
			hurt = 0;
			canBeHurt = true;
			
			baseAniX = currAniX;
			hurtAniX = currAniX;
		}
		
		public function Update(entities:Array, map:Array):void
		{	
			if (delete_me) return;
			if (state == NORMAL){ 
				UpdateScript(entities, map);
				UpdateMovement(entities, map, true);
			}else UpdateMovement(entities, map);
			
			if (state != HURT_BOUNCE) UpdateFacingWithVelocity();
			if (hurt > 0){
				hurt--;
				if (hurt <= 0){
					state = NORMAL;
					vel.x = 0;
					vel.y = 0;
				}
			}if (invincibility > 0) invincibility--;
			UpdateAnimation();
		}
		
		public function UpdateScript(entities:Array, map:Array):void
		{
		}
		
		public function GetHurtByObject(object:PlayerSword):void
		{
			hp -= 1;
			if (hp > 0){
				state = HURT_BOUNCE;
				hurt = 7;
				invincibility = 20;
				vel.x = 0;
				vel.y = 0;
				var ofacing:int = object.facing;
				if (ofacing == Global.LEFT) vel.x = -6.0;
				else if (ofacing == Global.RIGHT) vel.x = 6.0;
				else if (ofacing == Global.UP) vel.y = -6.0;
				else if (ofacing == Global.DOWN) vel.y = 6.0;
			}
			else{
				delete_me = true;
			}
		}
		
		override public function UpdateAnimation():void
		{
			if (state == HURT_BOUNCE) currAniX = hurtAniX;
			else currAniX = baseAniX;
			super.UpdateAnimation();
		}
	}
}