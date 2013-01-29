package Entities.Enemies 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	
	public class EnemyCloud extends GameSprite
	{
		[Embed(source = '../../resources/images/cloud_disappear_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public var timer:int;
		
		public function EnemyCloud(x:int, y:int) 
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 16;
			frameHeight = 16;
			maxFrame = 3;
			frameDelay = 3;
			
			visible = true;
			timer = 5;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me || !visible) return;
			timer--;
			if (timer <= 0){
				if (timer == 0) SpawnEnemy(entities);
				UpdateAnimation();
			}
		}
		
		public function SpawnEnemy(entities:Array):void
		{
			var rand:int = Math.floor(Math.random()*3);
			if (rand == 0){
				entities.push(new Rope(x, y, 2));
			}else if (rand == 1){
				entities.push(new Octoturret(x, y, 1));
			}else if (rand == 2){
				entities.push(new Keese(x, y, true, 1));
			}
		}
		
		override public function UpdateAnimation():void
		{
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame) 
					delete_me = true;
				frameCount = 0;
			}
		}
	}
}