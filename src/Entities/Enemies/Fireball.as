package Entities.Enemies 
{
	import Entities.Parents.Projectile;
	
	public class Fireball extends Projectile
	{
		[Embed(source = '../../resources/images/fireball_sheet.png')]
		private var my_sprite_sheet:Class;
		private var invincibility:int;
		
		public function Fireball(x:Number, y:Number, px:Number, py:Number)
		{
			super(x, y, 5, 5, 10, 10);
			sprite_sheet = my_sprite_sheet;
			topspeed = 3.0;
			var angle:Number = Math.atan((py-y)/(px-x));
			vel.x = topspeed * Math.abs(Math.cos(angle)) * ((px-x)/Math.abs(px-x));
			vel.y = topspeed * Math.abs(Math.sin(angle)) * ((py-y)/Math.abs(py-y));
			
			maxFrame = 2;
			frameDelay = 5;
			invincibility = 30;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me) return;
			if (invincibility > 0) invincibility--;
			UpdateMovement(entities, map, false, true);
			if (hitSomething) delete_me = true;
			UpdateAnimation();
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