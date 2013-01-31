package Entities.Dialogue 
{
	import Entities.Player;
	
	public class LinkEndDialogue extends Dialogue
	{
		[Embed(source = '../../resources/images/link_end_dialogue.png')]
		private var my_sprite_sheet:Class;
		
		public function LinkEndDialogue(entities:Array)
		{
			super();
			sprite_sheet = my_sprite_sheet;
			
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player){					
					if (entities[i].y >= 160) y = 32;
				}
			}
		}
	}
}