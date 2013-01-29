package Entities.Dialogue 
{	
	public class ZeldaEndDialogue extends Dialogue
	{
		[Embed(source = '../../resources/images/zelda_end_dialogue.png')]
		private var my_sprite_sheet:Class;
		
		public function ZeldaEndDialogue()
		{
			super();
			sprite_sheet = my_sprite_sheet;
		}
	}
}