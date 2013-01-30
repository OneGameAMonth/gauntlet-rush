package Areas 
{
	import Entities.Enemies.*;
	import Entities.Items.Portcullis;
	import Entities.Player;
	import Entities.Tile;
	import Entities.Items.SavePoint;
	import Entities.Items.HeartContainer;
	import Entities.Items.CloudDisappear;
	import Entities.Items.Fairy;
	
	public class Room04 extends Room
	{
		
		public function Room04() 
		{
			super(320, 240, 1);
			
			//CREATE MORE SOLIDS
			for (var i:int = 0; i < 2; i++){
				for (var j:int = 0; j < 2; j++){
					map[3+i][3+j] = new Tile((3+j)*16, (3+i)*16, 1, 0, true);
					map[3+i][15+j] = new Tile((15+j)*16, (3+i)*16, 1, 0, true);
					map[2+i][7+j] = new Tile((7+j)*16, (2+i)*16, 1, 0, true);
					map[2+i][11+j] = new Tile((11+j)*16, (2+i)*16, 1, 0, true);
					map[5+i][9+j] = new Tile((9+j)*16, (5+i)*16, 1, 0, true);
					map[7+i][5+j] = new Tile((5+j)*16, (7+i)*16, 1, 0, true);
					map[7+i][13+j] = new Tile((13+j)*16, (7+i)*16, 1, 0, true);
					map[10+i][3+j] = new Tile((3+j)*16, (10+i)*16, 1, 0, true);
					map[10+i][15+j] = new Tile((15+j)*16, (10+i)*16, 1, 0, true);
					map[11+i][7+j] = new Tile((7+j)*16, (11+i)*16, 1, 0, true);
					map[11+i][11+j] = new Tile((11+j)*16, (11+i)*16, 1, 0, true);
				}
			}
		}
		
		override public function CreateEntities():void
		{
			super.CreateEntities();
			//create portculli
			entities.push(new Portcullis(6*16, 0, 0));
			portcullisIndex = entities.length-1;
			entities.push(new Portcullis(6*16, (height/16-1)*16, 1));
			
			entities.push(new Player(10*16-8, (height/16-2)*16));
			playerIndex = entities.length-1;
			
			//create enemies
			entities.push(new Octoturret(64, 128));
			entities.push(new Octoturret(224, 96));
			entities.push(new Rope(16, 16));
			entities.push(new Rope(width-32, height-32));
			entities.push(new Rope(width-32, 16));
			entities.push(new Rope(16, height-32));
			entities.push(new Keese(32, 32));
			entities.push(new Keese(width-48, 32));
			enemyCount = 8;
			entities.push(new Bubble(width/2, height/2));
			
			//create items
			ReloadHearts();
			entities.push(new CloudDisappear(13*16, 16));
			entities.push(new SavePoint(13*16+6, 16+6, 5));
		}
		
		override public function ReloadHearts():void
		{
			entities.push(new CloudDisappear(6*16, 16));
			if (Global.GAME_MODE != Global.HARD)
				entities.push(new HeartContainer(6*16+3, 16+3));
			else entities.push(new Fairy(6*16, 16));
		}
	}
}