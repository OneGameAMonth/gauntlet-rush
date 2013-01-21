package Entities 
{
	import Entities.Parents.GameSprite;
	
	public class EnemyDie extends GameSprite
	{
		[Embed(source = '../resources/images/monster_death_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function EnemyDie(x:Number, y:Number) 
		{
			super(x, y, 0, 0, 16, 16);
			maxFrame = 4;
			frameDelay = 2;
			sprite_sheet = my_sprite_sheet;
		}
		
		public function Update(entities:Array, map:Array):void
		{
			UpdateAnimation();
			if (currFrame == 0 && frameCount == 0) delete_me = true;
		}
	}
}