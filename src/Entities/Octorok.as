package Entities 
{
	import Entities.Parents.Enemy;
	
	public class Octorok extends Enemy
	{
		[Embed(source = '../resources/images/octorok_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function Octorok(x:int, y:int)
		{
			super(x, y, 2, 2, 14, 14);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
		}
		
		public function Update(entities:Array, map:Array):void
		{
			if (hp <= 0){
				delete_me = true;
				return;
			}
			UpdateMovement(entities, map);			
			invincibility -= 1;
			super.UpdateAnimation();
		}
	}
}