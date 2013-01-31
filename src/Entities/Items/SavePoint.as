package Entities.Items 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	import Screens.PlayGame;
	
	public class SavePoint extends GameSprite
	{
		[Embed(source = '../../resources/images/triforce_sheet.png')]
		private var my_sprite_sheet:Class;
		public var maxHP:int;
		public var contactPlayer:Boolean;
		
		public function SavePoint(x:int, y:int, maxHP:int) 
		{
			super(x, y, 0, 0, 10, 10);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 10;
			frameHeight = 10;
			maxFrame = 2;
			frameDelay = 7;
			
			this.maxHP = maxHP;
			visible = false;
			contactPlayer = false;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (!visible) return;
			
			super.UpdateAnimation();
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player)
				{
					if (CheckRectIntersect(entities[i], x, y, x+rb, y+bb)){
						if (contactPlayer) return;
						contactPlayer = true;
						trace("Game Saved!");
						SoundManager.getInstance().playSfx("GetRupeeSound", 0, 1);
						if (Global.highScore < Global.currScore) Global.highScore = Global.currScore;
						DataManager.ROOM_INDEX = PlayGame.roomIndex;
						DataManager.MAX_HP = Global.MAX_HP;
						DataManager.HP = Global.MAX_HP;
						DataManager.POSSIBLE_MAX_HP = maxHP;
						DataManager.PLAYER_X = x-6;
						DataManager.PLAYER_Y = y-6;
						PlayGame.dataManager.SetCookieVal(
							"gauntlet-data", PlayGame.dataManager.ConstructCookieData());
					}else{ contactPlayer = false; }
				}
			}
		}
	}
}