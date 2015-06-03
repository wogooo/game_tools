package com.YFFramework.game.core.module.activity.model
{
	/***
	 *用于活动界面的统一VO
	 *@author ludingchang 时间：2013-12-30 上午10:31:15
	 */
	public class ActiveBaseVo
	{
		/**经验 评级*/
		public var expStar:int;
		/**钱 评级*/
		public var moneyStar:int;
		/**道具 评级*/
		public var propsStar:int;
		/**描述*/
		public var desc:String;
		/**奖励数组*/
		public var rewards:Vector.<ActiveBaseRewardVo>;
		public function ActiveBaseVo()
		{
			rewards=new Vector.<ActiveBaseRewardVo>;
		}
	}
}