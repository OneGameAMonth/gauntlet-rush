package Areas 
{
	import Entities.Enemies.*;
	import Entities.Tile;
	import Entities.Items.Portcullis;
	import Entities.Items.SavePoint;
	import Entities.Items.HeartContainer;
	import Entities.Items.CloudDisappear;
	import Entities.Player;
	import Entities.ZeldaIntro;
	import Entities.Dialogue.ZeldaIntroDialogue;
	import Entities.Dialogue.LinkIntroDialogue;
	
	public class Room00 extends Room
	{
		public var dialogueTimer:int;
		
		public function Room00() 
		{
			super(320, 240, 1);
			dialogueTimer = 20;
			
			entities.push(new ZeldaIntro(width/2-8, height/2-64));
			entities.push(new ZeldaIntroDialogue());
			
			//CREATE SOLIDS
			for (var i:int = 6; i < width/16-6; i++){
				map[height/16-1][i] = new Tile(i*16, height-16, 1, 0, true);
			}
		}
		
		override public function CreateEntities():void
		{
			super.CreateEntities();
			//create portculli
			entities.push(new Portcullis(6*16, 0, 0));
			portcullisIndex = entities.length-1;
			
			entities.push(new Player(10*16-8, (height/16-6)*16));
			playerIndex = entities.length-1;
			
			//create enemies
			enemyCount = 1;
			
			//create items
			entities.push(new CloudDisappear(6*16, 16));
			entities.push(new HeartContainer(6*16+3, 16+3));
			entities.push(new CloudDisappear(13*16, 16));
			entities.push(new SavePoint(13*16+6, 16+6));
		}
		
		override public function Update():void
		{
			super.Update();
			
			var dialogueIndex:int = -1;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is ZeldaIntroDialogue) dialogueIndex = i;
			}
			
			if (dialogueIndex < 0){
				if (dialogueTimer > 0){
					dialogueTimer--;
					entities[playerIndex].rest = 2;
				}
				if (dialogueTimer == 0){
					entities.push(new LinkIntroDialogue());
					enemyCount = 0;
					dialogueTimer--;
				}
			}
		}
	}
}