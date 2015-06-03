package com.YFFramework.game.core.module.activity.manager
{
	

	/***
	 *活动管理
	 *@author ludingchang 时间：2013-7-31 下午3:14:18
	 */
	public class ActivityManager
	{
		private static var _inst:ActivityManager;
		
		
		public static function get Instence():ActivityManager
		{
			return _inst||=new ActivityManager;
		}
		public function ActivityManager()
		{
		}
	}
}