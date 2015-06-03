package com.YFFramework.game.core.module.im.manager
{
	

	/**@author yefeng
	 * 2013 2013-6-22 下午2:46:16 
	 */
	public class IMManager
	{
		/**好友列表  不 包括自己
		 */		
		public var friendList:UserListManager;
		/**仇人列表
		 */		
		public var EnemyList:UserListManager;
		/**    黑名单列表
		 */		
		public var blackList:UserListManager;
		
		private static var _instance:IMManager;
		public function IMManager()
		{
			friendList=new UserListManager();
			EnemyList=new UserListManager();
			blackList=new UserListManager();
		}
		public static function get Instance():IMManager
		{
			if(!_instance)_instance=new IMManager();
			return _instance;
		}
		
	}
}