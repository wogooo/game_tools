package com.YFFramework.game.core.module.raid.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-11-6 下午2:24:52
	 */
	public class RaidRewardShowVo{
		
		/**唯一ID*/
		public var rewardId:int;
		/**奖励类型*/
		public var rewardType:int;
		/**得到的东西的ID*/
		public var itemId:int;
		/**关联类型，是副本、活动、BOSS
		 * <br>定义在TypeRewardShow类里
		 * */
		public var type:int;
		
		public function RaidRewardShowVo(){
		}
		
		public function get key():String
		{
			return type+"_"+rewardId;
		}
	}
} 