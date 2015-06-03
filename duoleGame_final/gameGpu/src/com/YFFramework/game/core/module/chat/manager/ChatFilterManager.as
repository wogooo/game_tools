package com.YFFramework.game.core.module.chat.manager
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.game.gameConfig.URLTool;

	/**
	 * 文字过滤（和谐聊天）
	 * @version 1.0.0
	 * creation time：2013-8-12 上午10:54:30
	 */
	public class ChatFilterManager{
		
		private static var _filterWords:RegExp=null;
		
		public function ChatFilterManager(){
		}
		
		public static function init():void{
			var fileLoader:FileLoader = new FileLoader();
			fileLoader.loadCompleteCallBack = onLoadComplete;
			fileLoader.load(URLTool.getDataDir()+"bad_words.txt");
		}
		
		private static function onLoadComplete(fl:FileLoader):void{
			_filterWords = new RegExp(fl.data,'gi');
		}
		
		/**过滤文字
		 * @param str	要过滤的文字
		 * @return 已过滤的文字
		 */		
		public static function filter(str:String):String{
			return str.replace(_filterWords,'**');
		}
		
		public static function containsFilterWords(str:String):Boolean{
			if(_filterWords==null)	return false;
			if(str.search(_filterWords)==-1)	return false;
			return true;
		}
	}
} 