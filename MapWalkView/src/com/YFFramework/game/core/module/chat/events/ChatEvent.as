package com.YFFramework.game.core.module.chat.events
{
	/**@author yefeng
	 *2012-4-21下午7:28:35
	 */
	public class ChatEvent
	{
		private static const Path:String="com.YFFramework.game.core.event.";
		/** 进入游戏
		 */
		public static const LOGIN:String=Path+"Login";
		
		/**充值  点击 主界面充值按钮触发
		 */
		public static const Charge:String=Path+"charge"; 
		
		public function ChatEvent()
		{
		}
	}
}