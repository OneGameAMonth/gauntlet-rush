package Entities 
{
	import Entities.Parents.Projectile;
	
	public class OctoRock extends Projectile
	{
		[Embed(source = '../resources/images/rock_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function OctoRock(x:Number, y:Number, facing:int) 
		{
			super(x, y, 5, 5, 10, 10);
			sprite_sheet = my_sprite_sheet;
			topspeed = 5.0;
			if (facing == Global.DOWN) vel.y = topspeed;
			else if (facing == Global.UP) vel.y = -topspeed;
			else if (facing == Global.LEFT) vel.x = -topspeed;
			else if (facing == Global.RIGHT) vel.x = topspeed;
			
			maxFrame = 4;
			frameDelay = 3;
		}
		
		public function Update(entities:Array, map:Array):void
		{
			UpdateMovement(entities, map);
			if (hitSomething) delete_me = true;
			super.UpdateAnimation();
		}
	}
}