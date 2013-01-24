package Entities.Parents 
{
	public class Projectile extends Mover
	{
		public var diagonal:Boolean;
		
		public function Projectile(x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			diagonal = false;
		}		
	}
}