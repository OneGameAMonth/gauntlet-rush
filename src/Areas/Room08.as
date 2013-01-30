package Areas 
{
	import Entities.Enemies.*;
	import Entities.Tile;
	import Entities.Items.Portcullis;
	import Entities.Player;
	import Entities.Items.SavePoint;
	import Entities.Items.HeartContainer;
	import Entities.Items.CloudDisappear;
	import Entities.Items.Fairy;
	
	public class Room08 extends Room
	{
		
		public function Room08()
		{
			super(320, 240, 1);
			
			//create solids!!!
			for (var i:int = 0; i < 8; i++){
				for (var j:int = 0; j < 7; j++){
					map[4+j][6+i] = new Tile((6+i)*16, (4+j)*16, 1, 0, true);
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
			entities.push(new Darknut(64, height/2-32));
			entities.push(new Darknut(width-80, height/2-32));
			entities.push(new Wizrobe(width/2-8, 32, 6*16, 4*16, 8*16, 6*16));
			entities.push(new Wizrobe(48, height-64, 6*16, 4*16, 8*16, 6*16));
			entities.push(new Wizrobe(width-64, height-64, 6*16, 4*16, 8*16, 6*16));
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
			if (Global.GAME_MODE != Global.HARD)
				entities.push(new HeartContainer(6*16+3, 16+3));
			else entities.push(new Fairy(6*16, 16));
		}
	}
}