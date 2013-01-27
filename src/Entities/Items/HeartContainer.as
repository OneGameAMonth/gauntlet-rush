package Entities.Items 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	
	public class HeartContainer extends GameSprite
	{
		[Embed(source = '../../resources/images/heart_container.png')]
		private var my_sprite_sheet:Class;
		public function HeartContainer(x:int, y:int) 
		{
			super(x, y, 0, 0, 13, 13);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 13;
			frameHeight = 13;
			
			visible = false;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me || !visible) return;
			
			for(var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player)
				{
					if (CheckRectIntersect(entities[i], x, y, x+rb, y+bb)){
						Global.MAX_HP += 1;
						Global.HP = Global.MAX_HP;
						SoundManager.getInstance().playSfx("GetItemSound", 0, 1);
						delete_me = true;
					}
				}
			}
		}
	}
}