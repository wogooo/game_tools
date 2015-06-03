package com.YFFramework.game.core.module.notice.manager
{
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.chat.manager.ChatDataManager;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.chat.view.ChatView;
	import com.YFFramework.game.core.module.notice.model.NoticeBasicVo;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.TypeChannels;
	import com.YFFramework.game.core.module.notice.view.BulletinBoardManager;
	import com.YFFramework.game.core.module.notice.view.NormalNoticeManager;
	import com.YFFramework.game.core.module.notice.view.PopupNoticeManager;
	import com.YFFramework.game.core.module.notice.view.SystemNoticeManager;
	import com.adobe.crypto.MD5;
	import com.chat_cmd.ChatCmd;
	import com.msg.chat.CSendChatMsg;
	import com.net.NetManager;

	/**
	 * @version 1.0.0
	 * creation time：2013-8-17 下午5:18:52
	 */
	public class NoticeManager{
		
		private static var popupNoticeManager:PopupNoticeManager = new PopupNoticeManager();
		public static var systemNoticeManager:SystemNoticeManager = new SystemNoticeManager();
		public static var bulletinBoardManager:BulletinBoardManager = new BulletinBoardManager();
		private static var normalNoticeManager:NormalNoticeManager = new NormalNoticeManager();
		
		public function NoticeManager(){
		}
		
		/**根据notice表弹出对应的消息
		 * @param noticeId		写死的noticeId,定义在NoticeType里面
		 * @param channel		该消息通过什么频道发送；定义在Channels类里面；默认为-1，本地消息
		 * @param args			需要替换的参数
		 */		
		public static function setNotice(noticeId:int, channel:int=-1, ... args):void{
			var bvo:NoticeBasicVo = NoticeBasicManager.Instance.getNoticeBasicVo(noticeId);
			var len:int = args.length;
			var index:int=1;
			var tempStr:String = bvo.noticeContent;
			for(var i:int=0;i<len;i++){
				tempStr = tempStr.replace("&"+index,args[i]);
				index++;
			}
			var strArr:Array = tempStr.split(/\{|\}/g);
			var finalStr:String="";
			len = strArr.length;
			for(i=0;i<len;i++){
				if(strArr[i].indexOf("|")==-1){
					finalStr+=HTMLUtil.createHtmlText(strArr[i],bvo.fontSize,bvo.defaultColor.substr(1,bvo.defaultColor.length));
				}else{
					var tempArr:Array = strArr[i].split("|#");
					finalStr+=HTMLUtil.createHtmlText(tempArr[0],bvo.fontSize,tempArr[1]);
				}
			}
			var msg:CSendChatMsg;
			switch(bvo.showArea){
				case NoticeType.Show_Area_Chat:
					if(channel!=TypeChannels.CHAT_CHANNEL_GUILD_NATIVE && bvo.isPublic==1){
						msg = new CSendChatMsg();
						msg.msg = "【系统】"+finalStr;
						msg.channel = channel;
						msg.showPos = bvo.showArea;
						if(channel == TypeChannels.CHAT_CHANNEL_SYSTEM)
							msg.verify = MD5.hash("【系统】"+finalStr+ChatDataManager.pwd.toUpperCase()+"SYS");
						NetManager.chatSocket.sendMessage(ChatCmd.CSendChatMsg,msg);
					}else if(channel==TypeChannels.CHAT_CHANNEL_GUILD_NATIVE){
						ChatView.Instance.addGuildMsg(finalStr);
					}else{
						ChatView.Instance.addNewMessageInAll("【系统】"+finalStr);
					}
					break;
				case NoticeType.Show_Area_NormalTip:
					normalNoticeManager.setOperatiorNotice(finalStr);
					break;
				case NoticeType.Show_Area_Popup:
					popupNoticeManager.setOperatiorNotice(finalStr);
					break;
				case NoticeType.Show_Area_Roll:
					if(channel!=-1){
						msg = new CSendChatMsg();
						msg.msg = finalStr;
						msg.channel = channel;
						msg.showPos = bvo.showArea;
						if(channel == TypeChannels.CHAT_CHANNEL_SYSTEM){
							msg.verify = MD5.hash(finalStr+ChatDataManager.pwd.toUpperCase()+"SYS");
						}
						NetManager.chatSocket.sendMessage(ChatCmd.CSendChatMsg,msg);
					}else{
						bulletinBoardManager.setOperatiorNotice(finalStr);
					}
					break;
				case NoticeType.Show_Area_System:
					if(channel!=-1){
						msg = new CSendChatMsg();
						msg.msg = finalStr;
						msg.channel = channel;
						msg.showPos = bvo.showArea;
						if(channel == TypeChannels.CHAT_CHANNEL_SYSTEM){
							msg.verify = MD5.hash(finalStr+ChatDataManager.pwd.toUpperCase()+"SYS");
						}
						NetManager.chatSocket.sendMessage(ChatCmd.CSendChatMsg,msg);
					}else{
						systemNoticeManager.setOperatiorNotice(finalStr);
					}
					break;
			}
		}
	}
}