package  
{
	/**
	 * ...
	 * @author Jake Trower
	 */
	import flash.utils.Dictionary;
	public class Global 
	{	
		//GAME STUFF
		public static var HP:Number;
		public static var MAX_HP:Number;
		public static var DeathTimerLimit:int = 80;
		public static var DeathTimer:int = 80;
		
		//dimensions of stage
		public static var zoom:int = 2;
		public static var stageWidth:int = 640/zoom;
		public static var stageHeight:int = 480/zoom;
		
		//mouse input stuff
		public static var mousePressed:Boolean;
		public static var mouse_X:Number;
		public static var mouse_Y:Number;
		
		//keyboard input stuff
		public static var keys_down:Array;
		public static var keys_up:Array;
		public static var keys_pressed:Array;
		
		public static const LEFT:int = 37;
		public static const UP:int = 38;
		public static const RIGHT:int = 39;
		public static const DOWN:int = 40;
		public static const SPACE:int = 32;
		public static const ENTER:int = 13;
		public static const ESC:int = 27;
		public static const BACKSPACE:int = 8;
		public static const SHIFT:int = 16;
		public static const UNDERSCORE:int = 189;
		public static const X_KEY:int = 88;
		public static const Z_KEY:int = 90;
		public static const A_KEY:int = 65;
		public static const S_KEY:int = 83;
		public static var LetterKeys:Dictionary;
		
		public static const UPLEFT:int = 301;
		public static const UPRIGHT:int = 302;
		public static const DOWNLEFT:int = 303;
		public static const DOWNRIGHT:int = 304
		
		//PLAYER INPUT KEYS!!!
		public static var P_LEFT:int = LEFT;
		public static var P_RIGHT:int = RIGHT;
		public static var P_UP:int = UP;
		public static var P_DOWN:int = DOWN;
		public static var P_SPACE:int = SPACE;
		public static var P_X_KEY:int = X_KEY;
		public static var P_Z_KEY:int = Z_KEY;
		public static var P_A_KEY:int = A_KEY;
		public static var P_S_KEY:int = S_KEY;
		
		
		public function Global() 
		{
		}
		
		public static function CreateLetterDictionary():void
		{
			LetterKeys = new Dictionary();
			
			//ADD NUMBERS
			for (var i:int = 48; i < 58; i++)
			{
				LetterKeys[i] = "0123456789".charAt(i-48);
			}
			for (var i:int = 96; i < 106; i++)
			{
				LetterKeys[i] = "0123456789".charAt(i-96);
			}
			
			//ADD LETTERS
			for (var i:int = 65; i < 91; i++)
			{
				LetterKeys[i] = "abcdefghijklmnopqrstuvwxyz".charAt(i-65);
			}
			
			trace("DICTIONARY CREATED!!");
		}
		
		public static function CheckKeyDown(keycode:int):Boolean
		{
			var answer:Boolean = false;
			for (var i:int = 0; i < keys_down.length; i++)
			{
				if (keys_down[i] == keycode)
				{
					answer = true;
					break;
				}
			}
			return answer;
		}
		
		public static function CheckKeyPressed(keycode:int):Boolean
		{
			var answer:Boolean = false;
			for (var i:int = 0; i < keys_pressed.length; i++)
			{
				if (keys_pressed[i] == keycode)
				{
					answer = true;
					break;
				}
			}
			return answer;
		}
		
		public static function CheckKeyUp(keycode:int):Boolean
		{
			var answer:Boolean = false;
			for (var i:int = 0; i < keys_pressed.length; i++)
			{
				if (keys_pressed[i] == keycode)
				{
					answer = true;
					break;
				}
			}
			return answer;
		}
	}
}