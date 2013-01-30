package Areas 
{
	import Entities.Enemies.*;
	import Entities.Items.Portcullis;
	import Entities.Player;
	public class Room01 extends Room
	{
		
		public function Room01() 
		{
			super(320, 240, 1);
		}
		
		override public function Update():void
		{
			super.Update();
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
			entities.push(new Octorok(96, 96));
			entities.push(new Octorok(224, 128));
			entities.push(new Octorok(128, 64));
			entities.push(new Octoturret(164, 84));
			enemyCount = 4;
		}
	}
}