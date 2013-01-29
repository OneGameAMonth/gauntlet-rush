package Entities.Enemies 
{
	import Entities.Parents.Projectile;
	
	public class MagicBeam extends Projectile
	{
		[Embed(source = '../../resources/images/magic_beam_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function MagicBeam(x:Number, y:Number, facing:int) 
		{
			super(x, y, 5, 5, 10, 10);
			sprite_sheet = my_sprite_sheet;
			topspeed = 5.0;
			if (facing == Global.DOWN) vel.y = topspeed;
			else if (facing == Global.UP) vel.y = -topspeed;
			else if (facing == Global.LEFT) vel.x = -topspeed;
			else if (facing == Global.RIGHT) vel.x = topspeed;
			SetFacing(facing);
			
			canBeBlocked = false;
			canBeKilled = true;
			maxFrame = 3;
			frameDelay = 3;
			atkPow = 1;
			SoundManager.getInstance().playSfx("MagicalRodSound", 0, 1);
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me) return;
			UpdateMovement(entities, map);
			if (hitSomething) delete_me = true;
			UpdateFacingWithVelocity();
			UpdateAnimation();
		}
		
		override public function UpdateAnimation():void
		{
			
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
		
		public function SetFacing(facing:int):void
		{
			if (facing == Global.DOWN){
				lb = 5;
				tb = 1;
				rb = 11;
				bb = 10;
				currAniY = 0;
			}else if (facing == Global.LEFT){
				lb = 5;
				tb = 6;
				rb = 14;
				bb = 12;
				currAniY = 1;
			}else if (facing == Global.UP){
				lb = 5;
				tb = 5;
				rb = 11;
				bb = 14;
				currAniY = 2;
			}else if (facing == Global.RIGHT){
				lb = 1;
				tb = 6;
				rb = 10;
				bb = 12;
				currAniY = 3;
			}
		}
	}
}