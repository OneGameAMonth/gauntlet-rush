package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Preloader extends MovieClip 
	{
		public var bitmap:Bitmap;
		public static var Renderer:BitmapData;
		
		[Embed(source = './resources/images/loadScreen.png')]
		private var load_screen:Class;
		protected var image:BitmapData;
		public var loadscreen_sprite:Sprite;
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			loadscreen_sprite = new Sprite();
			Renderer = new BitmapData(320*Global.zoom, 240*Global.zoom, false, 0x000000);
			bitmap = new Bitmap(Renderer);
			
			addChild(bitmap);
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			Renderer.lock();
			Renderer.fillRect(new Rectangle(0, 0, Renderer.width, Renderer.height), 0x000000);
			
			// TODO update loader
			var temp_image:Bitmap = new Bitmap(new BitmapData(320*Global.zoom, 300*Global.zoom));
			var temp_sheet:Bitmap = new load_screen();
			
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(0, 0, 320*Global.zoom, 240*Global.zoom), new Point(0,0)
			);
			
			loadscreen_sprite.addChild(temp_image);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(0, 0);
			matrix.scale(Global.zoom, Global.zoom); 
			Renderer.draw(loadscreen_sprite, matrix);
			
			var percentageLoader:Number = e.bytesLoaded / e.bytesTotal;
			Renderer.fillRect(new Rectangle(19*2, 120*2, 285*2, 27*2), 0xFFFFFF);
			Renderer.fillRect(new Rectangle(21*2, 122*2, 281*2, 23*2), 0x000000);
			Renderer.fillRect(new Rectangle(21*2, 122*2, 281*(percentageLoader)*2, 23*2), 0x6888FF);
			
			Renderer.unlock();
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}