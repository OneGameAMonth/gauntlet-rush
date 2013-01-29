package Areas 
{
	import Entities.*;
	import Entities.Enemies.*;
	import Entities.Items.*;
	import Entities.Parents.LifeForm;
	import Entities.Parents.Enemy;
	import Entities.Parents.Projectile;
	import Entities.Dialogue.Dialogue;
	import Entities.Dialogue.LinkEndDialogue;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class Room09 extends Room
	{
		private var bossDead:Boolean;
		private var bossExists:Boolean;
		private var displayingDialogue:Boolean;
		
		
		public function Room09() 
		{
			super(320, 240, 1);
			bossDead = false;
			bossExists = false;
			displayingDialogue = false;
		}
		
		override public function CreateEntities():void
		{
			super.CreateEntities();
			//create portculli
			entities.push(new Portcullis(6*16-8, (height/16-1)*16, 1));
			
			entities.push(new Player(10*16-8, (height/16-2)*16));
			playerIndex = entities.length-1;
			
			//create enemies
			//entities.push(new Ganon(width/2-32, height/2-32));
			entities.push(new ZeldaEnd(width/2-8, height/2-64));
			
			entities.push(new StoneStatue(16, 16, 0, 0));
			entities.push(new StoneStatue(width-32, 16, 0, 1));
			entities.push(new StoneStatue(16, height-32, 0, 0));
			entities.push(new StoneStatue(width-32, height-32, 0, 1));
			
			//CREATE SOLIDS
			for (var i:int = 6; i < 14; i++){
				map[0][i] = new Tile(i*16, 0, 1, 0, true);
			}
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
				if ((entities[i] is Projectile || entities[i] is Enemy || entities[i] is StoneStatue) && displayingDialogue) continue;
				entities[i].Update(entities, map);
				if (entities[i] is Dialogue){ 
					displayingDialogue = true;
					if (killDialogue){
						displayingDialogue = false;
						entities.splice(i, 1);
						SoundManager.getInstance().playSfx("TextSound", 0, 1);
						continue;
					}else if (!bossExists) bossExists = true;
				}
				if (entities[i].delete_me || ((bossDead || !bossExists) && (entities[i] is Enemy || entities[i] is Projectile))){
					if (entities[i] is Triforce){
						entities.push(new LinkEndDialogue());
					}
					if (entities[i] is Enemy || entities[i] is Projectile){
						if (entities[i] is Ganon){
							bossDead = true;
							entities.push(new Triforce(entities[i].x+32, entities[i].y+32));
							entities.push(new EnemyDie(entities[i].x+16, entities[i].y+16, false, 2));
							
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
					if (entities[i] is HeartContainer) heartIndex = i;
				}
			}for (i = 0; i < entities.length; i++){ if (entities[i] is Player) playerIndex = i; }
			
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