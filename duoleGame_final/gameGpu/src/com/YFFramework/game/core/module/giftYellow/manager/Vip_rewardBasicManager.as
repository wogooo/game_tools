package com.YFFramework.game.core.module.giftYellow.manager
{
	import flash.utils.Dictionary;
	import com.YFFramework.game.core.module.giftYellow.model.Vip_rewardBasicVo;

	public class Vip_rewardBasicManager
	{
		private static var _instance:Vip_rewardBasicManager;
		private var _dict:Dictionary;
		public function Vip_rewardBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Vip_rewardBasicManager
		{
			if(_instance==null)_instance=new Vip_rewardBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var vip_rewardBasicVo:Vip_rewardBasicVo;
			for (var id:String in jsonData)
			{
				vip_rewardBasicVo=new Vip_rewardBasicVo();
				vip_rewardBasicVo.reward_id=jsonData[id].reward_id;
				vip_rewardBasicVo.id=jsonData[id].id;
				_dict[vip_rewardBasicVo.id]=vip_rewardBasicVo;
			}
		}
		public function getVip_rewardBasicVo(id:int):Vip_rewardBasicVo
		{
			return _dict[id];
		}
	}
}