package Entities.Parents 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class GameSprite extends GameObject
	{
		public var visible:Boolean;
		protected var image:BitmapData;
		public var image_sprite:Sprite;
		
		public var sprite_sheet:Class;
		
		//animation stuff
		public var frameCount:int;
		public var frameDelay:int;
		public var currFrame:int;
		public var currAniX:int;
		public var currAniY:int;
		public var maxFrame:int;
		public var frameWidth:int;
		public var frameHeight:int;
		
		public function GameSprite(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			solid = false;
			
			visible = true;
			frameCount = 0;
			currFrame = 0;
			currAniX = 0;
			currAniY = 0;
			maxFrame = 1;
			frameWidth = 16;
			frameHeight = 16;
			frameDelay = 15;
			image_sprite = new Sprite();
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			if (!visible) return;
			
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			DrawSpriteFromSheet(temp_image, temp_sheet);
				
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix);
		}
		
		public function DrawSpriteFromSheet(temp_image:Bitmap, temp_sheet:Bitmap):void
		{
			for (var i:int = 0; i < image_sprite.numChildren;i++){
				image_sprite.removeChildAt(i);
			}
			
			var sprite_x:int = currFrame*frameWidth+currAniX*frameWidth;
			var sprite_y:int = currAniY*frameHeight;
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, frameWidth, frameHeight), 
				new Point(0,0)
			);
			
			image_sprite.addChild(temp_image);
		}
		
		public function UpdateAnimation():void
		{
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
	}
}