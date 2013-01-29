package Entities 
{
	import Entities.Parents.GameSprite;
	import Entities.Dialogue.ZeldaEndDialogue;
	import Entities.Items.CloudDisappear;
	import Entities.Enemies.Ganon;
	
	public class ZeldaEnd extends GameSprite
	{
		[Embed(source = '../resources/images/zelda_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public var displayedDialogue:Boolean;
		
		public function ZeldaEnd(x:int, y:int)
		{
			super(x, y, 1, 1, 15, 15);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 15;
			displayedDialogue = false;
		}		
		
		override public function Update(entities:Array, map:Array):void
		{
			var dialogueIndex:int = -1;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is ZeldaEndDialogue) dialogueIndex = i;
				if (entities[i] is Player){
					if (!displayedDialogue && CheckRectIntersect(entities[i], x-64, y-64, x+16+64, y+16+64)){
						displayedDialogue = true;
						entities.push(new ZeldaEndDialogue());
						entities[i].StopAll();
						dialogueIndex = entities.length-1;
						break;
					}
				}
			}
			if (dialogueIndex < 0 && displayedDialogue){
				delete_me = true;
				entities.push(new CloudDisappear(x, y, true));
				entities.push(new Ganon(x-24, y-24));
				SoundManager.getInstance().playSfx("UnlockSound", 0, 1);
				SoundManager.getInstance().playSfx("BossScream1Sound", 0, 1);
			}
			
			UpdateAnimation();
		}
	}
}