package com.YFFramework.game.core.module.character.model
{
	import flash.utils.Dictionary;

	public class TitleBasicManager
	{
		private static var _instance:TitleBasicManager;
		private var _dict:Dictionary;
		/** 按照称号分类建立的 */		
		private var _titleTypeDict:Dictionary;
		public function TitleBasicManager()
		{
			_dict=new Dictionary();
			_titleTypeDict=new Dictionary();
		}
		public static function get Instance():TitleBasicManager
		{
			if(_instance==null)_instance=new TitleBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var titleBasicVo:TitleBasicVo;
			var ary:Array;
			for (var id:String in jsonData)
			{
				titleBasicVo=new TitleBasicVo();
				titleBasicVo.attr_id=jsonData[id].attr_id;
				titleBasicVo.title_id=jsonData[id].title_id;
				titleBasicVo.title_type=jsonData[id].title_type;
				titleBasicVo.name=jsonData[id].name;
				titleBasicVo.attr_value=jsonData[id].attr_value;
				titleBasicVo.title_condition=jsonData[id].title_condition;
				titleBasicVo.effect_id=jsonData[id].effect_id;
				_dict[titleBasicVo.title_id]=titleBasicVo;
				
				if(_titleTypeDict[titleBasicVo.title_type] == null)
					_titleTypeDict[titleBasicVo.title_type]=new Array();
				ary=_titleTypeDict[titleBasicVo.title_type];
				ary.push(titleBasicVo);
			}
		}
		public function getTitleBasicVo(title_id:int):TitleBasicVo
		{
			return _dict[title_id];
		}
		
		public function getTitleType(type:int):Array
		{
			var ary:Array=_titleTypeDict[type];
			ary.sortOn("title_id",Array.NUMERIC);
			return ary;
		}
	}
}