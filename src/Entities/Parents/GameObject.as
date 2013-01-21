package Entities.Parents 
{

	public class GameObject 
	{
		public var x:Number;
		public var y:Number;
		
		public var lb:int;
		public var tb:int;
		public var rb:int;
		public var bb:int;
		public var solid:Boolean;
		
		public var delete_me:Boolean;
		
		public function GameObject(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int)
		{
			this.x = x;
			this.y = y;
			this.lb = lb;
			this.tb = tb;
			this.rb = rb;
			this.bb = bb;
			
			//assume object is solid at first (this will be th eclass used for solids??
			solid = true;
			delete_me = false;
		}
		
		public function CheckRectIntersect(obj2:GameObject, lb:int, 
			tb:int, rb:int, bb:int):Boolean
		{			
			if (lb < (obj2.x + obj2.rb) && rb > (obj2.x + obj2.lb) &&
				tb < (obj2.y + obj2.bb) && bb > (obj2.y + obj2.tb))
			{
				return true;
			}
			return false;
		}
	}
}