package com.net
{
	import com.CMD.GameCmd;
	
	import flash.utils.Dictionary;

	public class NetManager
	{
		/**主逻辑服务器
		 */		
		public static var gameSocket:NetEngine=new NetEngine(GameCmd.CHeart);
		/**  聊天服务器
		 */		
		public static var chatSocket:NetEngine=new NetEngine(GameCmd.CHeart);
		public function NetManager()
		{
		}
		
		public static function close():void
		{
			gameSocket.close();
			chatSocket.close();
		}
		
		/**处理消息
		 */
		public static function handleMessage():void
		{
			
			gameSocket.handleMessage();
			chatSocket.handleMessage();
		}
			
			
	}
}