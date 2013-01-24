package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	import Entities.Player;
	
	public class Rope extends Enemy
	{
		[Embed(source = '../../resources/images/rope_sheet.png')]
		private var my_sprite_sheet:Class;
		private var randTimer:int;
		
		public function Rope(x:int, y:int) 
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 4.0;
			randTimer = 0;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player && entities[i].invincibility <= 0){
					var p:Player = entities[i];
					if ((p.y > y+6 && p.y < y+10) || (p.y < y-6 && p.y > y-10)){
						if (p.x > x){
							facing = Global.RIGHT;
							vel.x = topspeed;
						}else{
							facing = Global.LEFT;
							vel.x = -topspeed;
						}
						vel.y = 0;
						return;
					}
				}
			}
			
			randTimer--;
			if (randTimer <= 0){
				vel.x = 0;
				vel.y = 0;
				
				var rand:int = Math.floor(Math.random()*4);
				switch(rand){
					case 0: vel.x = topspeed/2;
						break;
					case 1: vel.x = -topspeed/2;
						break;
					case 2: vel.y = topspeed/2;
						break;
					case 3: vel.y = -topspeed/2;
						break;
					default: break;
				}
				randTimer = Math.floor(Math.random()*8)+8;
			}
		}
	}
}