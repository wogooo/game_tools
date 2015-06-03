package com.YFFramework.game.core.module.activity.manager
{
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	
	import flash.utils.Dictionary;

	public class ActiveRewardBasicManager
	{
		private static var _instance:ActiveRewardBasicManager;
		private var _dict:Dictionary;
		public function ActiveRewardBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():ActiveRewardBasicManager
		{
			if(_instance==null)_instance=new ActiveRewardBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var active_rewardBasicVo:ActiveRewardBasicVo;
			for (var id:String in jsonData)
			{
				active_rewardBasicVo=new ActiveRewardBasicVo();
				active_rewardBasicVo.level_min=jsonData[id].level_min;
				active_rewardBasicVo.reward_type=jsonData[id].reward_type;
				active_rewardBasicVo.reward_pack_id=jsonData[id].reward_pack_id;
				active_rewardBasicVo.reward_num=jsonData[id].reward_num;
				active_rewardBasicVo.level_max=jsonData[id].level_max;
				active_rewardBasicVo.reward_id=jsonData[id].reward_id;
				
				if(!_dict[active_rewardBasicVo.reward_pack_id])
					_dict[active_rewardBasicVo.reward_pack_id]=new Vector.<ActiveRewardBasicVo>;
				_dict[active_rewardBasicVo.reward_pack_id].push(active_rewardBasicVo);
			}
		}
		public function getActive_rewardBasicVo(reward_pack_id:int):Vector.<ActiveRewardBasicVo>
		{
			return _dict[reward_pack_id];
		}
	}
}