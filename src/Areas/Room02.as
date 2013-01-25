package Areas 
{
	import Entities.Enemies.*;
	import Entities.Tile;
	import Entities.Portcullis;
	import Entities.Player;
	
	public class Room02 extends Room
	{
		
		public function Room02() 
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
			entities.push(new Keese(32, height/2));
			entities.push(new Keese(width/2, 32));
			entities.push(new Keese(width-64, height/2));
			enemyCount = 4;
			
			entities.push(new StoneStatue(16, 16, 0, 0));
			entities.push(new StoneStatue(width-32, 16, 0, 1));
			entities.push(new StoneStatue(16, height-32, 0, 0));
			entities.push(new StoneStatue(width-32, height-32, 0, 1));
			
			//CREATE MORE SOLIDS
			var i:int;
			for (i = 0; i < 4; i++){
				map[5][5+i] = new Tile((5+i)*16, 5*16, 1, 0, true);
				map[5][11+i] = new Tile((11+i)*16, 5*16, 1, 0, true);
				map[8][5+i] = new Tile((5+i)*16, 8*16, 1, 0, true);
				map[8][11+i] = new Tile((11+i)*16, 8*16, 1, 0, true);
				if (i < 2){
					map[4][7+i] = new Tile((7+i)*16, 4*16, 1, 0, true);
					map[4][11+i] = new Tile((11+i)*16, 4*16, 1, 0, true);
					map[9][7+i] = new Tile((7+i)*16, 9*16, 1, 0, true);
					map[9][11+i] = new Tile((11+i)*16, 9*16, 1, 0, true);
				}
			}
			map[3][8] = new Tile(8*16, 3*16, 1, 0, true);
			map[3][11] = new Tile(11*16, 3*16, 1, 0, true);
			map[10][8] = new Tile(8*16, 10*16, 1, 0, true);
			map[10][11] = new Tile(11*16, 10*16, 1, 0, true);
		}		
	}
}