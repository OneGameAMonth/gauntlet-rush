package Entities 
{
	import Entities.Parents.Enemy;
	
	public class Octorok extends Enemy
	{
		[Embed(source = '../resources/images/octorok_sheet.png')]
		private var my_sprite_sheet:Class;
		
		private var randTimer:int;
		private var stopCounter:int;
		
		public function Octorok(x:int, y:int)
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			topspeed = 2.0;
			randTimer = 0;
			stopCounter = 0;
		}
		
		public function Update(entities:Array, map:Array):void
		{
			if (hp <= 0){
				delete_me = true;
				return;
			}
			UpdateMovement(entities, map);
			UpdateFacingWithVelocity();
			invincibility -= 1;
			super.UpdateAnimation();
		}
		
		override public function UpdateMovement(entities:Array, map:Array, keepMoving:Boolean = false):void
		{
			randTimer--;
			if (randTimer <= 0){
				vel.x = 0;
				vel.y = 0;
				stopCounter++;
				if (stopCounter >= 4){
					stopCounter = 0;
					entities.push(new OctoRock(x, y, facing));
					randTimer = 32;
				}
				else{
					var rand:int = Math.floor(Math.random()*4);
					switch(rand){
						case 0: vel.x = topspeed;
							break;
						case 1: vel.x = -topspeed;
							break;
						case 2: vel.y = topspeed;
							break;
						case 3: vel.y = -topspeed;
							break;
						default: break;
					}
					randTimer = Math.floor(Math.random()*8)+8;
				}
			}
			super.UpdateMovement(entities, map, true);
		}
	}
}