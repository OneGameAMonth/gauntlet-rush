package Screens 
{
	import Areas.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class PlayGame
	{
		public static var roomArray:Array;
		public static var roomIndex:int;
		
		public static var dataManager:DataManager;
		public static var musicPlaying:String = "Battle";
		
		[Embed(source = '../resources/images/heart_hud_sheet.png')]
		protected var heart_hud_sheet:Class;
		protected var HUD_sprite:Sprite;
		
		//text stuff
		[Embed(source = '../resources/04B_03.ttf', fontName='pixelFont',
		       mimeType='application/x-font', embedAsCFF='false')]
		private var pixelFont:Class;
		private var textFormat:TextFormat = new TextFormat();
		private var uiText:TextField = new TextField();
		
		public function PlayGame() 
		{
			Global.MAX_HP = 3;
			Global.HP = Global.MAX_HP;
			HUD_sprite = new Sprite();
			
			roomArray = [];
			roomArray.push(new Room00());
			roomArray.push(new Room01());
			roomArray.push(new Room02());
			roomArray.push(new Room03());
			roomArray.push(new Room04());
			roomArray.push(new Room05());
			roomArray.push(new Room06());
			roomArray.push(new Room07());
			roomArray.push(new Room08());
			roomArray.push(new Room09());
			roomIndex = 0;
			
			dataManager = new DataManager();
			
			//ready the fonts
			textFormat = new TextFormat("pixelFont", 12, 0xFFFFFF);
			uiText.embedFonts = true;
			uiText.defaultTextFormat = textFormat;
			uiText.width = Global.stageWidth;
			uiText.height = Global.stageHeight;
		}		
		
		public function Update():void
		{
			if (Global.CheckKeyPressed(Global.ENTER) || Global.CheckKeyPressed(Global.ESC)){ 
				Game.state = Game.PAUSE_SCREEN;
				SoundManager.getInstance().playSfx("SelectSound", 0, 1);
			}
			
			if (roomIndex <= 4 && musicPlaying != "Battle"){
				SoundManager.getInstance().stopAllMusic();
				SoundManager.getInstance().playMusic("BattleMusic", -5, int.MAX_VALUE);
				musicPlaying = "Battle";
			}else if (roomIndex > 5 && roomIndex <= 8 && musicPlaying != "Labyrinth"){
				SoundManager.getInstance().stopAllMusic();
				SoundManager.getInstance().playMusic("LabyrinthMusic", -5, int.MAX_VALUE);
				musicPlaying = "Labyrinth";
			}
			roomArray[roomIndex].Update();
		}
		
		public function Render():void
		{
			roomArray[roomIndex].Render();
			
			//DRAW HUD
			var i:int;
			for (i = 0; i < HUD_sprite.numChildren;i++){ HUD_sprite.removeChildAt(i); }
			var temp_image:Bitmap = new Bitmap(new BitmapData(Global.MAX_HP*15, 16));
			DrawHeartHUD(temp_image, new heart_hud_sheet());
			var matrix:Matrix = new Matrix();
			matrix.scale(Global.zoom, Global.zoom);
			Game.Renderer.draw(HUD_sprite, matrix);
			
			uiText.text = "L"+roomIndex+": ";
			for (i = (""+Global.currScore).length; i < 5; i++){
				uiText.appendText("0");
			}uiText.appendText(Global.currScore+"");
			Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 224*Global.zoom, 0*Global.zoom));
		}
		
		public static function StartGame(newGame:Boolean):void
		{
			SoundManager.getInstance().stopAllMusic();
			SoundManager.getInstance().playMusic("BattleMusic", -5, int.MAX_VALUE);
			if (newGame){
				for (var i:int = 0; i < PlayGame.roomArray.length; i++){
					roomArray = [];
					roomArray.push(new Room00());
					roomArray.push(new Room01());
					roomArray.push(new Room02());
					roomArray.push(new Room03());
					roomArray.push(new Room04());
					roomArray.push(new Room05());
					roomArray.push(new Room06());
					roomArray.push(new Room07());
					roomArray.push(new Room08());
					roomArray.push(new Room09());
					Global.currScore = 0;
					Global.HP = 3;
					Global.MAX_HP = 3;
					roomIndex = 0;
				}
			}
			else{ 
				ReloadSavedGame();
				if (DataManager.ROOM_INDEX == 0)
					roomArray[0].Restart();
				roomArray[9] = new Room09();
				roomArray[5] = new Room05();
			}
			musicPlaying = "";
		}
		
		public static function ReloadSavedGame():void
		{
			var data:Object = dataManager.GetCookieVal("gauntlet-data");
			if (data != null){
				var dataString:String;
				dataString = data as String;
				dataManager.DeconstructCookieData(dataString);
				if (DataManager.ROOM_INDEX > 0) RestartGame();
			}
		}
		
		public static function RestartGame():void
		{
			roomIndex = DataManager.ROOM_INDEX;
			Global.MAX_HP = DataManager.MAX_HP;
			Global.HP = DataManager.HP;
			
			var pIndex:int = roomArray[roomIndex].playerIndex;
			roomArray[roomIndex].entities[pIndex].Restart(DataManager.PLAYER_X, DataManager.PLAYER_Y);
			roomArray[roomIndex].KillAllEnemies();
			for (var i:int = PlayGame.roomIndex+1; i < PlayGame.roomArray.length; i++){
				roomArray[i].Restart();
			}
			if (DataManager.MAX_HP < DataManager.POSSIBLE_MAX_HP){
				roomArray[roomIndex].ReloadHearts();
			}
		}
		
		public function DrawHeartHUD(temp_image:Bitmap, temp_sheet:Bitmap):void
		{			
			for (var i:int = 0; i < Global.MAX_HP; i++){
				var sprite_x:int = 0;
				if (Global.HP <= i+0.75 && Global.HP > i+0.5) sprite_x = 1*15;
				else if (Global.HP <= i+0.5 && Global.HP > i+0.25) sprite_x = 2*15;
				else if (Global.HP <= i+0.25 && Global.HP > i) sprite_x = 3*15;
				else if (Global.HP <= i) sprite_x = 4*15;
				temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
					new Rectangle(sprite_x, 0, 15, 16), 
					new Point(i*15,0)
				);
			}
			
			HUD_sprite.addChild(temp_image);
		}
	}
}