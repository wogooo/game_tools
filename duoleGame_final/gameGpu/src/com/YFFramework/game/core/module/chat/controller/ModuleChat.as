package com.YFFramework.game.core.module.chat.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.chat.manager.ChatFilterManager;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatMsgVo;
	import com.YFFramework.game.core.module.chat.view.ChatSpeakerWindow;
	import com.YFFramework.game.core.module.chat.view.ChatView;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.TypeChannels;
	import com.chat_cmd.ChatCmd;
	import com.msg.chat.CSendChatMsg;
	import com.msg.chat.SForwardChatMsg;
	import com.msg.mapScene.CSendSpeakerMsg;
	import com.net.MsgPool;
	import com.net.NetManager;
	
	/**聊天系统模块
	 * @author flashk
	 */
	public class ModuleChat extends AbsModule{
		
		private static var _ins:ModuleChat;
		private var _chatView:ChatView;
		/**
		 * 聊天服务器当前是否已经连接上 
		 */
		private var _isServerConnected:Boolean = false;
		
		public function ModuleChat(){
			_ins = this;
			
			_chatView = new ChatView();
		}

		public static function get ins():ModuleChat{
			return _ins;
		}

		public function get isServerConnected():Boolean{
			return _isServerConnected;
		}

		/**更改离底部的距离设定 
		 * @param value
		 */
		public function changeLessY(value:int):void{
			_chatView.changeLessY( value );
		}
		
		/**模块初始化 
		 */
		override public function init():void{
			_chatView.init();
			ChatFilterManager.init();
			YFEventCenter.Instance.addEventListener(GlobalEvent.ChatCheckOK,onChatCheckOK);//聊天服务器验证成功，可以开始聊天
			YFEventCenter.Instance.addEventListener(GlobalEvent.ChatDisplay,onChatDisplay);//其他模块需要显示在聊天框的事件通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.ChatAutoSend,onAutoSend);//其他模块需要直接发送到世界频道的事件通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.OPEN_SPEAKER_PANEL,onSpeakerOpen);//打开大喇叭面板
			
			NetManager.chatSocket.addCallback(ChatCmd.SForwardChatMsg,SForwardChatMsg,onSForwardChatMsg );
		}
		
		/**小喇叭打开
		 * @param e
		 */		
		private function onSpeakerOpen(e:YFEvent):void{
			ChatSpeakerWindow.getInstance().openMe();
		}
		
		/**自动发送消息
		 * @param e
		 */		
		private function onAutoSend(e:YFEvent):void{
			sendMessage(TypeChannels.CHAT_CHANNEL_WORLD,String(e.param));
		}
		
		private function onChatDisplay(e:YFEvent):void{
			_chatView.chatDisplay(e.param as ChatData);
		}
		
		/**服务器返回新的聊天数据 
		 * @param data
		 */
		private function onSForwardChatMsg(data:SForwardChatMsg):void{
//			GlobalIDChache.setName(data.fromName, data.fromId);
			if(data.msg.indexOf("myQuality")==-1 && data.hasShowPos==false){
				var chatMsgVo:ChatMsgVo = new ChatMsgVo();
				chatMsgVo.dyId = data.fromId;
				chatMsgVo.msg = data.msg;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatToScene,chatMsgVo);
			}
			if(data.hasShowPos==false){
				_chatView.addNewForwardMessage(data);
			}else{
				switch(data.showPos){
					case NoticeType.Show_Area_Chat:
						_chatView.addNewMessageInAll(data.msg);
						break;
					case NoticeType.Show_Area_System:
						NoticeManager.systemNoticeManager.setOperatiorNotice(data.msg);
						break;
					case NoticeType.Show_Area_Roll:
						NoticeManager.bulletinBoardManager.setOperatiorNotice(data.msg);
						break;
				}
			}
		}
		
		/**接收到聊天服务器连接验证成功后的处理 
		 * @param event
		 */
		private function onChatCheckOK(event:YFEvent):void{
			_isServerConnected = true;
			_chatView.whenServerConnectOK();
		}
		
		/**发送频道数据 
		 * @param channel 频道
		 * @param message 聊天信息
		 * @param privateUserID 私聊的对象的用户ID
		 */
		public function sendMessage(channel:int,message:String,privateUserID:int=-1):void{
			if(_isServerConnected == false) return;
			var msg:CSendChatMsg = new CSendChatMsg();
			msg.channel = channel;
			msg.msg = message;
			if(privateUserID != -1)	msg.toId = privateUserID;
			NetManager.chatSocket.sendMessage(ChatCmd.CSendChatMsg,msg);
		}
		
		/**发送大喇叭（千里传音） 
		 * @param message 消息
		 */
		public function sendSpeaker(message:String):void{
			var msg:CSendSpeakerMsg = new CSendSpeakerMsg();
			msg.msg = message;
			MsgPool.sendGameMsg(GameCmd.CSendSpeakerMsg,msg);
		}
	}
}