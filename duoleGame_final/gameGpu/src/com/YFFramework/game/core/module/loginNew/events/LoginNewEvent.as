package com.YFFramework.game.core.module.loginNew.events
{
	/**@author yefeng
	 * 2013 2013-8-20 上午10:31:30 
	 */
	public class LoginNewEvent
	{
		/**路径
		 */		
		private static const Path:String="com.YFFramework.game.core.module.loginNew.events.";
		/**开始连接socket 
		 */
		public static const BeginConnectSocket:String=Path+"BeginConnectSocket";
		
		/**开始进行注册
		 */
		public static const C_CreateHero:String=Path+"C_CreateHero";
		/** 检测名称
		 */
		public static const C_CheckName:String=Path+"C_CheckName";

		
		public function LoginNewEvent()
		{
		}
	}
}