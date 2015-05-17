package com.YFFramework.core.net.socket
{
	import com.YFFramework.core.center.pool.AbsPool;
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**消息基类
	 * 2012-8-1 下午5:21:07
	 *@author yefeng
	 */
	public class Message
	{
		/** 命令 
		 */
		public var cmd:int;
		/**信息
		 */
		public var info:Object;
		
		private static var _instance:Message;
		public function Message()
		{
			this.cmd=cmd;
		}
		
		public function initData(cmd:int,info:Object):void
		{
			this.cmd=cmd;
			this.info=info;
		}
				
		public static function get Instance():Message
		{
			if(!_instance) _instance=new Message();
			return _instance;
		}
		
		
	}
}