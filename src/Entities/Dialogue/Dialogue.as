package Entities.Dialogue 
{
	import Entities.Parents.GameSprite
	import Entities.Player;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Dialogue extends GameSprite
	{
		
		public function Dialogue() 
		{
			super(8, 168, 0, 0, 302, 128);
			frameWidth = 302;
			frameHeight = 64;
			maxFrame = 2;
			frameDelay = 15;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player){
					entities[i].rest = 2;
					entities[i].vel.x = 0;
					entities[i].vel.y = 0;
					
					if (entities[i].y >= 160) y = 32;
				}
			}
			UpdateAnimation();
		}
		
		override public function DrawSpriteFromSheet(temp_image:Bitmap, temp_sheet:Bitmap):void
		{
			for (var i:int = 0; i < image_sprite.numChildren;i++){
				image_sprite.removeChildAt(i);
			}
			
			var sprite_x:int = currAniX*frameWidth;
			var sprite_y:int = currFrame*frameHeight+currAniY*frameHeight;
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, frameWidth, frameHeight), 
				new Point(0,0)
			);
			
			image_sprite.addChild(temp_image);
		}
	}
}