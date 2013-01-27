package Areas 
{
	import Entities.*;
	import Entities.Items.*;
	import Entities.Enemies.Gohma;
	import Entities.Enemies.EnemyDie;
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
	
	public class Room
	{	
		public var L_bitmap:Bitmap;
		public var LevelRenderer:BitmapData;
		public var _id:int;
		
		public var width:int;
		public var height:int;
		
		[Embed(source = '../resources/images/heart_hud_sheet.png')]
		protected var heart_hud_sheet:Class;
		[Embed(source = '../resources/images/tileset.png')]
		protected var tile_set:Class;
		
		protected var HUD_sprite:Sprite;
		protected var killDialogue:Boolean;
		
		public var map:Array;
		public var entities:Array;
		public var playerIndex:int = -1;
		
		public var enemyCount:int = 0;
		public var portcullisIndex:int = -1;
		
		public function Room(width:int, height:int, id:int)
		{
			HUD_sprite = new Sprite();
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
			
			
			//DRAW HUD
			for (i = 0; i < HUD_sprite.numChildren;i++){ HUD_sprite.removeChildAt(i); }
			var temp_image:Bitmap = new Bitmap(new BitmapData(Global.MAX_HP*15, 16));
			DrawHeartHUD(temp_image, new heart_hud_sheet());
			LevelRenderer.draw(HUD_sprite);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(L_bitmap.x, L_bitmap.y);
			matrix.scale(Global.zoom, Global.zoom);
			Game.Screen.draw(L_bitmap, matrix);
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
				portcullisIndex = -1;
			}
			
			for (var i:int = entities.length-1; i >= 0; i--){
				entities[i].Update(entities, map);
				if (entities[i] is Dialogue && killDialogue){ 
					entities.splice(i, 1);
					continue;
				}
				if (entities[i].delete_me){
					if (entities[i] is Enemy || entities[i] is Projectile){
						entities.push(new EnemyDie(entities[i].x, entities[i].y));
						if (entities[i] is Enemy) enemyCount--;
					}
					entities.splice(i, 1);
				}
				if (entities[i] is Player) playerIndex = i;
				if (entities[i] is HeartContainer || entities[i] is SavePoint || entities[i] is CloudDisappear){
					if (portcullisIndex < 0) entities[i].visible = true;
				}
			}
			if (playerIndex >= 0) UpdateView(entities[playerIndex]);
			if (Global.HP <= 0) ReloadSaveGame();
		}
		
		public function Restart():void
		{
			CreateEntities();
		}
		
		public function ReloadSaveGame():void
		{
			Game.roomIndex = Save.ROOM_INDEX;
			Global.MAX_HP = Save.MAX_HP;
			Global.HP = Save.HP;
			
			var pIndex:int = Game.roomArray[Game.roomIndex].playerIndex;
			Game.roomArray[Game.roomIndex].entities[pIndex].Restart(Save.PLAYER_X, Save.PLAYER_Y, Global.UP);
			for (var i:int = Game.roomIndex+1; i < Game.roomArray.length; i++){
				Game.roomArray[i].Restart();
			}
		}
		
		public function PlayerInput(player:Player):void
		{	
			if (Global.CheckKeyPressed(Global.P_X_KEY)) killDialogue = true;
			else killDialogue = false;
			
			if (player.rest > 0 || player.state == LifeForm.HURT_BOUNCE) return;
			if (Global.CheckKeyPressed(Global.P_Z_KEY) && player.state != Player.SPIN_SWORD_ATTACK && player.noSwordCounter <= 0){
				SoundManager.getInstance().playSfx("SwordSound", 0, 1);
				if (player.state == LifeForm.NORMAL){
					player.vel.x = 0;
					player.vel.y = 0;
					player.frameCount = 0;
				}else if (player.state == Player.ROLL_ATTACK){
					if (player.currFrame < 1) return;
					player.vel.x *= 1.5;
					player.vel.y *= 1.5;
					player.frameCount = 1;
				}
				player.swordCharge = 1;
				player.currFrame = 0;
				player.rest = 1;
				entities.push(
					new PlayerSword(player.x-16, player.y-16, player.facing));
				player.state = Player.SWORD_ATTACK;
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
		
		public function DrawHeartHUD(temp_image:Bitmap, temp_sheet:Bitmap):void
		{			
			for (var i:int = 0; i < Global.MAX_HP; i++){
				var sprite_x:int = 0;
				if (Global.HP == i+0.5) sprite_x = 1*15;
				else if (Global.HP < i+0.5) sprite_x = 2*15;
				temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
					new Rectangle(sprite_x, 0, 15, 16), 
					new Point(i*15,0)
				);
			}
			
			HUD_sprite.addChild(temp_image);
		}
	}
}