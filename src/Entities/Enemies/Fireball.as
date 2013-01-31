package Entities.Enemies 
{
	import Entities.Parents.Projectile;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Fireball extends Projectile
	{
		[Embed(source = '../../resources/images/fireball_sheet.png')]
		private var my_sprite_sheet:Class;
		private var scale:int;
		
		public function Fireball(x:Number, y:Number, px:Number, py:Number, scale:int = 1)
		{
			super(x, y, 5, 5, 10, 10);
			sprite_sheet = my_sprite_sheet;
			topspeed = 3.0;
			var angle:Number = Math.atan((py-y)/(px-x));
			vel.x = topspeed * Math.abs(Math.cos(angle)) * ((px-x)/Math.abs(px-x));
			vel.y = topspeed * Math.abs(Math.sin(angle)) * ((py-y)/Math.abs(py-y));
			
			maxFrame = 4;
			frameDelay = 2;
			invincibility = 30;
			this.scale = scale;
			lb*=scale; tb*=scale; rb*=scale; bb*=scale;
			
			atkPow = 0.5;
			if (scale == 1)
				canBeKilled = true; 
			else{ 
				canBeBlocked = false;
				atkPow = 1;
			}
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me) return;
			if (invincibility > 0) invincibility--;
			UpdateMovement(entities, map, false, true);
			if (hitSomething) delete_me = true;
			UpdateAnimation();
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
		
		override public function UpdateMovement(entities:Array, map:Array, keepMoving:Boolean = false, diagonal:Boolean = false):void
		{
			var solids:Array = [];
			var i:int;
			for (i = 0; i < map.length; i++){
				for (var j:int = 0; j < map[i].length; j++){
					if (map[i][j].solid) solids.push(map[i][j]);
				}
			}for (i = 0; i < entities.length; i++){
				if (entities[i] is StoneStatue && invincibility > 0) continue;
				if (entities[i].solid) solids.push(entities[i]);
			}
			
			//Update movement
			if (solids.length > 0)
				CollideWithSolids(solids, keepMoving, diagonal);
			else{
				y += vel.y;
				if (vel.y == 0) x += vel.x;
			}
		}
		
		override public function UpdateAnimation():void
		{
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
	}
}