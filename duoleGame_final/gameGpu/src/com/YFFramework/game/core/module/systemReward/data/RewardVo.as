package com.YFFramework.game.core.module.systemReward.data
{
	/***
	 *
	 * 奖励VO
	 *@author ludingchang 时间：2013-9-4 上午11:59:21
	 */
	public class RewardVo
	{
		/**礼包名字*/
		public var name:String;
		/**领取后会得到的东西 <code>RewardItemVo</code>*/
		public var items:Array;
		/**到期时间*/
		public var expiration_time:Number;
		/**礼包ID*/
		public var id:int;
		/**类型 <code>TypeRewardSource</code>*/
		public var type:int;
		public function RewardVo()
		{
		}
	}
}