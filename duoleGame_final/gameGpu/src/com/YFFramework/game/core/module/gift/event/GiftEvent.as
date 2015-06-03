package com.YFFramework.game.core.module.gift.event
{
	/***
	 *
	 *@author ludingchang 时间：2013-9-10 上午11:44:09
	 */
	public class GiftEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.gift.event.";
		/**签到礼包请求*/
		public static const PageAsk:String=Path+"PageAsk";
		/**请求自己的签到次数*/
		public static const CountAsk:String=Path+"CountAsk";
		
		public function GiftEvent()
		{
		}
	}
}