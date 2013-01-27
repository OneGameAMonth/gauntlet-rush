package Entities.Dialogue 
{
	public class LinkMidDialogue extends Dialogue
	{
		[Embed(source = '../../resources/images/link_mid_dialogue.png')]
		private var my_sprite_sheet:Class;
		
		public function LinkMidDialogue()
		{
			super();
			sprite_sheet = my_sprite_sheet;
		}
	}
}