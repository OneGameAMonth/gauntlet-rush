package Entities.Parents 
{
	public class Projectile extends Mover
	{
		public var atkPow:Number;
		public var canBeKilled:Boolean;
		public var canBeBlocked:Boolean;
		public var invincibility:int;
		
		public function Projectile(x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			atkPow = 1;
			canBeKilled = false;
			canBeBlocked = true;
			facing = -1;
			invincibility = 1;
		}		
	}
}