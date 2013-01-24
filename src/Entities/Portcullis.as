package Entities 
{
	import Entities.Parents.GameSprite;
	public class Portcullis extends GameSprite
	{
		[Embed(source = '../resources/images/portcullis_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function Portcullis(x:int, y:int, currAniY:int)
		{
			super(x, y, 0, 0, 128, 16);
			sprite_sheet = my_sprite_sheet;
			solid = true;
			frameWidth = 128;
			this.currAniY = currAniY;
		}		
		
		override public function Update(entities:Array, map:Array):void
		{
		}
	}
}