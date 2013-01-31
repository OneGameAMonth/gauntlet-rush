package Screens 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ScoreScreen 
	{
		//text stuff
		[Embed(source = '../resources/04B_03.ttf', fontName='pixelFont',
		       mimeType='application/x-font', embedAsCFF='false')]
		private var pixelFont:Class;
		private var textFormat:TextFormat = new TextFormat();
		private var uiText:TextField = new TextField();
		private var playername:String;
		
		//animation stuff
		public var frameCount:int = 0;
		public var frameDelay:int = 15;
		
		//states
		public var state:int;
		public const ENTER_NAME:int = 0;
		public const SUBMITTING:int = 1;
		public const SUBMITTED:int = 2;
		public const RETRIEVE_SCORES:int = 3;
		public const DISPLAY_SCORES:int = 4;
		
		//etc stuff
		public var dataManager:DataManager;
		private var blinky:Boolean;
		private var ellipses:int;
		private var invalidName:Boolean;
		
		public function ScoreScreen() 
		{
			playername = "";
			state = ENTER_NAME;
				
			dataManager = new DataManager();
			blinky = false;
			ellipses = 0;
			invalidName = false;
				
			//ready the fonts
			textFormat = new TextFormat("pixelFont", 24, 0xFFFFFF);
			uiText.embedFonts = true;
			uiText.defaultTextFormat = textFormat;
			uiText.width = Global.stageWidth;
			uiText.height = Global.stageHeight;
		}
		
		public function Update():void
		{
			if (state == RETRIEVE_SCORES){
				if (dataManager.success)
					state = DISPLAY_SCORES;
			}
			else if (state == DISPLAY_SCORES){
				if (Global.CheckKeyUp(Global.ENTER))
					Game.state = Game.MAIN_MENU;
			}
			else if (state == SUBMITTED){
				if (Global.CheckKeyUp(Global.ENTER)) Game.state = Game.MAIN_MENU;
				if (Global.CheckKeyUp(Global.SPACE)){
					state = RETRIEVE_SCORES;
					dataManager.RetrieveScores();
				}
			}
			else if (state == SUBMITTING){
				if (dataManager.success){
					state = SUBMITTED;
				}
			}
			else if (state == ENTER_NAME){
				if (Global.CheckKeyUp(Global.ESC)){
					Game.state = Game.MAIN_MENU;
					return;
				}
				
				//update playername
				if (Global.CheckKeyPressed(Global.BACKSPACE) && playername.length != 0){					
					invalidName = false;
					playername = playername.substr(0, playername.length-1);
				}
				else if (playername.length < 12){
					if (Global.CheckKeyPressed(Global.UNDERSCORE)){
						if (Global.CheckKeyDown(Global.SHIFT)){
							invalidName = false;
							playername += "_";
						}
					}
					else{
						for (var k:Object in Global.LetterKeys){
							var key:int = k as int;
							if (Global.CheckKeyPressed(key)){
								invalidName = false;
								
								if (Global.CheckKeyDown(Global.SHIFT))
									playername += (Global.LetterKeys[key]).toUpperCase();
								else
									playername += Global.LetterKeys[key];
								break;
							}
						}
					}
				}	
				
				if (Global.CheckKeyUp(Global.ENTER)){
					if (!ValidateName())
						invalidName = true;
					else{
						dataManager.SubmitScore(playername, Global.currScore, GetDifficulty());
						state = SUBMITTING;
					}
				}
			}
				
			//update animation
			if (++frameCount >= frameDelay)
			{
				blinky = !blinky;
				frameCount = 0;
				ellipses++;
				if (ellipses > 3)
					ellipses = 0;
			}
		}
		
		public function GetDifficulty():String
		{
			if (Global.GAME_MODE == Global.EASY) return "easy";
			else if (Global.GAME_MODE == Global.NORMAL) return "norm";
			else if (Global.GAME_MODE == Global.HARD) return "hard";
			else return "null";
		}
		
		public function Render():void
		{			
			var i:int;
			var tempText:String;
			if (state == RETRIEVE_SCORES)
			{
				//Render the top text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "Final score: ";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 50*Global.zoom, 20*Global.zoom));
			
				uiText.text = Global.currScore.toString();
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 250*Global.zoom, 20*Global.zoom));
			
				//Render middle text
				uiText.textColor = 0xFFFFFF;
				tempText = "Loading";
				for (i = 0; i < ellipses; i++)
				{
					tempText += ".";
				}
				uiText.text = tempText;
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 90*Global.zoom, (Global.stageHeight/2)*Global.zoom));
			}
			else if (state == DISPLAY_SCORES)
			{
				//Render top text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "HIGH SCORES";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 40*Global.zoom, 10*Global.zoom));
				
				//Render middle text
				for (i = 0; i < dataManager.highScores.length-3; i++)
				{
					uiText.textColor = 0xFFFFFF;
					var name_score:Array = dataManager.highScores[i].split(",");
					
					uiText.text = (i+1) +".";
					Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 10*Global.zoom, (35+(i*23))*Global.zoom));
					
					uiText.text = name_score[0];
					Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 50*Global.zoom, (35+(i*23))*Global.zoom));
					
					uiText.text = name_score[1];
					Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 230*Global.zoom, (35+(i*23))*Global.zoom));
				}
				
				//Render bottom text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "PRESS ENTER TO CONTINUE";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 8*Global.zoom, (Global.stageHeight-28)*Global.zoom));
			}
			else if (state == SUBMITTED)
			{
				//Render the top text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "Final score: ";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 50*Global.zoom, 20*Global.zoom));
			
				uiText.text = Global.currScore.toString();
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 250*Global.zoom, 20*Global.zoom));
			
				//Render middle text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "Score submitted!";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 60*Global.zoom, (Global.stageHeight/2-16)*Global.zoom));
					
				//Render bottom text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "PRESS SPACE FOR SCORES";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 10*Global.zoom, (Global.stageHeight-64)*Global.zoom));
				
				uiText.text = "PRESS ENTER TO CONTINUE";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 8*Global.zoom, (Global.stageHeight-32)*Global.zoom));
			}
			else if (state == SUBMITTING)
			{
				//Render the top text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "Final score: ";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 50*Global.zoom, 20*Global.zoom));
			
				uiText.text = Global.currScore.toString();
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 250*Global.zoom, 20*Global.zoom));
			
				//Render middle text
				uiText.textColor = 0xFFFFFF;
				tempText = "Submitting";
				for (i = 0; i < ellipses; i++)
				{
					tempText += ".";
				}
				uiText.text = tempText;
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 80*Global.zoom, (Global.stageHeight/2)*Global.zoom));
			}
			else if (state == ENTER_NAME)
			{
				//Render the top text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "Final score: ";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 50*Global.zoom, 20*Global.zoom));
			
				uiText.text = Global.currScore.toString();
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 250*Global.zoom, 20*Global.zoom));
			
				//Render Middle-top text
				uiText.textColor = 0xFFFFFF;
				uiText.text = "Please insert name::";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 30*Global.zoom, 60*Global.zoom));
			
				//Render middle-bottom text
				uiText.textColor = 0xFFFFFF;
				var tempName:String;
				if (blinky && playername.length < 12)
					tempName = playername+"_"
				else
					tempName = playername;
				uiText.text = ">> " + tempName;
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 40*Global.zoom, (Global.stageHeight/2-16)*Global.zoom));
				
				//Render invalid name text
				if (invalidName)
				{
					uiText.textColor = 0xCD0000;
					uiText.text = "INVALID NAME!!";
					Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 70*Global.zoom, (Global.stageHeight/2+16)*Global.zoom));
				}
				
				//Render bottom text
				uiText.textColor = 0xFFFFFF;
				
				uiText.text = "PRESS ESCAPE TO QUIT";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 20*Global.zoom, (Global.stageHeight-64)*Global.zoom));
				uiText.text = "PRESS ENTER TO CONTINUE";
				Game.Renderer.draw(uiText, new Matrix(Global.zoom, 0, 0, Global.zoom, 8*Global.zoom, (Global.stageHeight-32)*Global.zoom));
			}
		}
		
		public function Restart():void
		{
			state = ENTER_NAME;
			dataManager = new DataManager();
			blinky = false;
			ellipses = 0;
			invalidName = false;
		}
		
		//
		//CHECK TO SEE IF NAME IS VALID AND KID-FRIENDLY
		public function ValidateName():Boolean
		{
			var check:String = playername.toLowerCase();
			check = check.split("4").join("a");
			check = check.split("0").join("o");
			check = check.split("1").join("l");
			check = check.split("5").join("s");
			check = check.split("7").join("t");
			check = check.split("3").join("e");
			
			if (check == "" ||	check.search("cunt") != -1 || 
				check.search("piss") != -1 || check.search("bitch") != -1 || 
				check.search("fuck") != -1 || check.search("wank") != -1 ||
				check.search("testicle") != -1 || check.search("penis") != -1 ||
				check.search("anus") != -1 || check.search("cock") != -1 ||
				check.search("dick") != -1 || check.search("pussy") != -1 ||
				check.search("rape") != -1 || check.search("nigger") != -1 ||
				check.search("shit") != -1 || check.search("boner") != -1 ||
				check.search("bastard") != -1 || check.search("clit") != -1 ||
				check.search("cooch") != -1 || check.search("semen") != -1 ||
				check.search("chode") != -1 || check.search("choad") != -1 ||
				check.search("slut") != -1 || check.search("cunnilingus") != -1 ||
				check.search("cameltoe") != -1 || check.search("camel_toe") != -1 ||
				check.search("blowjob") != -1 || check.search("blow_job") != -1 ||
				check.search("handjob") != -1 || check.search("hand_job") != -1 ||
				check.search("damn") != -1 || check.search("dammit") != -1 ||
				check.search("douche") != -1 || check.search("dildo") != -1 ||
				check.search("dike") != -1 || check.search("dyke") != -1 ||
				check.search("fag") != -1 || check.search("fellatio") != -1 ||
				check.search("gay") != -1 || check.search("hump") != -1 ||
				check.search("beaner") != -1 || check.search("gringo") != -1 ||
				check.search("guido") != -1 || check.search("jizz") != -1 ||
				check.search("jigaboo") != -1 || check.search("jackoff") != -1 ||
				check.search("jack_off") != -1 || check.search("jerkoff") != -1 ||
				check.search("jerk_off") != -1 || check.search("masterbate") != -1 ||
				check.search("masturbate") != -1 || check.search("master_bate") != -1 ||
				check.search("kike") != -1 || check.search("kooch") != -1 ||
				check.search("kouch") != -1 || check.search("lesbian") != -1 ||
				check.search("lesbo") != -1 || check.search("minge") != -1 ||
				check.search("nigga") != -1 || check.search("niglet") != -1 ||
				check.search("nutsack") != -1 || check.search("nut_sack") != -1 ||
				check.search("nigaboo") != -1 || check.search("negro") != -1 ||
				check.search("orgy") != -1 || check.search("orgasm") != -1 ||
				check.search("pussies") != -1 || check.search("queer") != -1 ||
				check.search("queef") != -1 || check.search("rimjob") != -1 ||
				check.search("rim_job") != -1 || check.search("schlong") != -1 ||
				check.search("scrot") != -1 || check.search("splooge") != -1 ||
				check.search("smeg") != -1 || check.search("skeet") != -1 ||
				check.search("tard") != -1 || check.search("tit") != -1 ||
				check.search("twat") != -1 || check.search("jayjay") != -1 ||
				check.search("jay_jay") != -1 || check.search("vag") != -1 ||
				check.search("whore") != -1)
				return false;
			
			if (check.search("ass") != -1)
			{
				if (check.search("mass") == -1 && check.search("pass") == -1 &&
					check.search("lass") == -1 && check.search("grass") == -1 &&
					check.search("bass") == -1 && check.search("tass") == -1 &&
					check.search("gass") == -1 && check.search("sass") == -1)
					return false;
			}
			if (check.search("poon") != -1)
			{
				if (check.search("harpoon") == -1)
					return false;
			}
			if (check.search("cum") != -1)
			{
				if (check.search("cucumber") == -1 && check.search("cumin") == -1)
					return false;
			}
			if (check.search("muff") != -1)
			{
				if (check.search("muffin") == -1)
					return false;
			}
			
			return true;
		}
	}
}