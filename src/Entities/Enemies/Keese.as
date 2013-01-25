package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	
	public class Keese extends Enemy
	{
		[Embed(source = '../../resources/images/keese_sheet.png')]
		private var my_sprite_sheet:Class;
		
		public var timer:int;
		public var add:int;
		public var randTimeLimit:int;
		public var stopTimer:int;
		public var randMoveTimer:int;
		
		public function Keese(x:int, y:int) 
		{
			super(x, y, 2, 2, 14, 14);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 2;
			frameDelay = 5;
			topspeed = 2.5;
			timer = 1;
			add = 1;
			randTimeLimit = Math.floor(Math.random()*15)+35;
			stopTimer = Math.floor(Math.random()*10)+20;
			randMoveTimer = Math.floor(Math.random()*10)+10;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
			timer += add;
			if (timer >= randTimeLimit){
				timer--;
				stopTimer--;
				if (stopTimer <= 0){
					add = -1
					stopTimer = Math.floor(Math.random()*10)+20;
				}
			}else if (timer <= 1){
				timer++;
				stopTimer--;
				if (stopTimer <= 0){
					add = 1;
					randTimeLimit = Math.floor(Math.random()*15)+35;
					stopTimer = Math.floor(Math.random()*10)+5;
				}
			}
			
			var speed:Number = topspeed * (timer/randTimeLimit)
			frameDelay = (topspeed/speed)*(topspeed/speed)*2;
			
			if (speed < 0.5){
				vel.x = 0;
				vel.y = 0;
				return;
			}
			
			randMoveTimer--;
			if (randMoveTimer <= 0){
				randMoveTimer = Math.floor(Math.random()*(10/timer))+5;
				var randir:int = Math.floor(Math.random()*8);
				switch(randir){
					case 0:
						vel.x = 0;
						vel.y = speed;
						break;
					case 1:
						vel.x = 0;
						vel.y = -speed;
						break;
					case 2:
						vel.x = speed;
						vel.y = 0;
						break;
					case 3:
						vel.x = -speed;
						vel.y = 0;
						break;
					case 4:
						vel.x = speed;
						vel.y = speed;
						break;
					case 5:
						vel.x = speed;
						vel.y = -speed;
						break;
					case 6:
						vel.x = -speed;
						vel.y = speed;
						break;
					case 7:
						vel.x = -speed;
						vel.y = -speed;
						break;
				}
			}
		}
		
		override public function Update(entities:Array, map:Array):void
		{	
			if (delete_me) return;
			if (state == NORMAL){ 
				UpdateScript(entities, map);
				UpdateMovement(entities, map, true, true);
			}else UpdateMovement(entities, map);
			
			if (hurt > 0){
				hurt--;
				if (hurt <= 0){
					state = NORMAL;
					vel.x = 0;
					vel.y = 0;
				}
			}if (invincibility > 0) invincibility--;
			UpdateAnimation();
		}
		
		override public function UpdateMovement(entities:Array, map:Array, keepMoving:Boolean = false, diagonal:Boolean = false):void
		{
			var solids:Array = [];
			var i:int;
			for (i = 0; i < map.length; i++){
				for (var j:int = 0; j < map[i].length; j++){
					if (i != 0 && i != map.length-1 && j != 0 && j != map[i].length-1) continue;
					if (map[i][j].solid) solids.push(map[i][j]);
				}
			}for (i = 0; i < entities.length; i++){
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