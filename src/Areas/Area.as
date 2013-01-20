package Areas 
{
	import Entities.Octorok;
	import Entities.Player;
	import Entities.Tile;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Area 
	{	
		public var L_bitmap:Bitmap;
		public var LevelRenderer:BitmapData;
		public var _id:int;
		
		[Embed(source = '../resources/images/tileset.png')]
		protected var tile_set:Class;
		
		public var map:Array;
		public var entities:Array;
		public var playerIndex:int = -1;
		
		public function Area(width:int, height:int, id:int)
		{
			LevelRenderer = new BitmapData(width, height, false, 0x000000);
			L_bitmap = new Bitmap(LevelRenderer);
			_id = id;
			
			map = [];
			for (var i:int = 0; i < height/16; i++){
				var row:Array = [];
				for (var j:int = 0; j < width/16; j++){
					if (i == 0 || i == height/16-1)
						row.push(new Tile(j*16, i*16, 1, 0, true));
					else{
						if (j == 0 || j == width/16-1)
							row.push(new Tile(j*16, i*16, 1, 0, true));
						else row.push(new Tile(j*16, i*16, 0, 0));
					}
				}
				map.push(row);
			}
			
			entities = [];
			entities.push(new Player(32, 32));
			playerIndex = 0;
			entities.push(new Octorok(96, 96));
		}
		
		public function Render():void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0x000000);
			
			var i:int, j:int;
			var temp_sheet:Bitmap = new tile_set();
			for (i = 0; i < map.length; i++){
				for (j = 0; j < map[i].length; j++){
					var sprite_x:int = map[i][j].tileset_x*16;
					var sprite_y:int = map[i][j].tileset_y*16;
					var draw_x:int = j*16;
					var draw_y:int = i*16;
					LevelRenderer.copyPixels(temp_sheet.bitmapData,
						new Rectangle(sprite_x, sprite_y, 16, 16),
						new Point(draw_x, draw_y));
				}
			}for(i = 0; i < entities.length; i++){
				entities[i].Render(LevelRenderer);
			}
			
			var matrix:Matrix = new Matrix();
			matrix.translate(L_bitmap.x, L_bitmap.y);
			matrix.scale(Global.zoom, Global.zoom);
			Game.Screen.draw(L_bitmap, matrix);
			LevelRenderer.unlock();
		}
		
		public function Update():void
		{
			if (playerIndex >= 0) PlayerInput(entities[playerIndex]);
			for (var i:int = 0; i < entities.length; i++){
				entities[i].Update(entities, map);
			}
			if (playerIndex >= 0) UpdateView(entities[playerIndex]);
		}
		
		public function PlayerInput(player:Player):void
		{
			if (Global.CheckKeyPressed(Global.P_X_KEY) && player.state == player.NORMAL){
				if ((player.vel.x != 0 || player.vel.y != 0) && player.rollRest <= 0){
					player.vel.x *= 2;
					player.vel.y *= 2;
					player.state = player.ROLL_ATTACK;
					player.currFrame = 0;
					player.frameCount = 0;
				}
			}
			if (player.state != player.ROLL_ATTACK && player.rest <= 0){
				var p_speed:Number = player.topspeed;
				if (Global.CheckKeyDown(Global.P_RIGHT)){
					player.facing = Global.RIGHT;
					player.vel.x = p_speed;
				}else if (Global.CheckKeyDown(Global.P_LEFT)){
					player.facing = Global.LEFT;
					player.vel.x = -p_speed;
				}else player.vel.x = 0;
				
				if (Global.CheckKeyDown(Global.P_DOWN)){
					player.facing = Global.DOWN;
					player.vel.y = p_speed;
				}else if (Global.CheckKeyDown(Global.P_UP)){
					player.facing = Global.UP;
					player.vel.y = -p_speed;
				}else player.vel.y = 0;
			}
		}
		
		public function UpdateView(player:Player):void
		{
			var rb:Number = player.x+player.rb+64;
			var lb:Number = player.x+player.lb-64;
			var tb:Number = player.y+player.tb-64;
			var bb:Number = player.y+player.bb+64;
			var right:Number = Global.stageWidth-L_bitmap.x;
			var left:Number = 0-(L_bitmap.x);
			var top:Number = 0-(L_bitmap.y);
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
			if (L_bitmap.y > 0) L_bitmap.y = 0;
		}
	}
}