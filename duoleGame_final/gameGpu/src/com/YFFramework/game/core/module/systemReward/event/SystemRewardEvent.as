package com.YFFramework.game.core.module.systemReward.event
{
	/***
	 *系统奖励事件定义类
	 *@author ludingchang 时间：2013-9-4 下午1:44:04
	 */
	public class SystemRewardEvent
	{
		private static const Path:String = "com.YFFramework.game.core.module.systemReward.event.";
		/**请求领取一个礼包*/
		public static const GetOne:String = Path + "GetOne";
		/**请求领取所有礼包*/
		public static const GetAll:String = Path + "GetAll";
		/**刷新奖励信息*/
		public static const UpdateInfo:String = Path + "UpdateInfo";
		
		public function SystemRewardEvent()
		{
		}
	}
}