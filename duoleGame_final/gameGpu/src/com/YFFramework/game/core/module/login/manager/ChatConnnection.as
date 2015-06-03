package com.YFFramework.game.core.module.login.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.chat.manager.ChatDataManager;
	import com.YFFramework.game.debug.Log;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.chat_cmd.ChatCmd;
	import com.msg.chat.CLoginReq;
	import com.msg.chat.SLoginRsp;
	import com.msg.enumdef.RspMsg;
	import com.net.NetEvent;
	import com.net.NetManager;
	
	import flash.utils.setTimeout;

	/**处理聊天服务器的 socket登录   在进入游戏后才开始连接聊天服务器
	 * @author yefeng
	 * 2013 2013-6-1 下午1:54:16 
	 */
	public class ChatConnnection
	{
		/**是否已经连接
		 */
		public static var isConnnect:Boolean=false;
		/**重连次数 
		 */		
		private static var reTryTime:int=3;
		/**重连等待时间 
		 */		
		private static var reTryWaitTime:int=1000;
		
		public function ChatConnnection(){
			NetManager.chatSocket.addCallback(ChatCmd.SLoginRsp,SLoginRsp,onChatReply);
		}
		
		public function connect():void{
			NetManager.chatSocket.addEventListener(NetEvent.ON_CONNECT,onSocketConenct);     
			NetManager.chatSocket.addEventListener(NetEvent.ON_DISCONNECT,onSocketConenct);       
			NetManager.chatSocket.addEventListener(NetEvent.ON_ERROR_CODE,onSocketConenct);  
			socketConnect();
		}
		
		private function socketConnect():void{
			NetManager.chatSocket.connect(ConfigManager.Instance.selectIp,ConfigManager.Instance.chatPort,ConfigManager.Instance.checkport);
		//	NetManager.chatSocket.connect(ConfigManager.Instance.chatIp,ConfigManager.Instance.chatPort,ConfigManager.Instance.checkport);
		}
		
		private function onSocketConenct(e:YFEvent):void{
			switch(e.type){
				case NetEvent.ON_CONNECT:
					initChatSocket();
					print(this,"聊天服务器连接成功，等待验证....");
					Log.Instance.v("聊天服务器连接成功，等待验证....");
					break;
				case NetEvent.ON_DISCONNECT:
					print(this,"聊天服务器已经关闭");
					Log.Instance.v("聊天服务器已经关闭....");
					NoticeUtil.setOperatorNotice("聊天服务器已经关闭...");
					if(reTryTime>0){
						reTryTime--;
						setTimeout(socketConnect,reTryWaitTime);
					}
					break;
				case NetEvent.ON_ERROR_CODE:
					print(this,"聊天服务器已经关闭");
					Log.Instance.v("聊天服务器已经关闭....");
					NoticeUtil.setOperatorNotice("聊天服务器已经关闭...");
					if(reTryTime>0){
						reTryTime--;
						setTimeout(socketConnect,reTryWaitTime);
					}
					break;
			}
		}
		/**进行聊天服务器验证
		 */		
		private function initChatSocket():void
		{
			NetManager.chatSocket.sendBytes(ConfigManager.Instance.getChatTencentBytes());
			
			var chatLogin:CLoginReq=new CLoginReq();
			chatLogin.dyId=DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
			chatLogin.passport=DataCenter.Instance.passPort;
			NetManager.chatSocket.sendMessage(ChatCmd.CLoginReq,chatLogin);
		}
		private function onChatReply(sLoginRsp:SLoginRsp):void
		{
			ChatDataManager.pwd = sLoginRsp.password;
			switch(sLoginRsp.rsp)
			{
				case RspMsg.RSPMSG_SUCCESS:
					print(this,"聊天服务器验证成功，可以进行聊天啦...");
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatCheckOK);
					isConnnect=true;
					break;
				case RspMsg.RSPMSG_FAIL:
					print(this,"聊天服务器验证失败，聊天异常程序...");
					NoticeUtil.setOperatorNotice("聊天服务器验证失败，聊天异常...");
					NetManager.chatSocket.close();
					break;
			}
			
		}
		
	}
}