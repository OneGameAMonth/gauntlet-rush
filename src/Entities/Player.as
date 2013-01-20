package Entities 
{
	
	public class Player extends Mover
	{
		public var topspeed:Number;
		
		[Embed(source = '../resources/images/player_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function Player(x:int, y:int)
		{
			super(x, y, 2, 2, 14, 14);
			topspeed = 3.0;
			sprite_sheet = my_sprite_sheet;
			
			frameDelay = 15;
			maxFrame = 2;
			frameWidth = 16;
			frameHeight = 16;
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
			UpdateAnimation();
		}
	}
}