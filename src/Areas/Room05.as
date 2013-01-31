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
	import flash.geom.ColorTransform;
	import Entities.Dialogue.LinkMidDialogue;
	
	public class Room05 extends Room
	{
		public var displayedDialogue:Boolean;
		public var displayingDialogue:Boolean;
		public var bossDead:Boolean;
		public var playingMusic:Boolean;
		
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
			playingMusic = false;
		}		
		
		override public function CreateEntities():void
		{
			super.CreateEntities();
			//create portculli
			entities.push(new Portcullis(6*16, 0, 0));
			portcullisIndex = entities.length-1;
			PortcullisCloud(height-16);
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
				entities.push(new HeartContainer(width/2+3-8, height/2+3));
			else{
				var noFairy:Boolean = true;
				for (var i:int = 0; i < entities.length; i++){
					if (entities[i] is Fairy) noFairy = false;
				}if (noFairy) entities.push(new Fairy(width/2-8, height/2));
			}
		}
		
		override public function Render():void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0x000000);
			
			var gohmaIndex:int = -1;
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
					if (entities[i] is Gohma){
						gohmaIndex = i;
					}
				}
			}
			if (gohmaIndex >= 0){
				var hp:Number = entities[gohmaIndex].hp;
				var maxHP:Number = entities[gohmaIndex].maxHP;
				LevelRenderer.fillRect(new Rectangle(7*16, 2, 96, 14), 0x000000);
				LevelRenderer.fillRect(new Rectangle(7*16+2, 4, 92*(hp/maxHP), 10), 0xF83800);
			}
			for (i = dialogue.length-1; i >= 0; i--){
				dialogue[i].Render(LevelRenderer);
			}
			
			var color:ColorTransform = new ColorTransform();
			if (Global.HP <= 0){ 
				color.redOffset = 128;
				color.greenOffset = 0;
				color.blueOffset = 0;
			}
			var matrix:Matrix = new Matrix();
			matrix.translate(L_bitmap.x, L_bitmap.y);
			matrix.scale(Global.zoom, Global.zoom);
			Game.Renderer.draw(L_bitmap, matrix, color);
			LevelRenderer.unlock();
		}
		
		override public function Update():void
		{
			if (!bossDead && !playingMusic && enemyCount > 0){
				playingMusic = true;
				SoundManager.getInstance().stopAllMusic();
				SoundManager.getInstance().playMusic("MinibossMusic", -5, int.MAX_VALUE);
			}else if (bossDead && !playingMusic){
				playingMusic = true;
				SoundManager.getInstance().stopAllMusic();
				SoundManager.getInstance().playMusic("LabyrinthMusic", -5, int.MAX_VALUE);
			}
			
			if (playerIndex >= 0) PlayerInput(entities[playerIndex]);
			playerIndex = -1;
			if (enemyCount <= 0 && portcullisIndex >= 0){
				SoundManager.getInstance().playSfx("UnlockSound", 0, 1);
				entities.push(new ToNextRoom(
					entities[portcullisIndex].x, entities[portcullisIndex].y-16));
				entities.splice(portcullisIndex, 1);
				PortcullisCloud();
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
						((bossDead || enemyCount <= 0) && (entities[i] is Enemy || entities[i] is Projectile))){
					if (entities[i] is Enemy || entities[i] is Projectile){
						if (entities[i] is Gohma){
							SoundManager.getInstance().stopAllMusic();
							Global.currScore += 1000;
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
						else if (entities[i] is Enemy){ 
							Global.currScore += (entities[i].maxHP+entities[i].atkPow)*100*(1+Global.GAME_MODE);
							entities.push(new EnemyDie(entities[i].x, entities[i].y, false));
						}
						else if (entities[i] is Projectile) entities.push(new EnemyDie(entities[i].x, entities[i].y , true));
						if (entities[i] is Enemy) enemyCount--;
					}
					entities.splice(i, 1);
				}
				if (Global.HP <= 0 && !(entities[i] is Player)) entities.splice(i, 1);
				if (entities[i] is HeartContainer || entities[i] is Fairy || entities[i] is SavePoint || entities[i] is CloudDisappear){
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