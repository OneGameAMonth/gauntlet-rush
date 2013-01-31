package Entities.Enemies 
{
	import Entities.Parents.Enemy;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Keese extends Enemy
	{
		[Embed(source = '../../resources/images/keese_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../../resources/images/keese_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../../resources/images/keese_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		
		public var timer:int;
		public var add:int;
		public var randTimeLimit:int;
		public var stopTimer:int;
		public var randMoveTimer:int;
		public var hyper:Boolean
		
		public function Keese(x:int, y:int, hyper:Boolean = false, atkPow:Number = 0.5) 
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
			
			this.atkPow = atkPow;
			this.hyper = hyper;
			if (hyper){
				currAniY = 1;
				hp = 2;
			}
			maxHP = hp;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			if (!visible) return;
			
			sprite_sheet = my_sprite_sheet;
			if (invincibility > 0){
				if ((invincibility >= 4 && invincibility <= 8) || (invincibility >= 12 && invincibility <= 16) || 
					(invincibility >= 20 && invincibility <= 24) || (invincibility >= 28 && invincibility <= 32) || 
					(invincibility >= 36 && invincibility <= 40))
					sprite_sheet = hurt2_sprite_sheet;
				else sprite_sheet = hurt_sprite_sheet;
			}
			
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			DrawSpriteFromSheet(temp_image, temp_sheet);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix);
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
			if (!hyper){
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
			}else timer = randTimeLimit;
			
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