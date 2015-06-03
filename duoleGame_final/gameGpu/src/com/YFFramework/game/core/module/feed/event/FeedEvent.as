package com.YFFramework.game.core.module.feed.event
{
	/***
	 *分享，邀请好友等，事件
	 *@author ludingchang 时间：2013-12-5 下午1:53:38
	 */
	public class FeedEvent
	{
		private static const path:String="com.YFFramework.game.core.module.feed.event.";
		
		/**装备强化*/
		public static const EquipStrength:String=path+"EquipStrength";
		/**切磋胜利*/
		public static const PKWin:String=path+"PKWin";
		/**通关副本*/
		public static const RaidWin:String=path+"RaidWin";
		/**保存feed数据*/
		public static const SaveFeedID:String=path+"SaveFeedID";
		/**邀请好友*/
		public static const InviteFriends:String=path+"InviteFriends";
	}
}