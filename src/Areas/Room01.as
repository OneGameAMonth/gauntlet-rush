package Areas 
{
	import Entities.*;
	public class Room01 extends Room
	{
		
		public function Room01() 
		{
			super(320, 240, 1);
			entities.push(new Player(32, 32));
			playerIndex = entities.length-1;
			entities.push(new Octorok(96, 96));
			entities.push(new Octorok(224, 128));
		}		
	}
}