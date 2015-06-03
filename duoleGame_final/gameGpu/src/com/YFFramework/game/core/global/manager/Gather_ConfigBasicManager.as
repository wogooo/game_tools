package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.Gather_ConfigBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.utils.Dictionary;

	public class Gather_ConfigBasicManager
	{
		private static var _instance:Gather_ConfigBasicManager;
		private var _dict:Dictionary;
		public function Gather_ConfigBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Gather_ConfigBasicManager
		{
			if(_instance==null)_instance=new Gather_ConfigBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var gather_ConfigBasicVo:Gather_ConfigBasicVo;
			for (var id:String in jsonData)
			{
				gather_ConfigBasicVo=new Gather_ConfigBasicVo();
				gather_ConfigBasicVo.bubble2=jsonData[id].bubble2;
				gather_ConfigBasicVo.level=jsonData[id].level;
				gather_ConfigBasicVo.bubble1=jsonData[id].bubble1;
				gather_ConfigBasicVo.wordInterval=jsonData[id].wordInterval;
				gather_ConfigBasicVo.camp=jsonData[id].camp;
				gather_ConfigBasicVo.life_skill_level=jsonData[id].life_skill_level;
				gather_ConfigBasicVo.basic_id=jsonData[id].basic_id;
				gather_ConfigBasicVo.model_id=jsonData[id].model_id;
				gather_ConfigBasicVo.life_skill_id=jsonData[id].life_skill_id;
				gather_ConfigBasicVo.name=jsonData[id].name;
				gather_ConfigBasicVo.bubble3=jsonData[id].bubble3;
				gather_ConfigBasicVo.gather_time=jsonData[id].gather_time;
				gather_ConfigBasicVo.icon_id=jsonData[id].icon_id;
				
				gather_ConfigBasicVo.item_id1=jsonData[id].item_id1;
				gather_ConfigBasicVo.item_id2=jsonData[id].item_id2;
				gather_ConfigBasicVo.item_id3=jsonData[id].item_id3;

				_dict[gather_ConfigBasicVo.basic_id]=gather_ConfigBasicVo;
			}
		}
		public function getGather_ConfigBasicVo(basic_id:int):Gather_ConfigBasicVo
		{
			return _dict[basic_id];
		}
		public function getIconUrl(basic_id:int):String
		{
			var gather_ConfigBasicVo:Gather_ConfigBasicVo= 	_dict[basic_id];
			var url:String=URLTool.getGatherIcon(gather_ConfigBasicVo.icon_id);
			return url;
		}
	}
}