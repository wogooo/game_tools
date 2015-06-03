package com.YFFramework.game.core.module.raid.event
{
	/**
	 * @version 1.0.0
	 * creation time：2013-6-27 上午11:15:43
	 */
	public class RaidEvent{
		
		private static const Path:String="com.YFFramework.game.core.module.raid.event";
		/**离开副本请求 
		 */		
		public static const ExitRaidReq:String = Path + "ExitRaidReq";
		/**关闭副本请求
		 */		
		public static const CloseRaidReq:String = Path + "CloseRaidReq";
		/**所有副本进入都发这个事件，包括活动类的副本 */		
		public static const EnterAllRaid:String = Path + "EnterAllRaid";
		/**请求获得副本奖励 */
		public static const FetchRaidReward:String = Path + "FetchRaidReward";
		
		public function RaidEvent(){
		}
	}
} 