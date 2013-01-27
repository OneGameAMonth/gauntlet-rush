package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import Areas.*;
	
	public class Game 
	{	
		public var screenBitmap:Bitmap;
		public static var Screen:BitmapData;
		
		public static var roomArray:Array;
		public static var roomIndex:int;
		
		//sound loading...
		[Embed(source = 'resources/sounds/LOZ_Hit.mp3')]
		private var Hit_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Hurt.mp3')]
		private var Hurt_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Kill.mp3')]
		private var Kill_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Shield.mp3')]
		private var Shield_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Sword.mp3')]
		private var Sword_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Boss_Scream2.mp3')]
		private var Boss_scream2_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Die.mp3')]
		private var Die_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Get_Item.mp3')]
		private var Get_item_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Unlock.mp3')]
		private var Unlock_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Bomb_Blow.mp3')]
		private var Bomb_blow_sound:Class;
		[Embed(source = 'resources/sounds/rollSound.mp3')]
		private var Roll_sound:Class;
		[Embed(source = 'resources/sounds/thudSound.mp3')]
		private var Thud_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_MagicalRod.mp3')]
		private var MagicalRod_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Get_Rupee.mp3')]
		private var Get_Rupee_sound:Class;
		
		public function Game() 
		{
			trace("Game created");
			Screen = new BitmapData(Global.stageWidth*Global.zoom, Global.stageHeight*Global.zoom, false, 0x000000);
			screenBitmap = new Bitmap(Screen);
			
			roomArray = [];
			roomArray.push(new Room00());
			roomArray.push(new Room01());
			roomArray.push(new Room02());
			roomArray.push(new Room03());
			roomArray.push(new Room04());
			roomArray.push(new Room05());
			roomArray.push(new Room06());
			roomArray.push(new Room07());
			roomIndex = 0;
			
			Global.MAX_HP = 3;
			Global.HP = Global.MAX_HP;
			
			//loading sounds
			SoundManager.getInstance().addSfx(new Hit_sound(), "HitSound");
			SoundManager.getInstance().addSfx(new Hurt_sound(), "HurtSound");
			SoundManager.getInstance().addSfx(new Kill_sound(), "KillSound");
			SoundManager.getInstance().addSfx(new Shield_sound(), "ShieldSound");
			SoundManager.getInstance().addSfx(new Sword_sound(), "SwordSound");
			SoundManager.getInstance().addSfx(new Boss_scream2_sound(), "BossScream2Sound");
			SoundManager.getInstance().addSfx(new Die_sound(), "DieSound");
			SoundManager.getInstance().addSfx(new Get_item_sound(), "GetItemSound");
			SoundManager.getInstance().addSfx(new Unlock_sound(), "UnlockSound");
			SoundManager.getInstance().addSfx(new Bomb_blow_sound(), "BombBlowSound");
			SoundManager.getInstance().addSfx(new Roll_sound(), "RollSound");
			SoundManager.getInstance().addSfx(new Thud_sound(), "ThudSound");
			SoundManager.getInstance().addSfx(new MagicalRod_sound(), "MagicalRodSound");
			SoundManager.getInstance().addSfx(new Get_Rupee_sound(), "GetRupeeSound");
		}
		
		public function Render():void
		{
			Screen.lock();
			roomArray[roomIndex].Render();
			Screen.unlock();
		}
		
		public function Update():void
		{
			roomArray[roomIndex].Update();
			
			//clear out the "keys_up" array for next update
			Global.keys_up = new Array();
			Global.keys_pressed = new Array();
		}
		
		/*************************************************************************************/
		//HANDLE AND DETECT PLAYER INPUT
		/*************************************************************************************/
		public function KeyUp(e:KeyboardEvent):void
		{
			//position of key in the array
			var key_pos:int = -1;
			for (var i:int = 0; i < Global.keys_down.length; i++)
			{
				if (e.keyCode == Global.keys_down[i])
				{
					//the key is found/was pressed before, so store the position
					key_pos = i;
					break;
				}
			}
			//remove the keycode from keys_down if found
			if (key_pos!=-1)
				Global.keys_down.splice(key_pos, 1);
			
			Global.keys_up.push(e.keyCode);
		}
		
		public function KeyDown(e:KeyboardEvent):void
		{
			//check to see if the key that is being pressed is already in the array of pressed keys
			var key_down:Boolean = false;
			for (var i:int = 0; i < Global.keys_down.length; i++)
			{
				if (Global.keys_down[i] == e.keyCode)
					key_down = true;
			}
			
			//add the key to the array of pressed keys if it wasn't already in there
			if (!key_down)
			{
				Global.keys_down.push(e.keyCode);
				Global.keys_pressed.push(e.keyCode);
			}
		}
	}
}