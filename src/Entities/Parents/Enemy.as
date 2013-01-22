package Entities.Parents 
{
	public class Enemy extends Mover
	{
		public var hp:int;
		public var invincibility:int;
		public var canBeHurt:Boolean;
		
		public function Enemy(x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			hp = 1;
			invincibility = 0;
			canBeHurt = true;
		}		
	}
}