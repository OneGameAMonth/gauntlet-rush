package Areas 
{
	import Entities.Enemies.*;
	import Entities.Portcullis;
	import Entities.Player;
	public class Room03 extends Room
	{
		
		public function Room03() 
		{
			super(320, 240, 1);
			//create portculli
			entities.push(new Portcullis(6*16, 0, 0));
			portcullisIndex = entities.length-1;
			entities.push(new Portcullis(6*16, (height/16-1)*16, 1));
			
			entities.push(new Player(10*16, (height/16-2)*16));
			playerIndex = entities.length-1;
			
			//create enemies
			entities.push(new Octoturret(width/2, height/2));
			enemyCount = 1;
		}		
	}
}