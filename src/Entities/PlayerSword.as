package Entities 
{
	import Entities.Parents.GameSprite;
	import Entities.Parents.Enemy;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class PlayerSword extends GameSprite
	{
		[Embed(source = '../resources/images/sword_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function PlayerSword(x:Number, y:Number, facing:int) 
		{
			super(x, y, 0, 0, 0, 0);
			frameWidth = 48;
			frameHeight = 48;
			sprite_sheet = my_sprite_sheet;
			
			if (facing == Global.DOWN){
				lb = 23;
				tb = 33;
				rb = 25;
				bb = 42;
				currAniY = 0;
			}else if (facing == Global.LEFT){
				lb = 5;
				tb = 24;
				rb = 14;
				bb = 26;
				currAniY = 1;
			}else if (facing == Global.UP){
				lb = 23;
				tb = 5;
				rb = 25;
				bb = 14;
				currAniY = 2;
			}else if (facing == Global.RIGHT){
				lb = 33;
				tb = 24;
				rb = 42;
				bb = 26;
				currAniY = 3;
			}
		}
		
		public function Update(entities:Array, map:Array):void
		{
			for (var i:int = 0; i < entities.length; i++){
				if (getQualifiedClassName(entities[i]) == "Entities::Player"){
					if (entities[i].state != entities[i].SWORD_ATTACK){
						delete_me = true;
						return;
					}
				}else if (entities[i] is Enemy){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb) && 
							entities[i].invincibility <= 0){
						entities[i].hp -= 1;
						entities[i].invincibility = 5;
					}
				}
			}
		}
	}
}