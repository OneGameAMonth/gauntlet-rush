package Areas 
{
	import Entities.Enemies.*;
	import Entities.Items.Portcullis;
	import Entities.Player;
	import Entities.Items.SavePoint;
	import Entities.Items.HeartContainer;
	import Entities.Items.CloudDisappear;
	
	public class Room08 extends Room
	{
		
		public function Room08()
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
			entities.push(new Darknut(64, height/2));
			entities.push(new Darknut(width-80, height/2));
			entities.push(new Wizrobe(width/2-8, 64));
			entities.push(new Wizrobe(48, height-64));
			entities.push(new Wizrobe(width-64, height-64));
			enemyCount = 5;
			
			entities.push(new StoneStatue(16, 16, 0, 0));
			entities.push(new StoneStatue(width-32, 16, 0, 1));
			entities.push(new StoneStatue(16, height-32, 0, 0));
			entities.push(new StoneStatue(width-32, height-32, 0, 1));
			
			//create items
			ReloadHearts();
			entities.push(new CloudDisappear(13*16, 16));
			entities.push(new SavePoint(13*16+6, 16+6, 5));
		}
		
		override public function ReloadHearts():void
		{
			entities.push(new CloudDisappear(6*16, 16));
			entities.push(new HeartContainer(6*16+3, 16+3));
		}
	}
}