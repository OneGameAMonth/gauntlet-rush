package  
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.SharedObject;
	
	public class DataManager
	{		
		public static var ROOM_INDEX:int = 0;
		public static var POSSIBLE_MAX_HP:int = 3;
		public static var MAX_HP:int = 3;
		public static var HP:Number = 3;
		public static var PLAYER_X:Number = 160;
		public static var PLAYER_Y:Number = 208;
		
		//COOKIES AND EXTERNAL SAVING
		public var success:Boolean;
		private var loader:URLLoader;
		private var cookie:SharedObject = SharedObject.getLocal("gauntletrush");
		public var highScores:Array;
		
		public function DataManager() 
		{
			success = false;
			loader = new URLLoader();
			cookie.flush();
			highScores = new Array();
		}
		
		public function SubmitScore(name:String, score:int, difficulty:String):void
		{
			var myrequest:URLRequest = new URLRequest(
				"http://cakeandturtles.comoj.com/gauntletrush/SubmitScore.php");
			myrequest.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables();
			variables.username = Config.username;
			variables.password = Config.password;
			variables.name = name;
			variables.score = score;
			variables.difficulty = difficulty;
			myrequest.data = variables;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			success = false;
			loader.addEventListener(Event.COMPLETE, SubmitComplete);
			loader.load(myrequest);
		}
		
		public function RetrieveScores():void
		{
			var myrequest:URLRequest = new URLRequest(
				"http://cakeandturtles.comoj.com/gauntletrush/RetrieveScores.php");
			myrequest.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.username = Config.username;
			variables.password = Config.password;
			myrequest.data = variables;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			success = false;
			loader.addEventListener(Event.COMPLETE, RetrieveComplete);
			loader.load(myrequest);
		}
		
		public function SubmitComplete(e:Event):void
		{
			success = true;
			trace("data: " + loader.data);
		}
		
		public function RetrieveComplete(e:Event):void
		{
			var results:String = e.target.data.phpConfirm;
			highScores = results.split("|");
			success = true;
		}
		
		/***************************************/
		//COOKIE SETTING AND RETRIEVING FUNCTIONS
		/***************************************/
		public function SetCookieVal(key:String, val:*):void
		{
			cookie.data[key] = val;
			trace(key + " set to "+val);
			cookie.flush();
		}
		
		public function GetCookieVal(key:String):Object
		{
			trace(cookie.data[key] + " recieved from " + key);
			return cookie.data[key];
		}
		
		public function ConstructCookieData():String
		{
			var data:String = "";
			data += Global.currScore+",";
			data += Global.highScore+",";
			data += HP+",";
			data += MAX_HP+",";
			data += POSSIBLE_MAX_HP+",";
			data += ROOM_INDEX+",";
			data += PLAYER_X+",";
			data += PLAYER_Y+",";
			data += Global.GAME_MODE;
			return data;
		}
		
		public function DeconstructCookieData(data:String):void
		{
			var dataArray:Array = data.split(",");

			Global.currScore = parseInt(dataArray[0]);
			Global.highScore = parseInt(dataArray[1]);
			HP = parseFloat(dataArray[2]);
			MAX_HP = parseFloat(dataArray[3]);
			POSSIBLE_MAX_HP = parseFloat(dataArray[4]);
			ROOM_INDEX = parseInt(dataArray[5]);
			PLAYER_X = parseFloat(dataArray[6]);
			PLAYER_Y = parseFloat(dataArray[7]);
			Global.GAME_MODE = parseInt(dataArray[8]);
		}
	}
}