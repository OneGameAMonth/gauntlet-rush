package Entities 
{
	import Entities.Parents.GameObject;
	import Entities.Player;
	
	public class ToNextRoom extends GameObject
	{
		
		public function ToNextRoom(x:int, y:int)
		{
			super(x, y, 0, 0, 128, 16);
			solid = false;
		}		
		
		override public function Update(entities:Array, map:Array):void
		{
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player 
					&& CheckRectIntersect(entities[i], x, y, x+rb, y+bb)){
					Game.roomIndex++;
				}
			}
		}	
	}
}