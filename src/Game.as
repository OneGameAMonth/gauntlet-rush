package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import Areas.*;
	
	public class Game 
	{	
		public var screenBitmap:Bitmap;
		public static var Screen:BitmapData;
		
		public static var roomArray:Array;
		public static var roomIndex:int;
		public static var paused:Boolean;
		
		public var musicButtonPress:Boolean;
		public var musicMuted:Boolean;
		public var soundButtonPress:Boolean;
		public var soundMuted:Boolean;
		
		[Embed(source = 'resources/images/sound_button_sheet.png')]
		public var sound_button_sheet:Class;
		protected var image:BitmapData;
		public var image_sprite:Sprite;
		
		public function Game() 
		{
			trace("Game created");
			Screen = new BitmapData(Global.stageWidth*Global.zoom, Global.stageHeight*Global.zoom, false, 0x000000);
			screenBitmap = new Bitmap(Screen);
			paused = false;
			
			Global.GAME_MODE = Global.HARD;
			Global.MAX_HP = 3;
			Global.HP = Global.MAX_HP;
			
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
			
			SoundLoader.LoadSounds();
			SoundManager.getInstance().playMusic("BattleMusic", -5, int.MAX_VALUE);
			
			musicButtonPress = false;
			musicMuted = false;
			soundButtonPress = false;
			soundMuted = false;
			//ready the sound ui buttons
			image_sprite = new Sprite();
		}
		
		public function Render():void
		{
			Screen.lock();
			roomArray[roomIndex].Render();
			RenderButtons();
			Screen.unlock();
		}
		
		public function Update():void
		{
			UpdateButtonInput();
			if (Global.CheckKeyPressed(Global.ENTER) || Global.CheckKeyPressed(Global.ESC)){ 
				Game.paused = !Game.paused;
				SoundManager.getInstance().playSfx("SelectSound", 0, 1);
			}
			if (!paused) roomArray[roomIndex].Update();
			
			//clear out the "keys_up" array for next update
			Global.keys_up = new Array();
			Global.keys_pressed = new Array();
		}
		
		/*************************************************************************************/
		//DRAWING UI AND STUFF
		/*************************************************************************************/
		
		public function UpdateButtonInput():void
		{
			if (Global.mousePressed){
				//music button
				if (Global.mouse_X >= (320-16)*Global.zoom && Global.mouse_X <= (320)*Global.zoom && 
					Global.mouse_Y >= 0*Global.zoom && Global.mouse_Y <= 16*Global.zoom)
					musicButtonPress = true;
			
				//sound button
				if (Global.mouse_X >= (320-32)*Global.zoom && Global.mouse_X <= (320-16)*Global.zoom && 
					Global.mouse_Y >= 0*Global.zoom && Global.mouse_Y <= 16*Global.zoom)
					soundButtonPress = true;
			}else{
				//music button
				if (Global.mouse_X >= (320-16)*Global.zoom && Global.mouse_X <= (320)*Global.zoom && 
					Global.mouse_Y >= 0*Global.zoom && Global.mouse_Y <= 16*Global.zoom){
					if (musicButtonPress){
						SoundManager.getInstance().toggleMuteMusic();
						musicMuted = !musicMuted;
						SoundManager.getInstance().playSfx("ButtonSound", 0, 1);
					}
			}
			
				//sound button
				if (Global.mouse_X >= (320-32)*Global.zoom && Global.mouse_X <= (320-16)*Global.zoom && 
					Global.mouse_Y >= 0*Global.zoom && Global.mouse_Y <= 16*Global.zoom){
					if (soundButtonPress){
						SoundManager.getInstance().toggleMuteSfx();
						soundMuted = !soundMuted;
						SoundManager.getInstance().playSfx("ButtonSound", 0, 1);
					}
				}
			
				musicButtonPress = false;
				soundButtonPress = false;
			}
		}
		
		//
		//RENDER BUTTONS FOR SOUND AND MUSIC TOGGLING
		public function RenderButtons():void
		{
			//render the Sound UI Buttons
			var temp_image:Bitmap = new Bitmap(new BitmapData(16, 16));
			var temp_sheet:Bitmap = new sound_button_sheet();
			
			//Draw the music button
			var temp_x_offset:int = 0; var temp_y_offset:int = 0;
			if (musicButtonPress) temp_x_offset = 1;
			if (musicMuted) temp_y_offset = 1;
			
			DrawSpriteFromSheet(temp_image, temp_sheet, temp_x_offset, 2+temp_y_offset);
			var matrix:Matrix = new Matrix();
			matrix.translate(320-16, 0);
			matrix.scale(Global.zoom, Global.zoom);
			Screen.draw(image_sprite, matrix);
			
			//Draw the sound button
			temp_x_offset = 0; temp_y_offset = 0;
			if (soundButtonPress) temp_x_offset = 1;
			if (soundMuted) temp_y_offset = 1;
			
			DrawSpriteFromSheet(temp_image, temp_sheet, temp_x_offset, temp_y_offset);
			matrix = new Matrix();
			matrix.translate(320-32, 0);
			matrix.scale(Global.zoom, Global.zoom);
			Screen.draw(image_sprite, matrix);
		}
		
		//
		//USED FOR DRAWING SOUND UI BUTTONS
		public function DrawSpriteFromSheet(temp_image:Bitmap, temp_sheet:Bitmap,
											x_offset:int, y_offset:int):void
		{
			for (var i:int = 0; i < image_sprite.numChildren;i++){
				image_sprite.removeChildAt(0);
			}
			
			var sprite_x:int = x_offset*16;
			var sprite_y:int = y_offset*16;
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, 16, 16), 
				new Point(0,0)
			);
			
			image_sprite.addChild(temp_image);
		}
		
		/*************************************************************************************/
		//HANDLE AND DETECT PLAYER INPUT
		/*************************************************************************************/
		public function KeyUp(e:KeyboardEvent):void
		{
			//position of key in the array
			var key_pos:int = -1;
			for (var i:int = 0; i < Global.keys_down.length; i++)
			{
				if (e.keyCode == Global.keys_down[i])
				{
					//the key is found/was pressed before, so store the position
					key_pos = i;
					break;
				}
			}
			//remove the keycode from keys_down if found
			if (key_pos!=-1)
				Global.keys_down.splice(key_pos, 1);
			
			Global.keys_up.push(e.keyCode);
		}
		
		public function KeyDown(e:KeyboardEvent):void
		{
			//check to see if the key that is being pressed is already in the array of pressed keys
			var key_down:Boolean = false;
			for (var i:int = 0; i < Global.keys_down.length; i++)
			{
				if (Global.keys_down[i] == e.keyCode)
					key_down = true;
			}
			
			//add the key to the array of pressed keys if it wasn't already in there
			if (!key_down)
			{
				Global.keys_down.push(e.keyCode);
				Global.keys_pressed.push(e.keyCode);
			}
		}
		
		public function MouseDown(e:MouseEvent):void
		{	
			Global.mouse_X = e.stageX;
			Global.mouse_Y = e.stageY;
			Global.mousePressed = true;
		}
		
		public function MouseUp(e:MouseEvent):void
		{
			Global.mouse_X = e.stageX;
			Global.mouse_Y = e.stageY;
			Global.mousePressed = false;
		}
	}
}