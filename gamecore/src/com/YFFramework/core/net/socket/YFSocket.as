package com.YFFramework.core.net.socket
{
	import com.YFFramework.core.net.socket.absSocket.SocketClient;

	/**
	 * author :夜枫 * 时间 ：2011-9-28 下午04:19:31
	 */
	public final class YFSocket
	{
		protected static var _instance:YFSocket;
		private var socket:SocketClient;
		public function YFSocket()
		{
			if(_instance) throw new Error("请使用Instance属性");
		}
		public static  function get Instance():YFSocket
		{
			if(!_instance) _instance=new YFSocket();
			return _instance;
		}
		public function initData(host:String,port:int,checkPort:int=843):void
		{
			socket=new SocketClient(host,port,checkPort);
		}
		/**发送消息
		 * @param msg
		 */		
//		public function sendMessage(msg:Message):void
//		{
//			socket.sendData(msg);
//		}

		/**
		 * @param cmd 协议命令
		 * @param info  具体vo 
		 */		
		public function sendMessage(cmd:int,info:Object=null):void
		{
			Message.Instance.initData(cmd,info);
			socket.sendData(Message.Instance);
		}
		
	}
}