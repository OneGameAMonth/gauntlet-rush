package Entities 
{
	import Entities.Parents.Mover;
	
	public class Player extends Mover
	{
		public var rest:int;
		public var rollRest:int;
		
		public var state:int;
		public const NORMAL:int = 0;
		public const ROLL_ATTACK:int = 1;
		
		[Embed(source = '../resources/images/player_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public function Player(x:int, y:int)
		{
			super(x, y, 2, 2, 14, 14);
			rollRest = 0;
			state = NORMAL;
			sprite_sheet = my_sprite_sheet;
		}
		
		public function Update(entities:Array, map:Array):void
		{
			var solids:Array = [];
			var i:int;
			for (i = 0; i < map.length; i++){
				for (var j:int = 0; j < map[i].length; j++){
					if (map[i][j].solid) solids.push(map[i][j]);
				}
			}for (i = 0; i < entities.length; i++){
				if (entities[i].solid) solids.push(entities[i]);
			}
			UpdateMovement(solids);
			
			if (state == ROLL_ATTACK){
				if (hitSomething){
					state = NORMAL;
					rest = 5;
					vel.x = 0;
					vel.y = 0;
					currFrame = 0;
					frameCount = 0;
				}
			}
			if (rest > 0) rest -= 1;
			if (rollRest > 0){ 
				rollRest -= 1;
				if (vel.x == 0 && vel.y == 0) rollRest = 0;
			}
			
			UpdateAnimation();
		}
		
		override public function UpdateAnimation():void
		{
			if (facing == Global.UP) currAniY = 2;
			else if (facing == Global.DOWN) currAniY = 0;
			else if (facing == Global.LEFT) currAniY = 1;
			else if (facing == Global.RIGHT) currAniY = 3;
				
			if (state == NORMAL){ 
				currAniX = 0;
				maxFrame = 2;
				if (vel.x == 0 && vel.y == 0) frameDelay = 15;
				else frameDelay = 7;
			}else if (state == ROLL_ATTACK){ 
				currAniX = 3;
				maxFrame = 4;
				frameDelay = 3;
				rollRest = 5;
			}
			
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame){
					currFrame = 0;
					if (state != NORMAL) state = NORMAL;
				}
				frameCount = 0;
			}
		}
	}
}