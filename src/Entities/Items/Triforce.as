package Entities.Items 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	
	public class Triforce extends GameSprite
	{
		[Embed(source = '../../resources/images/ganon_triforce_sheet.png')]
		private var my_sprite_sheet:Class;
		public function Triforce(x:int, y:int) 
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 16;
			frameHeight = 16;
			maxFrame = 2;
			frameDelay = 3;
			
			visible = true;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me || !visible) return;
			
			for(var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player){
					if (CheckRectIntersect(entities[i], x, y, x+rb, y+bb)){
						Global.HP = Global.MAX_HP;
						SoundManager.getInstance().playSfx("GetItemSound", 0, 1);
						delete_me = true;
					}
				}
			}
			UpdateAnimation();
		}
	}
}