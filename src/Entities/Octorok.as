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
			var solids:Array = [];
			var i:int;
			for (i = 0; i < map.length; i++){
				for (var j:int = 0; j < map[i].length; j++){
					if (map[i][j].solid) solids.push(map[i][j]);
				}
			}for (i = 0; i < entities.length; i++){
				if (entities[i].solid) solids.push(entities[i]);
			}
			UpdateMovement(solids);			
			super.UpdateAnimation();
		}
	}
}