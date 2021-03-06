package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.Char_Level_ExperienceBasicVo;
	
	import flash.utils.Dictionary;
	/** 人物等级经验表 缓存Char_Level_Experience表
	 */	
	public class Char_Level_ExperienceBasicManager
	{
		private static var _instance:Char_Level_ExperienceBasicManager;
		private var _dict:Dictionary;
		public function Char_Level_ExperienceBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Char_Level_ExperienceBasicManager
		{
			if(_instance==null)_instance=new Char_Level_ExperienceBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var char_Level_ExperienceBasicVo:Char_Level_ExperienceBasicVo;
			for (var id:String in jsonData)
			{
				char_Level_ExperienceBasicVo=new Char_Level_ExperienceBasicVo();
				char_Level_ExperienceBasicVo.level=jsonData[id].level;
				char_Level_ExperienceBasicVo.experience=jsonData[id].experience;
				_dict[char_Level_ExperienceBasicVo.level]=char_Level_ExperienceBasicVo;
			}
		}
		public function getChar_Level_ExperienceBasicVo(level:int):Char_Level_ExperienceBasicVo
		{
			return _dict[level];
		}
		/**获取经验值
		 */		
		public function getExp(level:int):int
		{
			var char_Level_ExperienceBasicVo:Char_Level_ExperienceBasicVo=getChar_Level_ExperienceBasicVo(level);
			return char_Level_ExperienceBasicVo.experience;
		}
	}
}