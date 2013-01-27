package Entities 
{
	import Entities.Parents.GameSprite;
	import Entities.Dialogue.ZeldaIntroDialogue;
	import Entities.Items.CloudDisappear;
	
	public class ZeldaIntro extends GameSprite
	{
		[Embed(source = '../resources/images/zelda_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function ZeldaIntro(x:int, y:int)
		{
			super(x, y, 1, 1, 15, 15);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 15;
		}		
		
		override public function Update(entities:Array, map:Array):void
		{
			var dialogueIndex:int = -1;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is ZeldaIntroDialogue) dialogueIndex = i;
			}
			if (dialogueIndex < 0){
				delete_me = true;
				entities.push(new CloudDisappear(x, y, true));
			}
			
			UpdateAnimation();
		}
	}
}