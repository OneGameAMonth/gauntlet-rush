package Entities.Items 
{
	import Entities.Parents.GameSprite;
	import Entities.Player;
	
	public class CloudDisappear extends GameSprite
	{
		[Embed(source = '../../resources/images/cloud_disappear_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public var timer:int;
		
		public function CloudDisappear(x:int, y:int, visible:Boolean = false) 
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 16;
			frameHeight = 16;
			maxFrame = 3;
			frameDelay = 3;
			
			this.visible = visible;
			timer = 5;
		}
		
		override public function Update(entities:Array, map:Array):void
		{
			if (delete_me || !visible) return;
			timer--;
			if (timer <= 0)
				UpdateAnimation();
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