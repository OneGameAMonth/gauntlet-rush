package Entities.Items 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	
	public class Heart extends GameSprite
	{
		[Embed(source = '../../resources/images/heart_sheet.png')]
		private var my_sprite_sheet:Class;
		private var aliveTimer:int;
		
		public function Heart(x:int, y:int) 
		{
			super(x, y, 0, 0, 8, 8);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 8;
			frameHeight = 8;
			maxFrame = 2;
			frameDelay = 3;
			
			visible = true;
			aliveTimer = 120;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me || !visible) return;
			aliveTimer--;
			if (aliveTimer <= 0){
				delete_me = true;
				return;
			}else if (aliveTimer <= 30){
				frameDelay = 2;
			}
			
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