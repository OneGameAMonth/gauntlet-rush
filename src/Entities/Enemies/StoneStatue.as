package Entities.Enemies 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	
	public class StoneStatue extends GameSprite
	{
		[Embed(source = '../../resources/images/stone_statue_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public var fireCounter:int;
		
		public function StoneStatue(x:int, y:int, currAniX:int, currAniY:int) 
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			this.currAniX = currAniX;
			this.currAniY = currAniY;
			
			fireCounter = Math.floor(Math.random()*30)+60;
			solid = true;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			fireCounter--;
			if (fireCounter <= 0){
				fireCounter = Math.floor(Math.random()*30)+60;
				for (var i:int = 0; i < entities.length; i++){
					if (entities[i] is Player){
						entities.push(new Fireball(x, y, entities[i].x, entities[i].y));
						//SoundManager.getInstance().playSfx("ArrowSound", 0, 1);
						return;
					}
				}
			}
		}
	}
}