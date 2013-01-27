package Entities.Dialogue 
{
	public class LinkIntroDialogue extends Dialogue
	{
		[Embed(source = '../../resources/images/link_intro_dialogue.png')]
		private var my_sprite_sheet:Class;
		
		public function LinkIntroDialogue()
		{
			super();
			sprite_sheet = my_sprite_sheet;
		}
	}
}