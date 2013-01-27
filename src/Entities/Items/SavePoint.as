package Entities.Items 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	
	public class SavePoint extends GameSprite
	{
		[Embed(source = '../../resources/images/triforce_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function SavePoint(x:int, y:int) 
		{
			super(x, y, 0, 0, 10, 10);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 10;
			frameHeight = 10;
			maxFrame = 2;
			frameDelay = 7;
			
			visible = false;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (!visible) return;
			
			for(var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player)
				{
					if (CheckRectIntersect(entities[i], x, y, x+rb, y+bb)){
						if (!Save.CAN_SAVE) trace("Game Saved!");
						Save.CAN_SAVE = true;
					}else Save.CAN_SAVE = false;
				}
			}
			
			super.UpdateAnimation();
		}
	}
}