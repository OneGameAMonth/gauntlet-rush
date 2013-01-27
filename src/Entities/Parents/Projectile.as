package Entities.Parents 
{
	public class Projectile extends Mover
	{
		public var atkPow:Number;
		public var canBeKilled:Boolean;
		public var canBeBlocked:Boolean;
		
		public function Projectile(x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			atkPow = 1;
			canBeKilled = false;
			canBeBlocked = true;
		}		
	}
}