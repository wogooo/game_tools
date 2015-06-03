package com.YFFramework.game.core.module.onlineReward.manager
{
	import com.YFFramework.game.core.module.activity.manager.ActiveRewardBasicManager;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.YFFramework.game.core.module.onlineReward.model.OnlineRewardBasicVo;
	
	import flash.utils.Dictionary;

	public class OnlineRewardBasicManager
	{
		private static var _instance:OnlineRewardBasicManager;
		private var _dict:Dictionary;
		private var _current_index:int;//从1开始
		private var _total:int;
		/**剩余秒数*/
		public var remainTime:int;
		public function OnlineRewardBasicManager()
		{
			_dict=new Dictionary();
			_current_index=1;
			_total=0;
		}
		public static function get Instance():OnlineRewardBasicManager
		{
			if(_instance==null)_instance=new OnlineRewardBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var onlineRewardBasicVo:OnlineRewardBasicVo;
			for (var id:String in jsonData)
			{
				onlineRewardBasicVo=new OnlineRewardBasicVo();
				onlineRewardBasicVo.id=jsonData[id].id;
				onlineRewardBasicVo.time=jsonData[id].time;
				onlineRewardBasicVo.reward_id=jsonData[id].reward_id;
				_dict[onlineRewardBasicVo.id]=onlineRewardBasicVo;
				_total++;
			}
		}
		public function getOnlineRewardBasicVo(id:int):OnlineRewardBasicVo
		{
			return _dict[id];
		}
		public function getCurrentOnlineRewardBasicVo():OnlineRewardBasicVo
		{
			return _dict[_current_index];
		}
		
		public function getNextOnlineRewardBasicVo():OnlineRewardBasicVo
		{
			_current_index++;
			return _dict[_current_index];
		}
		
		public function set current_index(index:int):void
		{
			_current_index=index;
		}
		
		public function get isLastOne():Boolean
		{
			return _current_index>=_total;
		}
		
		/**取当前次的奖励数组*/
		public function getCurrentRewards():Vector.<ActiveRewardBasicVo>
		{
			return ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(getCurrentOnlineRewardBasicVo().reward_id);
		}
	}
}