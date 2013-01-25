package Entities.Parents 
{
	
	public class LifeForm extends Mover
	{
		public var hp:int;
		public var invincibility:int;
		public var hurt:int;
		
		public var state:int;
		public static const NORMAL:int = 0;
		public static const HURT_BOUNCE:int = 1;
		
		public function LifeForm(x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			hp = 1;
			invincibility = 0;
			hurt = 0;
			
			state = NORMAL;
		}
		
		public function GetHurtByObject(object:Mover, dmg:int = 1):void
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
	}
}