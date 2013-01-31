package  
{
	public class SoundLoader 
	{
		[Embed(source = 'resources/sounds/LOZ_Hit.mp3')]
		private static var Hit_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Hurt.mp3')]
		private static var Hurt_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Kill.mp3')]
		private static var Kill_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Shield.mp3')]
		private static var Shield_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Sword.mp3')]
		private static var Sword_sound:Class;
		[Embed(source = 'resources/sounds/LA_Enemy_Die_Power.mp3')]
		private static var Boss_hit_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Boss_Scream1.mp3')]
		private static var Boss_scream1_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Boss_Scream2.mp3')]
		private static var Boss_scream2_sound:Class;
		[Embed(source = 'resources/sounds/button.mp3')]
		private static var Button_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Die.mp3')]
		private static var Die_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Get_Item.mp3')]
		private static var Get_item_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Unlock.mp3')]
		private static var Unlock_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Bomb_Blow.mp3')]
		private static var Bomb_blow_sound:Class;
		[Embed(source = 'resources/sounds/rollSound.mp3')]
		private static var Roll_sound:Class;
		[Embed(source = 'resources/sounds/thudSound.mp3')]
		private static var Thud_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_MagicalRod.mp3')]
		private static var MagicalRod_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Get_Rupee.mp3')]
		private static var Get_Rupee_sound:Class;
		[Embed(source = 'resources/sounds/awakenSound.mp3')]
		private static var Awaken_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Text.mp3')]
		private static var Text_sound:Class;
		[Embed(source = 'resources/sounds/AOL_Pause.mp3')]
		private static var Select_sound:Class;
		[Embed(source = 'resources/sounds/OOT_LowHealth.mp3')]
		private static var LowHealth_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Get_Heart.mp3')]
		private static var GetHeart_sound:Class;
		[Embed(source = 'resources/sounds/LA_Boss_Bursting.mp3')]
		private static var SpawnEnemy_sound:Class;
		[Embed(source = 'resources/sounds/LOZ_Sword_Shoot.mp3')]
		private static var SwordShoot_sound:Class;
		
		[Embed(source = 'resources/sounds/music/01-intro.mp3')]
		private static var Intro_music:Class;
		[Embed(source = 'resources/sounds/music/03-battle.mp3')]
		private static var Battle_music:Class;
		[Embed(source = 'resources/sounds/music/04-labyrinth.mp3')]
		private static var Labyrinth_music:Class;
		[Embed(source = 'resources/sounds/music/10-ending.mp3')]
		private static var Ending_music:Class;
		[Embed(source = 'resources/sounds/music/09-deathmountain.mp3')]
		private static var DeathMountain_music:Class;
		[Embed(source = 'resources/sounds/music/26-minibossbattle.mp3')]
		private static var Miniboss_music:Class;
		[Embed(source = 'resources/sounds/music/27-bossbattle.mp3')]
		private static var Boss_music:Class;
		
		public function SoundLoader() 
		{}
		
		public static function LoadSounds():void
		{
			//loading sounds
			SoundManager.getInstance().addSfx(new Hit_sound(), "HitSound");
			SoundManager.getInstance().addSfx(new Hurt_sound(), "HurtSound");
			SoundManager.getInstance().addSfx(new Kill_sound(), "KillSound");
			SoundManager.getInstance().addSfx(new Shield_sound(), "ShieldSound");
			SoundManager.getInstance().addSfx(new Sword_sound(), "SwordSound");
			SoundManager.getInstance().addSfx(new Boss_hit_sound(), "BossHitSound");
			SoundManager.getInstance().addSfx(new Boss_scream1_sound(), "BossScream1Sound");
			SoundManager.getInstance().addSfx(new Boss_scream2_sound(), "BossScream2Sound");
			SoundManager.getInstance().addSfx(new Button_sound(), "ButtonSound");
			SoundManager.getInstance().addSfx(new Die_sound(), "DieSound");
			SoundManager.getInstance().addSfx(new Get_item_sound(), "GetItemSound");
			SoundManager.getInstance().addSfx(new Unlock_sound(), "UnlockSound");
			SoundManager.getInstance().addSfx(new Bomb_blow_sound(), "BombBlowSound");
			SoundManager.getInstance().addSfx(new Roll_sound(), "RollSound");
			SoundManager.getInstance().addSfx(new Thud_sound(), "ThudSound");
			SoundManager.getInstance().addSfx(new MagicalRod_sound(), "MagicalRodSound");
			SoundManager.getInstance().addSfx(new Get_Rupee_sound(), "GetRupeeSound");
			SoundManager.getInstance().addSfx(new Awaken_sound(), "AwakenSound");
			SoundManager.getInstance().addSfx(new Text_sound(), "TextSound");
			SoundManager.getInstance().addSfx(new Select_sound(), "SelectSound");
			SoundManager.getInstance().addSfx(new LowHealth_sound(), "LowHealthSound");
			SoundManager.getInstance().addSfx(new GetHeart_sound(), "GetHeartSound");
			SoundManager.getInstance().addSfx(new SpawnEnemy_sound(), "SpawnEnemySound");
			SoundManager.getInstance().addSfx(new SwordShoot_sound(), "SwordShootSound");
			
			SoundManager.getInstance().addMusic(new Intro_music(), "IntroMusic");
			SoundManager.getInstance().addMusic(new Battle_music(), "BattleMusic");
			SoundManager.getInstance().addMusic(new Labyrinth_music(), "LabyrinthMusic");
			SoundManager.getInstance().addMusic(new Ending_music(), "EndingMusic");
			SoundManager.getInstance().addMusic(new DeathMountain_music(), "DeathMountainMusic");
			SoundManager.getInstance().addMusic(new Miniboss_music(), "MinibossMusic");
			SoundManager.getInstance().addMusic(new Boss_music(), "BossMusic");
		}
	}
}