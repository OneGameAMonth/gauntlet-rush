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
	import flash.geom.ColorTransform;
	import flash.utils.*;
	
	public class Room09 extends Room
	{
		private var bossDead:Boolean;
		private var bossExists:Boolean;
		private var displayingDialogue:Boolean;
		private var endGameTimer:int;
		private var playingMusic:Boolean;
		
		public function Room09() 
		{
			super(320, 240, 1);
			bossDead = false;
			bossExists = false;
			displayingDialogue = false;
			endGameTimer = -1;
			playingMusic = true;
			
			//CREATE SOLIDS
			for (var i:int = 6; i < 14; i++){
				map[0][i] = new Tile(i*16, 0, 1, 0, true);
			}
		}
		
		override public function CreateEntities():void
		{
			super.CreateEntities();
			//create portculli
			PortcullisCloud(height-16);
			entities.push(new Portcullis(6*16, (height/16-1)*16, 1));
			
			entities.push(new Player(10*16-8, (height/16-2)*16));
			playerIndex = entities.length-1;
			
			//create enemies
			//entities.push(new Ganon(width/2-32, height/2-32));
			entities.push(new ZeldaEnd(width/2-8, height/2-64));
			
			entities.push(new StoneStatue(16, 16, 0, 0));
			entities.push(new StoneStatue(width-32, 16, 0, 1));
			entities.push(new StoneStatue(16, height-32, 0, 0));
			entities.push(new StoneStatue(width-32, height-32, 0, 1));
			
			playingMusic = false;
		}
		
		override public function Update():void
		{	
			if (!bossExists || (bossDead && endGameTimer < 0)){
				if (!playingMusic){
					SoundManager.getInstance().stopAllMusic();
					SoundManager.getInstance().playMusic("DeathMountainMusic", -5, int.MAX_VALUE);
					playingMusic = true;
				}
			}
			else if (bossExists && !bossDead && !playingMusic){
				playingMusic = true;
				SoundManager.getInstance().stopAllMusic();
				SoundManager.getInstance().playMusic("BossMusic", -5, int.MAX_VALUE);
			}
			endGameTimer--;
			if (endGameTimer == 0) Game.state = Game.SCORE_SCREEN;
			
			if (playerIndex >= 0) PlayerInput(entities[playerIndex]);
			playerIndex = -1;

			var heartIndex:int = -1;
			var i:int;
			for (i = entities.length-1; i >= 0; i--){
				if ((entities[i] is Projectile || entities[i] is Enemy || entities[i] is StoneStatue) && displayingDialogue) continue;
				entities[i].Update(entities, map);
				if (entities[i] is Dialogue){ 
					displayingDialogue = true;
					if (killDialogue){
						displayingDialogue = false;
						if (bossDead){ 
							endGameTimer = 255;
							SoundManager.getInstance().stopAllMusic();
							SoundManager.getInstance().playMusic("EndingMusic", -5, int.MAX_VALUE);
						}
						entities.splice(i, 1);
						SoundManager.getInstance().playSfx("TextSound", 0, 1);
						continue;
					}else if (!bossExists){ 
						bossExists = true;
						playingMusic = false;
					}
				}
				if (entities[i].delete_me || ((bossDead || !bossExists) && (entities[i] is Enemy || entities[i] is Projectile))){
					if (entities[i] is Triforce){
						entities.push(new LinkEndDialogue(entities));
					}
					if (entities[i] is Enemy || entities[i] is Projectile){
						if (entities[i] is Ganon){
							Global.currScore += 3000;
							bossDead = true;
							SoundManager.getInstance().stopAllMusic();
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
						else if (entities[i] is Enemy){ 
							Global.currScore += (entities[i].maxHP+entities[i].atkPow)*100*(Global.GAME_MODE+1);
							entities.push(new EnemyDie(entities[i].x, entities[i].y, false));
						}
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
			}for (i = 0; i < entities.length; i++){ 
				if (entities[i] is Player){ 
					playerIndex = i; 
					if (endGameTimer > 0) entities[i].rest = endGameTimer*2;
				}
			}
			
			if (playerIndex >= 0) UpdateView(entities[playerIndex]);
			if (Global.HP <= 0){ 
				if (playerIndex >= 0){ 
					entities[playerIndex].StopAll();
				}
				ReloadSaveGame();
			}
		}
		
		override public function Render():void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0x000000);
			
			var dialogue:Array = [];
			var i:int, j:int;
			var tile_sheet:Bitmap = new tile_set();
			for (i = 0; i < map.length; i++){
				for (j = 0; j < map[i].length; j++){
					var sprite_x:int = map[i][j].tileset_x*16;
					var sprite_y:int = map[i][j].tileset_y*16;
					var draw_x:int = j*16;
					var draw_y:int = i*16;
					LevelRenderer.copyPixels(tile_sheet.bitmapData,
						new Rectangle(sprite_x, sprite_y, 16, 16),
						new Point(draw_x, draw_y));
				}
			}for(i = entities.length-1; i >= 0; i--){
				if (entities[i] is Dialogue) dialogue.push(entities[i]);
				else{ 
					entities[i].Render(LevelRenderer);
					if (entities[i] is Ganon){
						var hp:Number = entities[i].hp;
						var maxHP:Number = entities[i].maxHP;
						LevelRenderer.fillRect(new Rectangle(7*16, 2, 96, 14), 0x000000);
				LevelRenderer.fillRect(new Rectangle(7*16+2, 4, 92*(hp/maxHP), 10), 0xF83800);
					}
				}
			}for (i = dialogue.length-1; i >= 0; i--){
				dialogue[i].Render(LevelRenderer);
			}
			
			var color:ColorTransform = new ColorTransform();
			if (Global.HP <= 0){ 
				color.redOffset = 128;
				color.greenOffset = 0;
				color.blueOffset = 0;
			}else if (endGameTimer >= 0){
				color.redMultiplier = endGameTimer*(4/255);
				color.greenMultiplier = endGameTimer*(4/255);
				color.blueMultiplier = endGameTimer*(4/255); 
			}
			var matrix:Matrix = new Matrix();
			matrix.translate(L_bitmap.x, L_bitmap.y);
			matrix.scale(Global.zoom, Global.zoom);
			Game.Renderer.draw(L_bitmap, matrix, color);
			LevelRenderer.unlock();
		}
	}
}