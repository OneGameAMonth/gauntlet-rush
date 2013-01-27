package Entities.Parents 
{
	
	public class LifeForm extends Mover
	{
		public var hp:Number;
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
		
		public function GetHurtByObject(object:Mover, dmg:Number = 1):void
		{
			hp -= dmg;
			if (hp > 0){
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
				delete_me = true;
			}
		}
	}
}