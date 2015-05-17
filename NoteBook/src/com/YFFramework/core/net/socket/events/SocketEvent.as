package com.YFFramework.core.net.socket.events
{
	/**2012-8-2 上午9:00:34
	 *@author yefeng
	 */
	public class SocketEvent
	{
		private static const Path:String="com.YFFramework.core.net.socket.events.";
		/** socket连接成功
		 */
		public static const Connnect:String="Connnect";
		/**安全沙箱错误
		 */
		public static const SecurityError:String=Path+"SecurityError";
		/**socket连接关闭
		 */
		public static const Close:String=Path+"Close";
		/**连接端口错误
		 */		
		public static const IOError:String=Path+"IOError";
		public function SocketEvent()
		{
		}
	}
}