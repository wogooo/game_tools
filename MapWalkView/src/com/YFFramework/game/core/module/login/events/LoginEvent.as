package com.YFFramework.game.core.module.login.events
{
	/**2012-8-2 下午1:44:41
	 *@author yefeng
	 */
	public class LoginEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.login.events.";
		/**客户端发送登陆请求
		 */
//		public static const C_Login:String=Path+"C_Login";
//		/**服务端请求登陆
//		 */
//		public static const S_Login:String=Path+"S_Login";
		
		
		/** 检测登录
		 */		
		public static const C_CheckLogin:String=Path+"C_CheckLogin";
		/**创建角色
		 */		
		public static const C_CreateHero:String=Path+"C_CreateHero";
		/**检测名称
		 */		
		public static const C_CheckName:String=Path+"C_CheckName";
		public function LoginEvent()
		{
		}
	}
}