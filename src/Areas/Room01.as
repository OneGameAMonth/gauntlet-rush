package Areas 
{
	import Entities.Enemies.*;
	import Entities.Player;
	public class Room01 extends Room
	{
		
		public function Room01() 
		{
			super(320, 240, 1);
			entities.push(new Player(32, 32));
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