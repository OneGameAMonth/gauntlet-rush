package Screens 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MainMenu 
	{
		private var data:Object;
		private var cursorY:int;
		private var chooseDifficulty:Boolean = false;
		
		protected var image:BitmapData;
		public var cursor_sprite:Sprite;
		[Embed(source = '../resources/images/player_sheet.png')]
		private var cursor_sheet:Class;
		[Embed(source = '../resources/images/player_easy_sheet.png')]
		private var cursor_easy_sheet:Class;
		[Embed(source = '../resources/images/player_hard_sheet.png')]
		private var cursor_hard_sheet:Class;
		
		public var frameCount:int = 0;
		public var frameDelay:int = 10;
		public var currFrame:int = 0;
		public var maxFrame:int = 2;
		
		//text stuff
		[Embed(source = '../resources/04B_03.ttf', fontName='pixelFont',
		       mimeType='application/x-font', embedAsCFF='false')]
		private var pixelFont:Class;
		private var textFormat:TextFormat = new TextFormat();
		private var uiText:TextField = new TextField();
		
		public function MainMenu() 
		{
			cursor_sprite = new Sprite();
			cursorY = 0;
			
			//ready the fonts
			textFormat = new TextFormat("pixelFont", 24, 0xFFFFFF);
			uiText.embedFonts = true;
			uiText.defaultTextFormat = textFormat;
			uiText.width = Global.stageWidth;
			uiText.height = Global.stageHeight;
			
			var dataManager:DataManager = new DataManager();
			data = dataManager.GetCookieVal("gauntlet-data");
			if (data != null) cursorY = 1;
		}
		
		public function RetryData():void
		{
			var dataManager:DataManager = new DataManager();
			
			data = dataManager.GetCookieVal("gauntlet-data");
			if (data != null) cursorY = 1;
		}
		
		public function Update():void
		{
			DataManager.ROOM_INDEX = 0;
			if (Global.CheckKeyPressed(Global.P_Z_KEY)){
				chooseDifficulty = false;
				SoundManager.getInstance().playSfx("ButtonSound", 0, 1);
				cursorY = 0;
			}
			if (Global.CheckKeyPressed(Global.ENTER) || Global.CheckKeyPressed(Global.P_X_KEY)){
				SoundManager.getInstance().playSfx("TextSound", 0, 1);
				if (!chooseDifficulty){
					if (cursorY < 2){
						if (cursorY == 0) chooseDifficulty = true;
						else{ 
							PlayGame.StartGame(false);
							Game.state = Game.PLAY_GAME;
						}
					}else{
						Game.state = Game.SCORE_SCREEN;
					}
				}else{
					switch(cursorY)
					{
						case 0: Global.GAME_MODE = Global.EASY;
							break;
						case 1: Global.GAME_MODE = Global.NORMAL;
							break;
						case 2: Global.GAME_MODE = Global.HARD;
					}
					Game.state = Game.PLAY_GAME;
					PlayGame.StartGame(true);
					chooseDifficulty = false;
				}
				cursorY = 0;
			}
			
			if (Global.CheckKeyPressed(Global.P_DOWN)){
				SoundManager.getInstance().playSfx("GetHeartSound", 0, 1);
				cursorY++;
				if (data == null && cursorY == 1 && !chooseDifficulty) cursorY = 2;
				if (cursorY > 2) cursorY = 2;
			}else if (Global.CheckKeyPressed(Global.P_UP)){
				SoundManager.getInstance().playSfx("GetHeartSound", 0, 1);
				cursorY--;
				if (data == null && cursorY == 1 && !chooseDifficulty) cursorY = 0;
				if (cursorY < 0) cursorY = 0;
			}
			
			//update animation
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
		
		public function Render():void
		{
			var i:int;
			var tempText:String;
			
			//Render the top text
			uiText.textColor = 0xFFFFFF;
			if (!chooseDifficulty){
				uiText.text = "Gauntlet of Love";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 55*Global.zoom, 40*Global.zoom));
				
				uiText.text = "New Game";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 100*Global.zoom, 100*Global.zoom));
				if (data == null) uiText.textColor = 0x999999;
				uiText.text = "Continue";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 100*Global.zoom, 130*Global.zoom));
				uiText.textColor = 0xFFFFFF;
				uiText.text = "High Scores";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 100*Global.zoom, 160*Global.zoom));
				
				if (data != null){
					var dataArray:Array = data.split(",");
					uiText.text = "Your Best: "+parseInt(dataArray[1]);
					uiText.textColor = 0x999999;
					Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 55*Global.zoom, 10*Global.zoom));
				}
			}else{
				uiText.text = "Choose Difficulty";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 65*Global.zoom, 40*Global.zoom));
				
				uiText.text = "Easy";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 100*Global.zoom, 100*Global.zoom));
				uiText.text = "Normal";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 100*Global.zoom, 130*Global.zoom));
				uiText.text = "Hard";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 100*Global.zoom, 160*Global.zoom));
			}
			
			DrawCursor();
		}
		
		public function DrawCursor():void
		{
			var draw_cursor_sheet:Class = cursor_sheet;	
			if (chooseDifficulty && cursorY == 0)
				draw_cursor_sheet = cursor_easy_sheet;
			else if (chooseDifficulty && cursorY == 2)
				draw_cursor_sheet = cursor_hard_sheet;
			
			var temp_image:Bitmap = new Bitmap(new BitmapData(16, 16));
			var temp_sheet:Bitmap = new draw_cursor_sheet();
			
			for (var i:int = 0; i < cursor_sprite.numChildren;i++){
				cursor_sprite.removeChildAt(i);
			}
			
			var sprite_x:int = currFrame*16;
			var sprite_y:int = 0;
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, 16, 16), 
				new Point(0,0)
			);
			
			cursor_sprite.addChild(temp_image);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(75, 100+cursorY*30+5);
			matrix.scale(Global.zoom, Global.zoom); 
			Game.Renderer.draw(cursor_sprite, matrix);
		}
	}
}