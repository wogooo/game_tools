package com.YFFramework.game.core.module.im.controller
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.chat.model.ChatMsgVo;
	import com.YFFramework.game.core.module.gameView.view.EjectBtnView;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.manager.IMManager;
	import com.YFFramework.game.core.module.im.manager.RequestFriendManager;
	import com.YFFramework.game.core.module.im.model.IMDyVo;
	import com.YFFramework.game.core.module.im.model.PrivateTalkContentVo;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.im.model.RequestFriendVo;
	import com.YFFramework.game.core.module.im.view.FriendListWindow;
	import com.YFFramework.game.core.module.im.view.IMTalkWindow;
	import com.YFFramework.game.core.module.im.view.IMWindow;
	import com.YFFramework.game.core.module.notice.model.TypeChannels;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.chat_cmd.ChatCmd;
	import com.msg.chat.CAddBlackListReq;
	import com.msg.chat.CAddFriendReq;
	import com.msg.chat.CDelBlackListReq;
	import com.msg.chat.CDelEnemyReq;
	import com.msg.chat.CDelFriendReq;
	import com.msg.chat.CForwardAddFriendRsp;
	import com.msg.chat.CGetContactReq;
	import com.msg.chat.CSendChatMsg;
	import com.msg.chat.CSendFriendChatMsg;
	import com.msg.chat.Contact;
	import com.msg.chat.Relation;
	import com.msg.chat.Response;
	import com.msg.chat.SAddBlackListRsp;
	import com.msg.chat.SAddFriendRsp;
	import com.msg.chat.SContactInf;
	import com.msg.chat.SDelBlackListRsp;
	import com.msg.chat.SDelEnemyRsp;
	import com.msg.chat.SDelFriend;
	import com.msg.chat.SDelFriendRsp;
	import com.msg.chat.SForwardAddFriendReq;
	import com.msg.chat.SForwardAddFriendRsp;
	import com.msg.chat.SForwardChatMsg;
	import com.msg.chat.SForwardFriendChatMsg;
	import com.msg.chat.SGetContactRsp;
	import com.net.NetManager;

	/**好友 模块
	 */	
	public class ModuleIM extends AbsModule
	{
		private var _imWindow:IMWindow;
		/**请求好友列表面板
		 */		
		private var _friendListWindow:FriendListWindow;
		private var _isChatOk:Boolean=false;
		
		private var _isFirstRequest:Boolean;
		public function ModuleIM()
		{
			_belongScence=TypeScence.ScenceGameOn;
			_isFirstRequest=false;
			_imWindow = new IMWindow();
			_friendListWindow=new FriendListWindow();
		}
		override public function init():void
		{
			addEvents();
			addSocketCallBack();
		}
		
		private function addEvents():void
		{
			//请求联系人列表
			YFEventCenter.Instance.addEventListener(GlobalEvent.ChatCheckOK,requestContacts);	
			///请求添加好友
			YFEventCenter.Instance.addEventListener(GlobalEvent.C_RequestAddFriend,onSendSocket);
			// 同意添加好友
			YFEventCenter.Instance.addEventListener(IMEvent.C_AcceptAddFriend,onSendSocket);
			//弹出 请求好友列表面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.FriendBtnUIClick,onFriendBtnClick);
			//删除 好友 
			YFEventCenter.Instance.addEventListener(IMEvent.C_DeleteFriend,onSendSocket);
			//发送私聊消息   好友间的私聊
//			YFEventCenter.Instance.addEventListener(IMEvent.C_SendPrivateTalkWords,onSendSocket);
			//发送 私聊 全局接口
			YFEventCenter.Instance.addEventListener(GlobalEvent.C_PrivateTalk,onSendSocket);
			
			
			//  人物私聊 场景图标点击
			YFEventCenter.Instance.addEventListener(GlobalEvent.FriendPrivateChatIconClick,onSendSocket);
			//请求添加好友
			YFEventCenter.Instance.addEventListener(IMEvent.C_AddFriend,onSendSocket);
			//加入黑名单
			YFEventCenter.Instance.addEventListener(IMEvent.C_AddToBlackList,onSendSocket);
			//删除 黑名单 
			YFEventCenter.Instance.addEventListener(IMEvent.C_DeleteBlackList,onSendSocket);
			///删除敌人 
			YFEventCenter.Instance.addEventListener(IMEvent.C_AcceptAddFriend,onSendSocket);
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.FriendUIClick,onUIClick);
		}
		private function onUIClick(e:YFEvent):void
		{
			_imWindow.switchOpenClose();
		}
		/** 好友 点击 显示  添加好友的玩家
		 */		
		private function onFriendBtnClick(e:YFEvent):void
		{
			_friendListWindow.updateView();
			_friendListWindow.open();
		}
		private function addSocketCallBack():void
		{
			//请求好友列表
			NetManager.chatSocket.addCallback(ChatCmd.SGetContactRsp,SGetContactRsp,onConcatCallBack);
			///  联系人 列表===好友列表 仇人列表 黑名单列表返回
			NetManager.chatSocket.addCallback(ChatCmd.SContactInf,SContactInf,onContactInfo);
			//请求好友 返回 判断 请求好友列表的信息是否送达
			NetManager.chatSocket.addCallback(ChatCmd.SAddFriendRsp,SAddFriendRsp,onSAddFriendRsp);
			// 被邀请方 同意添加好友
			NetManager.chatSocket.addCallback(ChatCmd.SForwardAddFriendRsp,SForwardAddFriendRsp,onSForwardAddFriendRsp);
			//请求添加好友 到达被邀请方
			NetManager.chatSocket.addCallback(ChatCmd.SForwardAddFriendReq,SForwardAddFriendReq,onSForwardAddFriendReq);
			//  删除好友
			NetManager.chatSocket.addCallback(ChatCmd.SDelFriendRsp,SDelFriendRsp,onSDelFriendRsp);
			//删除好友返回给 被删除者
			NetManager.chatSocket.addCallback(ChatCmd.SDelFriend,SDelFriend,onSDelFriend);
			//私聊返回 给接受者
			NetManager.chatSocket.addCallback(ChatCmd.SForwardFriendChatMsg,SForwardFriendChatMsg,onSForwardFriendChatMsg);
			//加入黑名单返回
			NetManager.chatSocket.addCallback(ChatCmd.SAddBlackListRsp,SAddBlackListRsp,onSAddBlackListRsp);
			//删除黑名单返回
			NetManager.chatSocket.addCallback(ChatCmd.SDelBlackListRsp,SDelBlackListRsp,onSDelBlackListRsp);
			// 删除仇人
			NetManager.chatSocket.addCallback(ChatCmd.SDelEnemyRsp,SDelEnemyRsp,onSDelEnemyRsp);
			//私聊返回
			NetManager.chatSocket.addCallback(ChatCmd.SForwardChatMsg,SForwardChatMsg,onSForwardChatMsg);
		}
		/**私聊他 返回给接收者--- 陌生人 
		 */		
		private function onSForwardChatMsg(sForwardChatMsg:SForwardChatMsg):void
		{
			if(sForwardChatMsg.channel==TypeChannels.CHAT_CHANNEL_PRIVATE) //私聊
			{
				if(!SystemConfigManager.rejectTalk)   //不拒绝私聊
				{
					if(!IMManager.Instance.blackList.hasRole(sForwardChatMsg.fromId)) //不再黑名单中
					{
						var privateTalkPlayerVo:PrivateTalkPlayerVo=new PrivateTalkPlayerVo();
						privateTalkPlayerVo.dyId=sForwardChatMsg.fromId;
						privateTalkPlayerVo.name=sForwardChatMsg.fromName;
						privateTalkPlayerVo.sex=sForwardChatMsg.fromGender;
						//				privateTalkPlayerVo.vipLevel=sForwardChatMsg.from_vip_lv;
						var msg:String=sForwardChatMsg.msg;
						var talkWindow:IMTalkWindow=_imWindow.getTalkWindow2(privateTalkPlayerVo);
						talkWindow.appendText(msg,privateTalkPlayerVo.name);
						talkWindow.showSceneIcon();
						
						//显示 在场景上
//						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatToScene,chatMsgVo);
						chatToScene(privateTalkPlayerVo.dyId,msg);
					}
				}
			}
		}
		/** 私聊他 返回给接收者--- 好友 
		 */		
		private function onSForwardFriendChatMsg(sForwardFriendChatMsg:SForwardFriendChatMsg):void
		{
			if(!SystemConfigManager.rejectTalk)   //不拒绝私聊
			{
				var imDyVo:IMDyVo=IMManager.Instance.friendList.getRole(sForwardFriendChatMsg.fromId);
				var msg:String=sForwardFriendChatMsg.msg;
				var talkWindow:IMTalkWindow=_imWindow.getTalkWindow(imDyVo);
				talkWindow.appendText(msg,imDyVo.name);
				talkWindow.showSceneIcon();
				//			talkWindow.open();
				chatToScene(imDyVo.dyId,msg);
			}
		}
		/**发送到场景
		 */
		private function chatToScene(dyId:int,msg:String):void
		{
			var chatMsgVo:ChatMsgVo=new ChatMsgVo();
			chatMsgVo.dyId=dyId;
			chatMsgVo.msg=msg;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatToScene,chatMsgVo);
		}
		/**删除仇人
		 */		
		private function onSDelEnemyRsp(sDelEnemyRsp:SDelEnemyRsp):void
		{
			IMManager.Instance.EnemyList.removeRole(sDelEnemyRsp.targetId);
			_imWindow.updateEnemyList();
		}
		/**删除黑名单返回
		 */		
		private function onSDelBlackListRsp(sDelBlackListRsp:SDelBlackListRsp):void
		{
			IMManager.Instance.blackList.removeRole(sDelBlackListRsp.targetId);
			_imWindow.updateBlackList();
		}
		/** 假如黑名单 返回
		 */		
		private function onSAddBlackListRsp(sAddBlackListRsp:SAddBlackListRsp):void
		{
			print(this,"添加黑名单成功");
			NoticeUtil.setOperatorNotice("添加黑名单成功");
		}
		/**删除 好友
		 */		
		private function onSDelFriend(sDelFriend:SDelFriend):void
		{
			IMManager.Instance.friendList.removeRole(sDelFriend.friendId);
			_imWindow.updateFriendList();
		}
		/**删除好友后的回复
		 */		
		private function onSDelFriendRsp(sDelFriendRsp:SDelFriendRsp):void
		{
			switch(sDelFriendRsp.rsp)
			{
				case Response.RSPMSG_SUCCESS://删除好友成功
					IMManager.Instance.friendList.removeRole(sDelFriendRsp.friendId);
					_imWindow.updateFriendList();
					break;
				case Response.RSPMSG_FAIL://删除好友失败
					NoticeUtil.setOperatorNotice("删除好友失败");
					break;
			}
					
		}
		/** 请求添加好友
		 */		
		private function onSForwardAddFriendReq(sForwardAddFriendReq:SForwardAddFriendReq):void
		{
			if(!SystemConfigManager.rejectFriend)  //不 进行  拒绝添加好友
			{
				if(IMManager.Instance.friendList.hasRole(sForwardAddFriendReq.fromId)||IMManager.Instance.blackList.hasRole(sForwardAddFriendReq.fromId))
				{   ///不再自己的好友列表黑名单中中
					return ;
				}
				var requestFriendVo:RequestFriendVo=new RequestFriendVo();
				requestFriendVo.dyId=sForwardAddFriendReq.fromId;
				requestFriendVo.name=sForwardAddFriendReq.fromName;
				RequestFriendManager.Instance.addRole(requestFriendVo);
				if(_friendListWindow.isOpen)_friendListWindow.updateView();
				else 
				{
					///显示 好友  图标 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DisplayBtn,EjectBtnView.RequestFriend);			//显示弹出按钮
				}
			}
		}

		/** 被邀请者同意 接受好友请求  具体信息 在 SAddFriendRsp  协议里面
		 */		
		private function onSForwardAddFriendRsp(sForwardAddFriendRsp:SForwardAddFriendRsp):void
		{
			NoticeUtil.setOperatorNotice("成功添加好友"+sForwardAddFriendRsp.fromName);
		}
		/**请求好友 返回 判断 请求好友列表的信息是否送达
		 */		
		private function onSAddFriendRsp(sAddFriendRsp:SAddFriendRsp):void
		{
			switch(sAddFriendRsp.rsp)
			{
				case Response.RSPMSG_SUCCESS:  //添加 好友 成功到达 服务器
					NoticeUtil.setOperatorNotice("添加成功成功，等待回应");
					break;	
				case Response.RSPMSG_FAIL:  //添加 好友 失败
					NoticeUtil.setOperatorNotice("添加好友"+sAddFriendRsp.toName+"失败");
					break;	
				case Response.RSPMSG_OFFLINE:  // 对方离线
					NoticeUtil.setOperatorNotice(sAddFriendRsp.toName+"已经离线");
					break;	
				case Response.RSPMSG_YES:  //对方 同意添加 好友 ， 添加好友成功
					NoticeUtil.setOperatorNotice("成功添加好友"+sAddFriendRsp.toName);
					break;
				case Response.RSPMSG_NO: //拒绝
					NoticeUtil.setOperatorNotice(sAddFriendRsp.toName+"拒绝添加好友");
					break;			
			}
		}
		/**请求联系人列表
		 */		
		private function requestContacts(e:YFEvent):void
		{
			_isChatOk=true;
			_imWindow.updateHeroIM();
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,requestContacts);	
			//请求好友列表
			var cGetContactReq:CGetContactReq=new CGetContactReq();//请求好友列表返回
			NetManager.chatSocket.sendMessage(ChatCmd.CGetContactReq,cGetContactReq);
		}
		/**请求添加好友
		 */		
		private function onSendSocket(e:YFEvent):void
		{
			if(_isChatOk)
			{
				var imDyVo:IMDyVo;
				var privateTalkRequestVo:PrivateTalkPlayerVo;
				var dyId:int;
				switch(e.type)
				{
					case GlobalEvent.C_RequestAddFriend://请求添加好友
						var roleDyVo:RequestFriendVo=e.param as RequestFriendVo;
						if(IMManager.Instance.friendList.hasRoleByName(roleDyVo.name)) NoticeUtil.setOperatorNotice(roleDyVo.name+"已是你的好友");
						else if(IMManager.Instance.blackList.hasRoleByName(roleDyVo.name))NoticeUtil.setOperatorNotice(roleDyVo.name+"在黑名单中，请先删除黑名单在添加");
						else if(roleDyVo.name==DataCenter.Instance.roleSelfVo.roleDyVo.roleName)NoticeUtil.setOperatorNotice("不能添加自己为好友");
						else 
						{
							requestAddFriend(roleDyVo.name,roleDyVo.dyId); 
							NoticeUtil.setOperatorNotice("请求添加"+roleDyVo.name+"为好友");
						}
						break;
					case IMEvent.C_AddFriend: //请求添加好友
						privateTalkRequestVo=e.param as PrivateTalkPlayerVo;
						if(privateTalkRequestVo.name=="")NoticeUtil.setOperatorNotice("名字不能为空");
						else if(IMManager.Instance.friendList.hasRoleByName(privateTalkRequestVo.name)) NoticeUtil.setOperatorNotice(privateTalkRequestVo.name+"已是你的好友");
						else if(IMManager.Instance.blackList.hasRoleByName(privateTalkRequestVo.name))NoticeUtil.setOperatorNotice(privateTalkRequestVo.name+"在黑名单中，请先删除黑名单在添加");
						else if(privateTalkRequestVo.name==DataCenter.Instance.roleSelfVo.roleDyVo.roleName)NoticeUtil.setOperatorNotice("不能添加自己为好友");
						else 
						{
							requestAddFriend(privateTalkRequestVo.name,privateTalkRequestVo.dyId); 
							NoticeUtil.setOperatorNotice("请求添加"+privateTalkRequestVo.name+"为好友");
						}
						break;
					case IMEvent.C_AcceptAddFriend: //同意添加好友
						dyId=int(e.param);
						var cForwardAddFriendRsp:CForwardAddFriendRsp=new CForwardAddFriendRsp();
						cForwardAddFriendRsp.rsp=Response.RSPMSG_YES;
						cForwardAddFriendRsp.fromId=dyId;
						NetManager.chatSocket.sendMessage(ChatCmd.CForwardAddFriendRsp,cForwardAddFriendRsp);
						break;
//					case IMEvent.C_SendPrivateTalkWords: //发送私聊信息
//						var privateTalkVo:PrivateTalkContentVo=e.param as PrivateTalkContentVo;
//						var cSendFriendChatMsg:CSendFriendChatMsg=new CSendFriendChatMsg();
//						cSendFriendChatMsg.toId=privateTalkVo.toId;
//						cSendFriendChatMsg.msg=privateTalkVo.content;
//						NetManager.chatSocket.sendMessage(ChatCmd.CSendFriendChatMsg,cSendFriendChatMsg);
//						break;
					case GlobalEvent.C_PrivateTalk: //私聊
						var privateTalkVo:PrivateTalkContentVo=e.param as PrivateTalkContentVo;
//						var chatMsgVo:ChatMsgVo=new ChatMsgVo();
//						chatMsgVo.dyId=DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
//						chatMsgVo.msg=privateTalkVo.content;
						if(IMManager.Instance.friendList.hasRole(privateTalkVo.toId)) //如果为好友    好友间的私聊 
						{
							var cSendFriendChatMsg:CSendFriendChatMsg=new CSendFriendChatMsg();
							cSendFriendChatMsg.toId=privateTalkVo.toId;
							cSendFriendChatMsg.msg=privateTalkVo.content;
							NetManager.chatSocket.sendMessage(ChatCmd.CSendFriendChatMsg,cSendFriendChatMsg);
							//主角场景说话
//							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatToScene,chatMsgVo);
							chatToScene(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,privateTalkVo.content);
						}
						else if(IMManager.Instance.blackList.hasRole(privateTalkVo.toId)) //如果为 黑名单
						{
							NoticeUtil.setOperatorNotice("黑名单不能进行私聊");
						}
						else if(privateTalkVo.toId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) //如果为 黑名单
						{
							NoticeUtil.setOperatorNotice("不能与自己私聊");
						}
						else // 陌生人私聊
						{
							var sendChatMsg:CSendChatMsg=new CSendChatMsg();
							sendChatMsg.channel=TypeChannels.CHAT_CHANNEL_PRIVATE;
							sendChatMsg.toId=privateTalkVo.toId;
							sendChatMsg.msg=privateTalkVo.content;
							NetManager.chatSocket.sendMessage(ChatCmd.CSendChatMsg,sendChatMsg);
							//主角场景说话
//							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatToScene,chatMsgVo);
							chatToScene(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,privateTalkVo.content);
						}
						break;
					case IMEvent.C_DeleteFriend: //删除好友
						imDyVo=e.param as IMDyVo;
						var cDelFriendReq:CDelFriendReq=new CDelFriendReq(); 
						cDelFriendReq.friendId=imDyVo.dyId;
						NetManager.chatSocket.sendMessage(ChatCmd.CDelFriendReq,cDelFriendReq);
						break;
					case GlobalEvent.FriendPrivateChatIconClick: //好友私聊 图标单击
						privateTalkRequestVo=e.param as PrivateTalkPlayerVo;
						var talkWindow:IMTalkWindow=_imWindow.getTalkWindow2(privateTalkRequestVo);
						talkWindow.open();
						break;
					case IMEvent.C_AddToBlackList: //加入 黑名单
						dyId=int(e.param);
						if(!IMManager.Instance.blackList.hasRole(dyId))
						{
							///判断是否为好友 是好友 先删除好友
							var cAddBlackListReq:CAddBlackListReq=new CAddBlackListReq();
							cAddBlackListReq.targetId=dyId;
							NetManager.chatSocket.sendMessage(ChatCmd.CAddBlackListReq,cAddBlackListReq);
						}
						else 
						{
							NoticeUtil.setOperatorNotice("已经存在于黑名单中了");	
						}
						break;
					case IMEvent.C_DeleteBlackList: //删除 黑名单
						dyId=int(e.param);
						var cDelBlackListReq:CDelBlackListReq=new CDelBlackListReq();
						cDelBlackListReq.targetId=dyId;
						NetManager.chatSocket.sendMessage(ChatCmd.CDelBlackListReq,cDelBlackListReq);
						break;
					case IMEvent.C_AcceptAddFriend: // 删除仇人
						dyId=int(e.param);
						var cDelEnemyReq:CDelEnemyReq=new CDelEnemyReq();
						cDelEnemyReq.targetId=dyId;
						NetManager.chatSocket.sendMessage(ChatCmd.CDelEnemyReq,cDelEnemyReq);
						break;
				}
			}
			else NoticeUtil.setOperatorNotice("聊天服务器等待连接...");
		}
		/**请求添加好友
		 * name 要添加的玩家的名字
		 *     dyId  玩家 id  当为  -1  表示 不进行id 发送
		 */
		private function requestAddFriend(name:String,dyId:int=-1):void
		{
			var cAddFriendReq:CAddFriendReq=new CAddFriendReq();
			cAddFriendReq.toName=name;
			if(dyId>0)cAddFriendReq.toId=dyId;  // 如果  id  存在则发送id 
			NetManager.chatSocket.sendMessage(ChatCmd.CAddFriendReq,cAddFriendReq);
		}
		
		
		
		/**请求好友列表返回
		 */		
		private function onConcatCallBack(sGetContactRsp:SGetContactRsp):void
		{
			
			if(sGetContactRsp)
			{
				updateIMView(sGetContactRsp.contacts);
			}
			_isFirstRequest=true;
		}
		private function updateIMView(contacts:Array):void
		{
			var len:int=contacts.length;
			var contact:Contact;
			var imDyVo:IMDyVo; 
			//更新数据
			for(var i:int=0;i!=len;++i)
			{
				contact=contacts[i];
				imDyVo=new IMDyVo();
				imDyVo.dyId=contact.dyId;
				imDyVo.career=contact.career;
				imDyVo.level=contact.level;
				imDyVo.name=contact.name;
				imDyVo.sex=contact.gender;
				imDyVo.online=contact.online;
				imDyVo.guild=contact.guild;
				imDyVo.vipLevel=contact.vipLevel;
				imDyVo.vipType=contact.vipType;
				switch(contact.relation)
				{
					case Relation.RELATION_FRIEND: //好友列表
						IMManager.Instance.friendList.addRole(imDyVo);
						if(_isFirstRequest)
						{
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.AddFriendSuccess);
						}
						break;
					case Relation.RELATION_ENEMY: // 仇人 列表
						IMManager.Instance.EnemyList.addRole(imDyVo);
						break;
					case Relation.RELATION_BLACKLIST: // 黑名单列表
						IMManager.Instance.blackList.addRole(imDyVo);
						break;
				}
			}
			//更新 UI
			_imWindow.updateView();
		}
		
		/**联系人列表返回
		 *   该条消息   永远是追加    新增加的 好友 也就走这条信息  直接追加
		 */		
		private function onContactInfo(sContactInf:SContactInf):void
		{
			updateIMView(sContactInf.contacts);
//			var len:int=sContactInf.contacts.length;
//			var contact:Contact;
//			var imDyVo:IMDyVo; 
//			//更新数据
//			for(var i:int=0;i!=len;++i)
//			{
//				contact=sContactInf.contacts[i];
//				imDyVo=new IMDyVo();
//				imDyVo.dyId=contact.dyId;
//				imDyVo.career=contact.career;
//				imDyVo.level=contact.level;
//				imDyVo.name=contact.name;
//				imDyVo.sex=contact.sex;
//				imDyVo.online=contact.online;
//				imDyVo.guild=contact.guild;
//				switch(contact.relation)
//				{
//					case Relation.RELATION_FRIEND: //好友列表
//						IMManager.Instance.friendList.addRole(imDyVo);
//						break;
//					case Relation.RELATION_ENEMY: // 仇人 列表
//						IMManager.Instance.EnemyList.addRole(imDyVo);
//						break;
//					case Relation.RELATION_BLACKLIST: // 黑名单列表
//						IMManager.Instance.blackList.addRole(imDyVo);
//						break;
//				}
//			}
//			//更新 UI
//			_imWindow.updateView();
		}
		
		
		override public function dispose():void
		{
			
		}
	}
}