package Entities.Enemies 
{
	import Entities.Player;
	import Entities.Parents.Enemy;
	import Entities.Parents.Mover;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Ganon extends Enemy
	{
		[Embed(source = '../../resources/images/ganon_sheet.png')]
		private var my_sprite_sheet:Class;
		[Embed(source = '../../resources/images/ganon_hurt_sheet.png')]
		private var hurt_sprite_sheet:Class;
		[Embed(source = '../../resources/images/ganon_hurt2_sheet.png')]
		private var hurt2_sprite_sheet:Class;
		
		private var moveTimer:int;
		private var stopCounter:int;
		
		private const ATTACK_STATE:int = 5;
		private var spawningEnemies:Boolean;
		private var maxSpawnLimit:int;
		
		public function Ganon(x:int, y:int)
		{
			super(x, y, 0, 0, 64, 64);
			sprite_sheet = my_sprite_sheet;
			frameWidth = 64;
			frameHeight = 64;
			maxFrame = 2;
			frameDelay = 15;
			topspeed = 2.5;
			hp = 9;
			maxHP = 9;
			atkPow = 2;
			moveTimer = 26;
			stopCounter == 0;
			spawningEnemies = false;
			maxSpawnLimit = 7;
			
			currAniY = 1;
		}
		
		override public function UpdateScript(entities:Array, map:Array):void
		{
			moveTimer--;
			if (moveTimer <= 0){
				state = NORMAL;
				vel.x = 0;
				vel.y = 0;
				
				stopCounter++;
				if (stopCounter >= 6){
					currFrame = 0;
					frameCount = 0;
					state = ATTACK_STATE;
					stopCounter = 0;
					moveTimer = 26;
					TrySpawnEnemies(entities);
				}
				else{
					var rand:int = Math.floor(Math.random()*3)-1;
					vel.x = rand*topspeed;
					rand = Math.floor(Math.random()*3)-1;
					vel.y = rand*topspeed;
					moveTimer = Math.floor(Math.random()*8)+8;
				}
			}
		}
		
		public function TrySpawnEnemies(entities:Array):void
		{
			var i:int;
			var enemyCount:int = 0;
			for (i = 0; i < entities.length; i++){
				if (entities[i] is Enemy) enemyCount++;
			}
			
			if (enemyCount <= 1 || spawningEnemies){
				moveTimer = 8;
				stopCounter = 5;
				spawningEnemies = true;
				
				if (enemyCount <= maxSpawnLimit){
					var randX:int = Math.floor(Math.random()*256)+32;
					var randY:int = Math.floor(Math.random()*176)+32;
					entities.push(new EnemyCloud(randX, randY));
					SoundManager.getInstance().playSfx("SpawnEnemySound", 0, 1);
				}else spawningEnemies = false;
			}else{
				for (i = 0; i < entities.length; i++){
					if (entities[i] is Player){
						SoundManager.getInstance().playSfx("BombBlowSound", 0, 1);
						entities.push(new Fireball(x+16, y+16, entities[i].x, entities[i].y, 2));
						moveTimer = 16;
						return;
					}
				}
			}
		}
		
		override public function GetHurtByObject(object:Mover, dmg:Number = 1, invin:int = 0):void
		{
			hp -= 1;
			if (hp > 0){
				invincibility = 20;
				SoundManager.getInstance().playSfx("BossHitSound", 0, 1);
			}
			else{
				SoundManager.getInstance().playSfx("BossScream1Sound", 0, 1);
				delete_me = true;
			}
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
		
		override public function Update(entities:Array, map:Array):void
		{	
			if (delete_me) return;
			if (state != HURT_BOUNCE){ 
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
		
		override public function UpdateAnimation():void
		{
			if (state == NORMAL){ 
				currAniY = 1;
				if (vel.x != 0 || vel.y != 0) frameDelay = 7;
				else frameDelay = 15;
			}else if (state == ATTACK_STATE){ 
				currAniY = 3;
				frameDelay = 7;
			}
			
			if (++frameCount >= frameDelay){
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
	}
}