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
					if (CheckRectIntersect(entities[i], x, y, x+rb, y+bb) &&
							(Save.ROOM_INDEX != Game.roomIndex || Save.MAX_HP != Global.MAX_HP))
					{
						trace("Game Saved!");
						SoundManager.getInstance().playSfx("GetRupeeSound", 0, 1);
						Save.ROOM_INDEX = Game.roomIndex;
						Save.MAX_HP = Global.MAX_HP;
						Save.HP = Global.MAX_HP;
					}
				}
			}
			
			super.UpdateAnimation();
		}
	}
}