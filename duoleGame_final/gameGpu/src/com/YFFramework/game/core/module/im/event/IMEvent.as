package com.YFFramework.game.core.module.im.event
{
	/**@author yefeng
	 * 2013 2013-6-22 下午5:50:11 
	 */
	public class IMEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.im.event";
		/** 同意添加为好友
		 */		
		public static const C_AcceptAddFriend:String=Path+"C_AcceptAddFriend";
		/**  检测是否 关闭 请求好友列表面板
		 */		
		public static const CheckCloseFriendListWindow:String=Path+"CheckCloseFriendListWindow";
		/**私聊  打开私聊窗口  使用 全局的类 
		 */		
//		public static const PrivateTalkToOpenWindow:String=Path+"PrivateTalk";
		/**删除好友
		 */		
		public static const C_DeleteFriend:String=Path+"C_DeleteFriend";
		/**请求添加 好友
		 */		
		public static const C_AddFriend:String=Path+"C_AddFriend";
		/**  加入黑名单
		 */		
		public static const C_AddToBlackList:String=Path+"C_AddToBlackList";
		/**  删除 黑名单
		 */		
		public static const C_DeleteBlackList:String=Path+"C_DeleteBlackList";
		/** 删除敌人
		 */		
		public static const C_DeleteEnemy:String=Path+"C_DeleteEnemy";
		/**发送私聊信息 走 globle通道
		 */		
//		public static const C_SendPrivateTalkWords:String="C_SendPrivateTalkWords";
		public function IMEvent()
		{
		}
	}
}