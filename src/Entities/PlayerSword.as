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
		
		public var facing:int;
		public var hitEnemy:Boolean;
		
		public function PlayerSword(x:Number, y:Number, facing:int) 
		{
			super(x, y, 0, 0, 0, 0);
			frameWidth = 48;
			frameHeight = 48;
			sprite_sheet = my_sprite_sheet;
			this.facing = facing;
			solid = false;
			
			hitEnemy = false;
			SetFacing();
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			//Doing it like this is only okay because the player is always
			//at a lower index than the enemies in our entity arrays
			hitEnemy = false;
			for (var i:int = 0; i < entities.length; i++){
				if (getQualifiedClassName(entities[i]) == "Entities::Player"){
					if (entities[i].state != entities[i].SWORD_ATTACK){
						delete_me = true;
						return;
					}else{
						var addx:int = 0, addy:int = 0;
						addy = entities[i].vel.y;
						if (entities[i].vel.y == 0) 
							addx = entities[i].vel.x;
						x = entities[i].x-16+addx;
						y = entities[i].y-16+addy;
						facing = entities[i].facing;
						SetFacing();
					}
				}else if (entities[i] is Enemy && entities[i].canBeHurt){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb) && 
							entities[i].invincibility <= 0){
						entities[i].GetHurtByObject(this);
						if (entities[i].hp > 0) hitEnemy = true;
					}
				}
			}
		}
		
		public function SetFacing():void
		{
			if (facing == Global.DOWN){
				lb = 21;
				tb = 33;
				rb = 27;
				bb = 42;
				currAniY = 0;
			}else if (facing == Global.LEFT){
				lb = 5;
				tb = 22;
				rb = 14;
				bb = 28;
				currAniY = 1;
			}else if (facing == Global.UP){
				lb = 21;
				tb = 5;
				rb = 27;
				bb = 14;
				currAniY = 2;
			}else if (facing == Global.RIGHT){
				lb = 33;
				tb = 22;
				rb = 42;
				bb = 28;
				currAniY = 3;
			}
		}
	}
}