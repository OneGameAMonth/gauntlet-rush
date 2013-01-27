package Entities.Dialogue 
{	
	public class ZeldaIntroDialogue extends Dialogue
	{
		[Embed(source = '../../resources/images/zelda_intro_dialogue.png')]
		private var my_sprite_sheet:Class;
		
		public function ZeldaIntroDialogue()
		{
			super();
			sprite_sheet = my_sprite_sheet;
		}
	}
}