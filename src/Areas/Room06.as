package Areas 
{
	import Entities.Enemies.*;
	import Entities.Items.Portcullis;
	import Entities.Player;
	import Entities.Tile;
	
	public class Room06 extends Room
	{
		
		public function Room06() 
		{
			super(320, 240, 1);
			
			//CREATE SOLIDS
			var i:int;
			for (i = 0; i < 4; i++){
				map[2+i][2] = new Tile(2*16, (2+i)*16, 1, 0, true);
				map[9+i][2] = new Tile(2*16, (9+i)*16, 1, 0, true);
				map[2+i][17] = new Tile(17*16, (2+i)*16, 1, 0, true);
				map[9+i][17] = new Tile(17*16, (9+i)*16, 1, 0, true);
			}for (i = 0; i < 2; i++){
				map[2][3+i] = new Tile((3+i)*16, 2*16, 1, 0, true);
				map[2][15+i] = new Tile((15+i)*16, 2*16, 1, 0, true);
				map[12][3+i] = new Tile((3+i)*16, 12*16, 1, 0, true);
				map[12][15+i] = new Tile((15+i)*16, 12*16, 1, 0, true);
			}for (i = 0; i < 6; i++){
				map[7][7+i] = new Tile((7+i)*16, 7*16, 1, 0, true);
				if (i < 5){
					map[5+i][9] = new Tile(9*16, (5+i)*16, 1, 0, true);
					map[5+i][10] = new Tile(10*16, (5+i)*16, 1, 0, true);
				}
			}
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
			entities.push(new Lynel(64, 64));
			entities.push(new LynelTurret(width-80, 64));
			entities.push(new Lynel(width-80, height-80));
			entities.push(new LynelTurret(64, height-80));
			enemyCount = 4;
			
			entities.push(new Bubble(7*16, 5*16));
			entities.push(new Bubble(12*16, 9*16));
		}
	}
}