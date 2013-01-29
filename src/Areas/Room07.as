package Areas 
{
	import Entities.Enemies.*;
	import Entities.Items.Portcullis;
	import Entities.Player;
	import Entities.Items.SavePoint;
	import Entities.Items.CloudDisappear;
	import Entities.Items.Fairy;
	
	public class Room07 extends Room
	{
		
		public function Room07() 
		{
			super(320, 240, 1);
		}
		
		override public function CreateEntities():void
		{
			super.CreateEntities();
			//create portculli
			entities.push(new Portcullis(6*16, 0, 0));
			portcullisIndex = entities.length-1;
			entities.push(new Portcullis(6*16-8, (height/16-1)*16, 1));
			
			entities.push(new Player(10*16-8, (height/16-2)*16));
			playerIndex = entities.length-1;
			
			//create enemies
			entities.push(new Armos(64, 64));
			entities.push(new Armos(width-80, 64));
			entities.push(new Armos(64, height-80));
			entities.push(new Armos(width-80, height-80));
			entities.push(new Wizrobe(width/2-8, height/2-8));
			entities.push(new Rope(16, 16, 2));
			entities.push(new Rope(width-32, height-32, 2));
			enemyCount = 7;
			
			//create items
			entities.push(new CloudDisappear(13*16, 16));
			entities.push(new SavePoint(13*16+6, 16+6, 6));
			entities.push(new CloudDisappear(6*16, 16));
			entities.push(new Fairy(6*16, 16));
		}
	}
}