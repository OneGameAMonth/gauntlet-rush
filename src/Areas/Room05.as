package Areas 
{
	import Entities.Enemies.*;
	import Entities.Items.Portcullis;
	import Entities.Player;
	import Entities.Tile;
	import Entities.Items.HeartContainer;
	import Entities.Items.SavePoint;
	
	public class Room05 extends Room
	{
		
		public function Room05() 
		{
			super(320, 240, 1);
			
			//CREATE MORE SOLIDS
			for (var i:int = 1; i < 14; i++){
				map[i][1] = new Tile(1*16, i*16, 1, 0, true);
				map[i][2] = new Tile(2*16, i*16, 1, 0, true);
				map[i][17] = new Tile(17*16, i*16, 1, 0, true);
				map[i][18] = new Tile(18*16, i*16, 1, 0, true);
				if (i < 5 || i > 9){
					map[i][3] = new Tile(3*16, i*16, 1, 0, true);
					map[i][4] = new Tile(4*16, i*16, 1, 0, true);
					map[i][15] = new Tile(15*16, i*16, 1, 0, true);
					map[i][16] = new Tile(16*16, i*16, 1, 0, true);
				}
				if (i < 3 || i > 11){
					map[i][5] = new Tile(5*16, i*16, 1, 0, true);
					map[i][14] = new Tile(14*16, i*16, 1, 0, true);
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
			entities.push(new Gohma(width/2-24, height/2-16));
			entities.push(new Keese(width/2, 64, true));
			entities.push(new Keese(width/2, 64, true));
			entities.push(new Keese(width/2, 64, true));
			entities.push(new Keese(width/2, 64, true));
			entities.push(new Keese(width/2, 64, true));
			enemyCount = 6;
			
			entities.push(new StoneStatue(3*16, 5*16, 0, 0));
			entities.push(new StoneStatue(16*16, 5*16, 0, 1));
			entities.push(new StoneStatue(3*16, 9*16, 0, 0));
			entities.push(new StoneStatue(16*16, 9*16, 0, 1));
			
			//create items
			entities.push(new HeartContainer(width/2, height/2));
			entities.push(new SavePoint(13*16+6, 16+6));
		}
	}
}