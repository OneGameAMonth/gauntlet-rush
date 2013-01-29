package Entities.Dialogue 
{
	public class LinkEndDialogue extends Dialogue
	{
		[Embed(source = '../../resources/images/link_end_dialogue.png')]
		private var my_sprite_sheet:Class;
		
		public function LinkEndDialogue()
		{
			super();
			sprite_sheet = my_sprite_sheet;
		}
	}
}