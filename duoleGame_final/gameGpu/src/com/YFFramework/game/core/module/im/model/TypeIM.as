package com.YFFramework.game.core.module.im.model
{
	/**@author yefeng
	 * 2013 2013-6-22 下午2:35:38 
	 */
	public class TypeIM
	{
		/**在线 状态
		 */		
		public static const Online:int=1;
		/**离线状态
		 */		
		public static const Offline:int=0;

		/** 好友 
		 */		
		public static const Ralation_Friend:int=1;
		/**  仇人
		 */		
		public static const Ralation_Enemy:int=2;
		/**  黑名单
		 */
		public static const Ralation_Blacklist:int=3;
		public function TypeIM()
		{
		}
	}
}