package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public var game:Game;

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			game = new Game();
			addChild(game.screenBitmap);
			
			//create main game loop
			addEventListener(Event.ENTER_FRAME, Run);
			
			Global.keys_down = new Array();
			Global.keys_up = new Array();
			Global.keys_pressed = new Array();
			Global.CreateLetterDictionary();
			
			//add inputListeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, game.KeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, game.KeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, game.MouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, game.MouseUp);
		}
		
		public function Run(e:Event):void
		{
			game.Update();
			game.Render();
		}
	}
}