package Entities.Enemies 
{
	import Entities.Parents.GameSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class EnemyDie extends GameSprite
	{
		[Embed(source = '../../resources/images/monster_death_sheet.png')]
		private var my_sprite_sheet:Class;
		
		private var scale:int;
		
		public function EnemyDie(x:Number, y:Number, scale:int = 1) 
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 4;
			frameDelay = 2;
			this.scale = scale;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			UpdateAnimation();
			if (currFrame == 0 && frameCount == 0) delete_me = true;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			if (!visible) return;
			
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			DrawSpriteFromSheet(temp_image, temp_sheet);
				
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix);
		}
	}
}