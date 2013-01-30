package Areas 
{
	import Entities.*;
	import Entities.Enemies.*;
	import Entities.Items.*;
	import Entities.Parents.LifeForm;
	import Entities.Parents.Enemy;
	import Entities.Parents.Projectile;
	import Entities.Dialogue.Dialogue;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.*;
	import Entities.Dialogue.LinkMidDialogue;
	
	public class Room05 extends Room
	{
		public var displayedDialogue:Boolean;
		public var displayingDialogue:Boolean;
		public var bossDead:Boolean;
		
		public function Room05() 
		{
			super(320, 240, 1);
			displayedDialogue = false;
			displayingDialogue = false;
			bossDead = false;
			
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
			ReloadHearts();
			entities.push(new CloudDisappear(13*16, 16));
			entities.push(new SavePoint(13*16+6, 16+6, 6));
		}
		
		override public function ReloadHearts():void
		{
			entities.push(new CloudDisappear(width/2-8, height/2));
			if (Global.GAME_MODE != Global.HARD)
				entities.push(new HeartContainer(6*16+3, 16+3));
			else entities.push(new Fairy(6*16, 16));
		}
		
		override public function Update():void
		{
			if (playerIndex >= 0) PlayerInput(entities[playerIndex]);
			playerIndex = -1;
			if (enemyCount <= 0 && portcullisIndex >= 0){
				SoundManager.getInstance().playSfx("UnlockSound", 0, 1);
				entities.push(new ToNextRoom(
					entities[portcullisIndex].x, entities[portcullisIndex].y-16));
				entities.splice(portcullisIndex, 1);
				portcullisIndex = -1;
			}
			
			var heartIndex:int = -1;
			var i:int;
			for (i = entities.length-1; i >= 0; i--){
				if ((entities[i] is Enemy || entities[i] is StoneStatue || entities[i] is Projectile) && displayingDialogue) continue;
				entities[i].Update(entities, map);
				if (entities[i] is Dialogue && killDialogue){ 
					entities.splice(i, 1);
					SoundManager.getInstance().playSfx("TextSound", 0, 1);
					displayingDialogue = false;
					continue;
				}
				if (entities[i].delete_me || 
						(bossDead && (entities[i] is Enemy || entities[i] is Projectile))){
					if (entities[i] is Enemy || entities[i] is Projectile){
						if (entities[i] is Gohma){
							bossDead = true;
							entities.push(new EnemyDie(width/2-16, height/2-8, false, 2));
							
							if (portcullisIndex >= 0){
								SoundManager.getInstance().playSfx("UnlockSound", 0, 1);
								entities.push(new ToNextRoom(
									entities[portcullisIndex].x, entities[portcullisIndex].y-16));
								entities.splice(portcullisIndex, 1);
								portcullisIndex = -1;
							}
						}
						else if (entities[i] is Enemy) entities.push(new EnemyDie(entities[i].x, entities[i].y, false));
						else if (entities[i] is Projectile) entities.push(new EnemyDie(entities[i].x, entities[i].y , true));
						if (entities[i] is Enemy) enemyCount--;
					}
					entities.splice(i, 1);
				}
				if (Global.HP <= 0 && !(entities[i] is Player)) entities.splice(i, 1);
				if (entities[i] is HeartContainer || entities[i] is SavePoint || entities[i] is CloudDisappear){
					if (portcullisIndex < 0) entities[i].visible = true;
					if (entities[i] is HeartContainer || entities[i] is Fairy) heartIndex = i;
				}
			}for (i = 0; i < entities.length; i++){ if (entities[i] is Player) playerIndex = i; }
			if (heartIndex < 0 && !displayedDialogue && Global.HP > 0){
				entities.push(new LinkMidDialogue());
				displayingDialogue = true;
				displayedDialogue = true;
			}
			
			if (playerIndex >= 0) UpdateView(entities[playerIndex]);
			if (Global.HP <= 0){ 
				if (playerIndex >= 0){ 
					entities[playerIndex].StopAll();
				}
				ReloadSaveGame();
			}
		}
	}
}