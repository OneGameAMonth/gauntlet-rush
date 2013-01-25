package Areas 
{
	import Entities.Enemies.*;
	import Entities.Portcullis;
	import Entities.Player;
	import Entities.Tile;
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
			entities.push(new Octoturret(96, 96));
			entities.push(new Octoturret(208, 128));
			entities.push(new Rope(16, 32));
			entities.push(new Rope(width-32, 32));
			entities.push(new Rope(16, height-48));
			entities.push(new Rope(width-32, height-48));
			enemyCount = 6;
			
			//CREATE MORE SOLIDS
			for (var i:int = 0; i < 5; i++){
				map[1][1+i] = new Tile((1+i)*16, 16, 1, 0, true);
				map[1][14+i] = new Tile((14+i)*16, 16, 1, 0, true);
				map[height/16-2][1+i] = new Tile((1+i)*16, height-32, 1, 0, true);
				map[height/16-2][14+i] = new Tile((14+i)*16, height-32, 1, 0, true);
				for (var j:int = 0; j < 7; j++){
					map[4+j][1+i] = new Tile((1+i)*16, (4+j)*16, 1, 0, true);
					map[4+j][14+i] = new Tile((14+i)*16, (4+j)*16, 1, 0, true);
				}
			}
		}		
	}
}