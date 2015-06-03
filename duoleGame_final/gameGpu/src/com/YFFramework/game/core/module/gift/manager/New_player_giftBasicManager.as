package com.YFFramework.game.core.module.gift.manager
{
	import com.YFFramework.game.core.module.gift.model.New_player_giftBasicVo;
	
	import flash.utils.Dictionary;

	public class New_player_giftBasicManager
	{
		private static var _instance:New_player_giftBasicManager;
		private var _dict:Dictionary;
		public function New_player_giftBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():New_player_giftBasicManager
		{
			if(_instance==null)_instance=new New_player_giftBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var new_player_giftBasicVo:New_player_giftBasicVo;
			for (var id:String in jsonData)
			{
				new_player_giftBasicVo=new New_player_giftBasicVo();
				new_player_giftBasicVo.name=jsonData[id].name;
				new_player_giftBasicVo.id=jsonData[id].id;
				new_player_giftBasicVo.icon_id=jsonData[id].icon_id;
				_dict[new_player_giftBasicVo.id]=new_player_giftBasicVo;
			}
		}
		public function getNew_player_giftBasicVo(id:int):New_player_giftBasicVo
		{
			return _dict[id];
		}
	}
}