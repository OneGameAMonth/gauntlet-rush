package Entities.Parents 
{
	import flash.geom.Point;
	
	public class Mover extends GameSprite
	{
		public var topspeed:Number;
		public var vel:Point;
		public var facing:int;
		public var hitSomething:Boolean;
		
		public function Mover(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int)
		{
			super(x, y, lb, tb, rb, bb);
			topspeed = 3.0;
			vel = new Point(0, 0);
			facing = Global.DOWN;
			hitSomething = false;
		}
		
		public function UpdateMovement(solids:Array = null):void
		{
			//Update movement
			var dilation:Number = 1;
			if (vel.x != 0 && vel.y != 0){
				vel.x *= 0.71;
				vel.y *= 0.71;
				dilation = 0.71;
			}if (solids != null)
				CollideWithSolids(solids);
			else{
				x += vel.x;
				y += vel.y;
			}if (dilation != 1){
				vel.x /= dilation;
				vel.y /= dilation;
			}
		}
		
		public function CollideWithSolids(solids:Array):void
		{
			hitSomething = false;
			var i:int;
			for (i = 0; i < solids.length; i++){
				//horizontal solid collisions (LEFT)
				if (CheckRectIntersect(solids[i], x+lb+vel.x, y+tb, x+lb, y+bb)){
					vel.x = 0;
					hitSomething = true;
					while (!CheckRectIntersect(solids[i], x+lb-1, y+tb, x+lb, y+bb))
						x--;
				}
				//horizontal solid collisions (RIGHT)
				if (CheckRectIntersect(solids[i], x+rb, y+tb, x+rb+vel.x, y+bb)){
					vel.x = 0;
					hitSomething = true;
					while (!CheckRectIntersect(solids[i], x+rb, y+tb, x+rb+1, y+bb))
						x++;
				}
			}
			x += vel.x;
				
			for (i = 0; i < solids.length; i++){
				//vertical solid collisions (TOP)
				if (CheckRectIntersect(solids[i], x+lb, y+tb+vel.y, x+rb, y+tb)){
					vel.y = 0;
					hitSomething = true;
					while (!CheckRectIntersect(solids[i], x+lb, y+tb-1, x+rb, y+tb))
						y--;
				}
				//vertical solid collisions (BOTTOM)
				if (CheckRectIntersect(solids[i], x+lb, y+bb, x+rb, y+bb+vel.y)){
					vel.y = 0;
					hitSomething = true;
					while (!CheckRectIntersect(solids[i], x+lb, y+bb, x+rb, y+bb+1))
						y++;
				}
			}
			y += vel.y;
		}
		
		override public function UpdateAnimation():void
		{
			if (facing == Global.UP) currAniY = 2;
			else if (facing == Global.DOWN) currAniY = 0;
			else if (facing == Global.LEFT) currAniY = 1;
			else if (facing == Global.RIGHT) currAniY = 3;
			
			if (vel.x == 0 && vel.y == 0) frameDelay = 15;
			else frameDelay = 7;
			super.UpdateAnimation();
		}
	}
}