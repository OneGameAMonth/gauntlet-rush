package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	import Entities.Player;
	
	public class Bubble extends Enemy
	{
		[Embed(source = '../../resources/images/bubble_sheet.png')]
		private var my_sprite_sheet:Class;
		private var randTimer:int;
		
		public function Bubble(x:int, y:int) 
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			canBeHurt = false;
			
			currAniY = 1;
			maxFrame = 2;
			frameDelay = 3;
			topspeed = 2.0;
			randTimer = 0;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{			
			randTimer--;
			if (randTimer <= 0){
				vel.x = 0;
				vel.y = 0;
				
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
				randTimer = Math.floor(Math.random()*4)+4;
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