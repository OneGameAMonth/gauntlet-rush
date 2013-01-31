package Areas 
{
	import Entities.*;
	import Entities.Items.*;
	import Entities.Enemies.Gohma;
	import Entities.Items.EnemyDie;
	import Entities.Parents.LifeForm;
	import Entities.Parents.Enemy;
	import Entities.Parents.Projectile;
	import Entities.Dialogue.Dialogue;
	import Screens.PlayGame;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.utils.*;
	
	public class Room
	{	
		public var L_bitmap:Bitmap;
		public var LevelRenderer:BitmapData;
		public var _id:int;
		
		public var width:int;
		public var height:int;
		
		[Embed(source = '../resources/images/tileset.png')]
		protected var tile_set:Class;
		
		protected var killDialogue:Boolean;
		
		public var map:Array;
		public var entities:Array;
		public var playerIndex:int = -1;
		
		public var enemyCount:int = 0;
		public var portcullisIndex:int = -1;
		
		public function Room(width:int, height:int, id:int)
		{
			LevelRenderer = new BitmapData(width, height, false, 0x000000);
			L_bitmap = new Bitmap(LevelRenderer);
			_id = id;
			this.width = width;
			this.height = height;
			killDialogue = false;
			
			map = [];
			for (var i:int = 0; i < height/16; i++){
				var row:Array = [];
				for (var j:int = 0; j < width/16; j++){
					if ((i == 0 || i == height/16-1) && !(j > 5 && j < width/16-6))
						row.push(new Tile(j*16, i*16, 1, 0, true));
					else{
						if (j == 0 || j == width/16-1)
							row.push(new Tile(j*16, i*16, 1, 0, true));
						else row.push(new Tile(j*16, i*16, 0, 0));
					}
				}
				map.push(row);
			}
			CreateEntities();
		}
		
		public function CreateEntities():void
		{
			entities = [];
			playerIndex = -1;
		}
		
		public function KillAllEnemies():void
		{
			for (var i:int = entities.length-1; i >= 0; i--){
				if (entities[i] is Enemy){
					entities.splice(i, 1);
					enemyCount--;
				}else if (entities[i] is HeartContainer)
					entities.splice(i, 1);
			}
		}
		
		public function Render():void
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
				else entities[i].Render(LevelRenderer);
			}for (i = dialogue.length-1; i >= 0; i--){
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
		
		public function Update():void
		{
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
			
			var i:int;
			for (i = entities.length-1; i >= 0; i--){
				if ((entities[i] is Projectile || entities[i] is Enemy) && enemyCount <= 0) entities[i].delete_me = true;
				entities[i].Update(entities, map);
				if (entities[i] is Dialogue && killDialogue){ 
					entities.splice(i, 1);
					SoundManager.getInstance().playSfx("TextSound", 0, 1);
					continue;
				}
				if (entities[i].delete_me){
					if (entities[i] is Enemy){
						Global.currScore += (entities[i].maxHP+entities[i].atkPow)*100*(1+Global.GAME_MODE);
						entities.push(new EnemyDie(entities[i].x, entities[i].y, false));
						enemyCount--;
					}else if (entities[i] is Projectile){
						entities.push(new EnemyDie(entities[i].x, entities[i].y, true));
					}
					entities.splice(i, 1);
				}
				if (Global.HP <= 0 && !(entities[i] is Player)) entities.splice(i, 1);
				if (entities[i] is HeartContainer || entities[i] is SavePoint || entities[i] is CloudDisappear || entities[i] is Fairy){
					if (portcullisIndex < 0) entities[i].visible = true;
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
		
		public function PortcullisCloud(h:int = 0):void
		{
			entities.push(new CloudDisappear(6*16, h, true, 0));
			entities.push(new CloudDisappear(7*16, h, true, 0));
			entities.push(new CloudDisappear(8*16, h, true, 0));
			entities.push(new CloudDisappear(9*16, h, true, 0));
			entities.push(new CloudDisappear(10*16, h, true, 0));
			entities.push(new CloudDisappear(11*16, h, true, 0));
			entities.push(new CloudDisappear(12*16, h, true, 0));
			entities.push(new CloudDisappear(13*16, h, true, 0));
		}
		
		public function Restart():void
		{
			CreateEntities();
		}
		
		public function ReloadHearts():void
		{
		}
		
		public function ReloadSaveGame():void
		{	
			Global.DeathTimer--;
			if (Global.DeathTimer == Global.DeathTimerLimit-1 && playerIndex >= 0){
				entities[playerIndex].facing = Global.DOWN;
				Global.currScore -= 1000;
				if (Global.currScore <= 0) Global.currScore = 0;
			}
			else if (Global.DeathTimer%10==0 && Global.DeathTimer >= 40){
				if (playerIndex >= 0){ 
					entities[playerIndex].NextFacing();
					entities[playerIndex].NextFacing();
	
				}
			}
			
			if (Global.DeathTimer <= 0){
				PlayGame.RestartGame();
				Global.DeathTimer = Global.DeathTimerLimit;
			}
		}
		
		public function PlayerInput(player:Player):void
		{	
			if (Global.CheckKeyPressed(Global.P_X_KEY)) killDialogue = true;
			else killDialogue = false;
			
			if (player.rest > 0 || player.state == LifeForm.HURT_BOUNCE) return;
			if (Global.CheckKeyPressed(Global.P_Z_KEY) && player.state != Player.SPIN_SWORD_ATTACK){
				if (player.noSwordCounter > 0) SoundManager.getInstance().playSfx("HitSound", 0, 1);
				else{
					SoundManager.getInstance().playSfx("SwordSound", 0, 1);
					if (player.state == LifeForm.NORMAL){
						player.vel.x = 0;
						player.vel.y = 0;
						player.frameCount = 0;
					}else if (player.state == Player.ROLL_ATTACK){
						player.vel.x *= 1.5;
						player.vel.y *= 1.5;
						player.frameCount = 1;
					}
					player.swordCharge = 1;
					player.currFrame = 0;
					entities.push(
						new PlayerSword(player.x-16, player.y-16, player.facing));
					player.state = Player.SWORD_ATTACK;
				}
			}if (Global.CheckKeyDown(Global.P_Z_KEY) && player.swordCharge > 0  && player.noSwordCounter <= 0){
				if (player.swordCharge < 60){
					player.swordCharge++;
					if (player.swordCharge == 15)
						SoundManager.getInstance().playSfx("MagicalRodSound", 0, 1);
				}
			}else if (player.state == LifeForm.NORMAL){
				if (player.swordCharge >= 15){
					player.spinSword = 0;
					player.state = Player.SPIN_SWORD_ATTACK;
					player.vel.x = 0;
					player.vel.y = 0;
				}
				player.swordCharge = 0;
			}
			if (Global.CheckKeyPressed(Global.P_X_KEY) && player.state == LifeForm.NORMAL){
				if ((player.vel.x != 0 || player.vel.y != 0) && player.rollRest <= 0){
					SoundManager.getInstance().playSfx("RollSound", 0, 1);
					var rollVert:Boolean, rollHor:Boolean;
					rollHor = (player.swordCharge <= 0 || (player.facing != Global.LEFT && player.facing != Global.RIGHT));
					rollVert = (player.swordCharge <= 0 || (player.facing != Global.UP && player.facing != Global.DOWN));
					if (player.vel.x > 0 && rollHor) player.vel.x = 6;
					else if (player.vel.x < 0 && rollHor) player.vel.x = -6;
					if (player.vel.y > 0 && rollVert) player.vel.y = 6;
					else if (player.vel.y < 0 && rollVert) player.vel.y = -6;
					
					if (Math.abs(player.vel.y) != 6 && Math.abs(player.vel.x) != 6) return;
					player.state = Player.ROLL_ATTACK;
					player.currFrame = 0;
					player.frameCount = 0;
				}
			}if (player.state == LifeForm.NORMAL || player.state == Player.SPIN_SWORD_ATTACK){
				var p_speed:Number = player.topspeed;
				if (player.state == Player.SPIN_SWORD_ATTACK) p_speed *= 1.5;
				else if (player.swordCharge > 0) p_speed/=2;
				var useSword:Boolean = (player.swordCharge > 0 || player.state == Player.SPIN_SWORD_ATTACK);
				
				if (Global.CheckKeyDown(Global.P_DOWN)){
					if (!useSword) player.facing = Global.DOWN;
					player.vel.x = 0;
					player.vel.y = p_speed;
				}else if (Global.CheckKeyDown(Global.P_UP)){
					if (!useSword) player.facing = Global.UP;
					player.vel.x = 0;
					player.vel.y = -p_speed;
				}
				else{
					player.vel.y = 0;
					if (Global.CheckKeyDown(Global.P_RIGHT)){
						if (!useSword) player.facing = Global.RIGHT;
						player.vel.y = 0;
						player.vel.x = p_speed;
					}else if (Global.CheckKeyDown(Global.P_LEFT)){
						if (!useSword) player.facing = Global.LEFT;
						player.vel.y = 0;
						player.vel.x = -p_speed;
					}else player.vel.x = 0;
				}
			}else if (player.state == Player.SWORD_ATTACK){
				if (Global.CheckKeyPressed(Global.P_DOWN))
					player.facing = Global.DOWN;
				else if (Global.CheckKeyPressed(Global.P_UP))
					player.facing = Global.UP;
				else if (Global.CheckKeyPressed(Global.P_RIGHT))
					player.facing = Global.RIGHT;
				else if (Global.CheckKeyPressed(Global.P_LEFT))
					player.facing = Global.LEFT;
			}
		}
		
		public function UpdateView(player:Player):void
		{
			var hudHeight:int = 0;
			
			var rb:Number = player.x+player.rb+64;
			var lb:Number = player.x+player.lb-64;
			var tb:Number = player.y+player.tb-64;
			var bb:Number = player.y+player.bb+64;
			var right:Number = Global.stageWidth-L_bitmap.x;
			var left:Number = 0-(L_bitmap.x);
			var top:Number = 0-(L_bitmap.y)+hudHeight;
			var bottom:Number = Global.stageHeight-L_bitmap.y;
			
			var v_movespeed:Number = Math.abs(player.vel.x);
			if (v_movespeed == 0) v_movespeed = Math.abs(player.vel.y);
			//move view right and left
			if (rb > right) L_bitmap.x-= v_movespeed;
			else if (lb < left) L_bitmap.x+= v_movespeed;
			//move view up and down
			if (tb < top) L_bitmap.y += v_movespeed;
			else if (bb > bottom) L_bitmap.y-= v_movespeed;
				
			//prevent viewing off the edge
			if (L_bitmap.x < (-1)*(L_bitmap.width-Global.stageWidth))
				L_bitmap.x = (-1)*(L_bitmap.width-Global.stageWidth);
			if (L_bitmap.x > 0) L_bitmap.x = 0;
			
			if (L_bitmap.y < (L_bitmap.height-Global.stageHeight)*(-1))
				L_bitmap.y = (L_bitmap.height-Global.stageHeight)*(-1);
			if (L_bitmap.y > hudHeight) L_bitmap.y = hudHeight;
		}
		
	}
}