package Areas 
{
	import Entities.Enemies.*;
	import Entities.Tile;
	import Entities.Items.Portcullis;
	import Entities.Items.SavePoint;
	import Entities.Items.HeartContainer;
	import Entities.Player;
	
	public class Room07 extends Room
	{
		
		public function Room07() 
		{
			super(320, 240, 1);
			
			//CREATE SOLIDS
			for (var i:int = 6; i < width/16-6; i++){
				map[height/16-1][i] = new Tile(i*16, height-16, 1, 0, true);
			}
		}
		
		override public function CreateEntities():void
		{
			super.CreateEntities();
			//create portculli
			entities.push(new Portcullis(6*16, 0, 0));
			portcullisIndex = entities.length-1;
			
			entities.push(new Player(10*16-8, (height/16-2)*16));
			playerIndex = entities.length-1;
			
			//create enemies
			enemyCount = 1;
			
			//create items
			entities.push(new HeartContainer(6*16+3, 16+3));
			entities.push(new SavePoint(13*16+6, 16+6));
		}
	}
}