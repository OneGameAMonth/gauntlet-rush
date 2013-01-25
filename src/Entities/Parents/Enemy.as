package Entities.Parents 
{
	import Entities.PlayerSword;
	
	public class Enemy extends LifeForm
	{		
		public var baseAniX:int;
		public var hurtAniX:int;
		public var atkPow:int;
		
		public function Enemy(x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			
			atkPow = 1;
			baseAniX = currAniX;
			hurtAniX = currAniX;
		}
		
		override public function Update(entities:Array, map:Array):void
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
		
		override public function UpdateAnimation():void
		{
			if (invincibility > 0) currAniX = hurtAniX;
			else currAniX = baseAniX;
			super.UpdateAnimation();
		}
	}
}