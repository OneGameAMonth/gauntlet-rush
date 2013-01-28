package Entities.Items 
{
	import Entities.Parents.GameSprite;
	import Entities.Parents.Mover;
	import Entities.Player;
	
	public class Fairy extends Mover
	{
		[Embed(source = '../../resources/images/fairy_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public var startX:int;
		public var startY:int;
		public var randTimer:int;
		
		public function Fairy(x:int, y:int) 
		{
			super(x, y, 4, 0, 12, 16);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 16;
			frameHeight = 16;
			maxFrame = 2;
			frameDelay = 3;
			
			visible = false;
			startX = x;
			startY = y;
			randTimer = 1;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me || !visible) return;
			
			randTimer--;
			if (randTimer <= 0){
				var rand:int = Math.floor(Math.random()*3)-1;
				vel.x = rand;
				rand = Math.floor(Math.random()*3)-1;
				vel.y = rand;
				
				if (x > startX+8) vel.x = -2;
				else if (x < startX-8) vel.x = 2;
				if (y > startY+8) vel.y = -2;
				else if (y < startY-8) vel.y = 2;
				randTimer = 8;
			}
			UpdateMovement(entities, map, false, true);
			
			for(var i:int = 0; i < entities.length; i++){
				if (entities[i] is Player){
					if (CheckRectIntersect(entities[i], x, y, x+rb, y+bb)){
						Global.HP = Global.MAX_HP;
						SoundManager.getInstance().playSfx("GetItemSound", 0, 1);
						delete_me = true;
					}
				}
			}
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
	}
}