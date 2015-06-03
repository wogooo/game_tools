package com.YFFramework.game.core.module.giftYellow.event
{
	/***
	 *
	 *@author ludingchang 时间：2013-12-6 下午3:19:52
	 */
	public class GiftYellowEvent
	{
		private static const path:String="com.YFFramework.game.core.module.giftYellow.event.";
		/**更改显示的页面*/
		public static const UpdateIndex:String=path+"UpdateIndex";
		/**调用开通黄钻的API*/
		public static const CallOpenAPI:String=path+"CallOpenAPI";
		/**调用开通年费黄钻的API*/
		public static const CallOpenYearAPI:String=path+"CallOpenYearAPI";
		/**请求领取黄钻新手礼包*/
		public static const AskNewPlayerGift:String=path+"AskNewPlayerGift";
		/**请求领取黄钻每日礼包*/
		public static const AskDayGift:String=path+"AskDayGift";
		/**请求领取年费黄钻每日礼包*/
		public static const AskYearDayGift:String=path+"AskYearDayGift";
	}
}