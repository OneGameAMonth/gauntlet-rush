package Entities.Items 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	
	public class Heart extends GameSprite
	{
		[Embed(source = '../../resources/images/heart_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function Heart(x:int, y:int) 
		{
			super(x, y, 0, 0, 8, 8);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 8;
			frameHeight = 8;
			maxFrame = 2;
			frameDelay = 3;
			
			visible = true;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me || !visible) return;
			
			for(var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player)
				{
					if (CheckRectIntersect(entities[i], x, y, x+rb, y+bb)){
						Global.HP++;
						if (Global.HP > Global.MAX_HP) Global.HP = Global.MAX_HP;
						SoundManager.getInstance().playSfx("GetHeartSound", 0, 1);
						delete_me = true;
					}
				}
			}
			UpdateAnimation();
		}
	}
}