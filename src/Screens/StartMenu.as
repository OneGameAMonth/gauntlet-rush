package Screens 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class StartMenu 
	{		
		protected var image:BitmapData;
		public var splashscreen_sprite:Sprite;
		
		private var frameWidth:int = 320;
		private var frameHeight:int = 300;
		
		public var frameCount:int = 0;
		public var frameDelay:int = 15;
		public var currFrame:int = 0;
		public var maxFrame:int = 2;
		
		public var startGame:Boolean;
		
		[Embed(source = '../resources/images/splashScreen.png')]
		private var splashscreen_sheet:Class;
		
		public function StartMenu() 
		{
			splashscreen_sprite = new Sprite();
			startGame = false;
		}
		
		public function Update():void
		{
			if (Global.mousePressed) startGame = true;
			else{
				if (startGame){
					Game.state = Game.MAIN_MENU;
					SoundManager.getInstance().playSfx("TextSound", 0, 1);
					return;
				}
			}
			
			//update animation
			if (++frameCount >= frameDelay)
			{
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
		
		public function Render():void
		{			
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new splashscreen_sheet();
			
			for (var i:int = 0; i < splashscreen_sprite.numChildren;i++){
				splashscreen_sprite.removeChildAt(0);
			}
			
			var sprite_x:int = currFrame*frameWidth;
			var sprite_y:int = 0;
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, frameWidth, frameHeight), 
				new Point(0,0)
			);
			
			splashscreen_sprite.addChild(temp_image);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(0, 0);
			matrix.scale(Global.zoom, Global.zoom); 
			Game.Renderer.draw(splashscreen_sprite, matrix);
		}
	}
}