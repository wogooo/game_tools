package com.YFFramework.game.core.module.team.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.gameView.view.EjectBtnView;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.view.InviteAlert;
	import com.YFFramework.game.core.module.team.view.InviteWindow;
	import com.YFFramework.game.core.module.team.view.TeamWindow;
	import com.msg.hero.SChangeCareer;
	import com.msg.mapScene.SHeroEquipChange;
	import com.msg.team_pro.*;
	import com.net.MsgPool;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-28 下午4:28:25
	 */
	public class TeamModule extends AbsModule{
		
		private var _teamWindow:TeamWindow;
		private var _inviteWindow:InviteWindow;
		
		public function TeamModule(){
			_teamWindow = new TeamWindow();
			_inviteWindow = new InviteWindow();

		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);					//进入游戏   请求队伍状态
			YFEventCenter.Instance.addEventListener(GlobalEvent.TeamUIClick,onTeamUIClick);			//键盘T 打开组队面板
			YFEventCenter.Instance.addEventListener(TeamEvent.NearPlayersReq,nearPlayerReq);		//附近玩家请求
			YFEventCenter.Instance.addEventListener(TeamEvent.NearTeamsReq,nearTeamReq);			//附近队伍请求
			YFEventCenter.Instance.addEventListener(TeamEvent.InviteReq,inviteReq);					//邀请玩家入队请求
			YFEventCenter.Instance.addEventListener(TeamEvent.AccInviteReq,accInviteReq);			//接受邀请请求
			YFEventCenter.Instance.addEventListener(TeamEvent.LeaveReq,leaveReq);					//退出队伍请求
			YFEventCenter.Instance.addEventListener(TeamEvent.JoinReq,joinReq);						//加入队伍请求
			YFEventCenter.Instance.addEventListener(TeamEvent.AccJoinReq,accJoinReq);				//同意入队请求
			YFEventCenter.Instance.addEventListener(TeamEvent.KickMemberReq,kickMemberReq);			//剔除队员请求
			YFEventCenter.Instance.addEventListener(TeamEvent.ChangeLeaderReq,changeLeaderReq);		//换队长请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.InviteUIClick,onInviteUIClick);		//打开邀请面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.JoinTeamOpen,onJoinTeamOpen);       //打开申请加入队伍者列表
		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.SOnlineTeamInfo,SOnlineTeamInfo,onOnlineTeamResp);			//登陆队伍状态回复
			MsgPool.addCallBack(GameCmd.SNearPlayerTeamInfo,SNearPlayerTeamInfo,onNearPlayerResp);	//附近玩家回复
			MsgPool.addCallBack(GameCmd.SNearTeams,SNearTeams,onNearTeamResp);						//附近队伍回复
			MsgPool.addCallBack(GameCmd.STeamInviteNotify,STeamInviteNotify,onInviteResp);			//有人邀请玩家入队（推送）
			MsgPool.addCallBack(GameCmd.SEnterTeam,SEnterTeam,onEnterResp);							//新入队回复
			MsgPool.addCallBack(GameCmd.SEnterTeamNotify,SEnterTeamNotify,onOtherEnterResp);		//新成员入队回复
			MsgPool.addCallBack(GameCmd.SLeaveTeam,SLeaveTeam,onLeaveResp);							//退队回复
			MsgPool.addCallBack(GameCmd.SJoinTeamNotify,SJoinTeamNotify,onJoinResp);				//有人申请加入玩家创建的队伍（推送）
			MsgPool.addCallBack(GameCmd.SApplyJoinTeam,SApplyJoinTeam,onAccJoinResp);				//同意入队错误消息回复
			MsgPool.addCallBack(GameCmd.SChangeTeamLeader,SChangeTeamLeader,onChgLeaderResp);		//换队长回复
			MsgPool.addCallBack(GameCmd.SMemberOffline,SMemberOffline,onMemberOfflineResp);			//队员离线回复
			MsgPool.addCallBack(GameCmd.SMemberOnline,SMemberOnline,onMemberOnlineResp);			//队员上线回复
			MsgPool.addCallBack(GameCmd.SPlayerLvChgNotify,SPlayerLvChgNotify,onLvChgResp);			//队员等级改变回复
			MsgPool.addCallBack(GameCmd.SMemberChangeEquip,SMemberChangeEquip,onEquipChgResp);		//队员装备改变回复
			MsgPool.addCallBack(GameCmd.SHeroEquipChange,SHeroEquipChange,onEquipChgResp);			//自己装备改变回复
			MsgPool.addCallBack(GameCmd.SChangeCareer,SChangeCareer,onChgCareerResp);				//换职回复
			MsgPool.addCallBack(GameCmd.SJoinTeamResp,SJoinTeamResp,onJoinTeamResp);				//申请入队回复
		}
		
		private function onJoinTeamOpen(e:YFEvent):void
		{
			_teamWindow.openReqWindow();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RemoveEjectBtn,EjectBtnView.JoinTeamList);
		}
		
		/**申请入队回复
		 * @param e 
		 */		
		private function onJoinTeamResp(msg:SJoinTeamResp):void{
			if(msg.errorInfo == TypeProps.RSPMSG_TEAM_MEMBER_FULL){
				NoticeManager.setNotice(NoticeType.Notice_id_1403);
				//NoticeUtil.setOperatorNotice("队伍已满!");
			}else{
				//NoticeUtil.setOperatorNotice("已申请入队!");
				NoticeManager.setNotice(NoticeType.Notice_id_1406);
			}
		}
		
		/**职业改变回复 
		 * @param msg 收到的协议
		 */		
		private function onChgCareerResp(msg:SChangeCareer):void{
			TeamDyManager.Instance.getMemberDyVo(DataCenter.Instance.roleSelfVo.roleDyVo.dyId).profession=msg.career;
			_teamWindow.updateMemberView();
		}
		
		/**队员装备改变回复 
		 * @param msg 收到的协议
		 */		
		private function onEquipChgResp(msg:*):void{
			if(TeamDyManager.Instance.containsMember(msg.dyId)){
				switch(msg.partType){
					case TypeProps.EQUIP_TYPE_CLOTHES:
						TeamDyManager.Instance.getMemberDyVo(msg.dyId).clothId = msg.equipId;
						TeamDyManager.Instance.getMemberDyVo(msg.dyId).clothEnhanceLv = msg.equipEnhanceLevel;
						break;
					case TypeProps.EQUIP_TYPE_WEAPON:
						TeamDyManager.Instance.getMemberDyVo(msg.dyId).weaponId = msg.equipId;
						TeamDyManager.Instance.getMemberDyVo(msg.dyId).weaponEnhanceLv = msg.equipEnhanceLevel;
						break;
					case TypeProps.EQUIP_TYPE_WINGS:
						TeamDyManager.Instance.getMemberDyVo(msg.dyId).wingId = msg.equipId;
						break;
				}
				_teamWindow.updateMemberView(false);
			}
		}
		
		/**队员等级改变回复
		 * @param msg 收到的协议
		 */		
		private function onLvChgResp(msg:SPlayerLvChgNotify):void{
			TeamDyManager.Instance.getMemberDyVo(msg.dyId).lv = msg.level;
			_teamWindow.updateLv();
		}
		
		/**队员下线回复
		 * @param msg 收到的协议
		 */	
		private function onMemberOfflineResp(msg:SMemberOffline):void{
			TeamDyManager.Instance.getMemberDyVo(msg.dyId).isOnline = false;
			_teamWindow.updateMemberView();
		}
		
		/**队员上线回复
		 * @param msg 收到的协议
		 */	
		private function onMemberOnlineResp(msg:SMemberOnline):void{
			TeamDyManager.Instance.getMemberDyVo(msg.dyId).isOnline = true;
			_teamWindow.updateMemberView();
		} 
		
		/**换队长回复
		 * @param msg 收到的协议
		 */	
		private function onChgLeaderResp(msg:SChangeTeamLeader):void{
			TeamDyManager.Instance.switchLeader(msg.dyId);
			_teamWindow.updateMemberView();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SwitchTeamIcons);
		}
		
		/**入队回复
		 * @param msg 收到的协议
		 */	
		private function onJoinResp(msg:SJoinTeamNotify):void{
			TeamDyManager.Instance.addToReq(msg.joinRequester.dyId,msg.joinRequester.power,msg.joinRequester.name,msg.joinRequester.level);
			if(TeamDyManager.isAutoJoin==true && TeamDyManager.Instance.getMembers().length<5){
				var new_msg:CApplyJoinTeam = new CApplyJoinTeam();
				new_msg.dyId = msg.joinRequester.dyId;
				YFEventCenter.Instance.dispatchEventWith(TeamEvent.AccJoinReq,new_msg);
			}else{
				_teamWindow.updateReqWindow();
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DisplayBtn,EjectBtnView.JoinTeamList);
		}
		
		/**同意入队回复
		 * @param msg 收到的协议
		 */	
		private function onAccJoinResp(msg:SApplyJoinTeam):void{
			if(msg.errorInfo==TypeProps.RSPMSG_TEAM_JOIN_OTHER){
				//NoticeUtil.setOperatorNotice("该玩家已加入队伍");
				NoticeManager.setNotice(NoticeType.Notice_id_1401);
			}else if(msg.errorInfo==TypeProps.RSPMSG_TEAM_OFFLINE){
				//NoticeUtil.setOperatorNotice("该玩家已离线");
				NoticeManager.setNotice(NoticeType.Notice_id_1407);
			}
		}
		
		/**离队回复
		 * @param msg 收到的协议
		 */	
		private function onLeaveResp(msg:SLeaveTeam):void{
			var arr:Array;
			if(msg.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
				if(TeamDyManager.Instance.getMembers().length!=1){
					if(msg.reason==TypeProps.REASON_SELF_LEAVE){
						//NoticeUtil.setOperatorNotice("你退出队伍");
						NoticeManager.setNotice(NoticeType.Notice_id_1404,-1,DataCenter.Instance.roleSelfVo.roleDyVo.roleName);
					}else{
						//NoticeUtil.setOperatorNotice("你被请出队伍");
						NoticeManager.setNotice(NoticeType.Notice_id_1404,-1,DataCenter.Instance.roleSelfVo.roleDyVo.roleName);
					}
					arr=new Array();
					var members:Array = TeamDyManager.Instance.getMembers();
					for(var i:int=0;i<members.length;i++){
						if(members[i].dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
							arr.push(members[i].dyId);
						}
					}
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TeamRemoveMember,arr);
					TeamDyManager.Instance.emptyMembers();
					TeamDyManager.Instance.addSelf();
				}
				TeamDyManager.LeaderId=0;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RemoveAllTeamIcons);
			}else{
				if(TeamDyManager.Instance.getMemberDyVo(msg.dyId)){
					if(msg.reason==TypeProps.REASON_SELF_LEAVE){
						//NoticeUtil.setOperatorNotice(TeamDyManager.Instance.getMemberDyVo(msg.dyId).name+"退出队伍");
						NoticeManager.setNotice(NoticeType.Notice_id_1404,-1,TeamDyManager.Instance.getMemberDyVo(msg.dyId).name);
					}else if(msg.reason==TypeProps.REASON_KICK){
						//NoticeUtil.setOperatorNotice(TeamDyManager.Instance.getMemberDyVo(msg.dyId).name+"被踢出队伍");
						NoticeManager.setNotice(NoticeType.Notice_id_1404,-1,TeamDyManager.Instance.getMemberDyVo(msg.dyId).name);
					}else{
						//NoticeUtil.setOperatorNotice(TeamDyManager.Instance.getMemberDyVo(msg.dyId).name+"离线过久退出队伍");
						NoticeManager.setNotice(NoticeType.Notice_id_1404,-1,TeamDyManager.Instance.getMemberDyVo(msg.dyId).name);
					}
					TeamDyManager.Instance.removeMember(msg.dyId);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RemoveTeamIcons,msg.dyId);
					arr=new Array();
					arr.push(msg.dyId);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TeamRemoveMember,arr);
				}
			}
			_teamWindow.updateMemberView();
		}
		
		/**新玩家进队回复
		 * @param msg 收到的协议
		 */
		private function onOtherEnterResp(msg:SEnterTeamNotify):void{
			TeamDyManager.Instance.addMember(msg.newMember);
			//NoticeUtil.setOperatorNotice(msg.newMember.name+"加入队伍");
			NoticeManager.setNotice(NoticeType.Notice_id_1402,-1,msg.newMember.name);
			_teamWindow.updateMemberView();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.AddTeamIcons,msg.newMember.dyId);
			var arr:Array=new Array();
			arr.push(msg.newMember.dyId);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TeamAddMember,arr);
		}
		
		/**登陆回复，获得组队队员信息
		 * @param msg 收到的协议
		 */	
		private function onOnlineTeamResp(msg:SOnlineTeamInfo):void{
			TeamDyManager.LeaderId = msg.leaderId;
			var len:int=msg.members.length;
			if(len!=0){
				for(var i:int=0;i<len;i++){
					TeamDyManager.Instance.addMember(msg.members[i]);
				}
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.InitTeamIcons);
			}else{
				TeamDyManager.Instance.addSelf();
			}
		}
		
		/**进入队伍回复，获取其他队员信息
		 * @param msg 收到的协议
		 */	
		private function onEnterResp(msg:SEnterTeam):void{
			if(msg.errorInfo==0){
				TeamDyManager.LeaderId = msg.leaderId;
				if(msg.leaderId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
					//NoticeUtil.setOperatorNotice("你加入队伍");
					NoticeManager.setNotice(NoticeType.Notice_id_1402,-1,DataCenter.Instance.roleSelfVo.roleDyVo.roleName);
					TeamDyManager.Instance.emptyMembers();
					var arr:Array=new Array();
					var len:int=msg.members.length;
					for(var i:int=0;i<len;i++){
						TeamDyManager.Instance.addMember(msg.members[i]);
						if(msg.members[i].dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
							arr.push(msg.members[i].dyId);
						}
					}
					_teamWindow.updateMemberView();
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.InitTeamIcons);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TeamAddMember,arr);
				}
			}else if(msg.errorInfo==TypeProps.RSPMSG_TEAM_LEADER_LEAVE){
				//NoticeUtil.setOperatorNotice("邀请的队长不在");
				NoticeManager.setNotice(NoticeType.Notice_id_1408);
			}else if(msg.errorInfo==TypeProps.RSPMSG_TEAM_NOT_EXIST){
			//	NoticeUtil.setOperatorNotice("邀请的队伍已经不存在");
				NoticeManager.setNotice(NoticeType.Notice_id_1409);
			}else if(msg.errorInfo==TypeProps.RSPMSG_TEAM_MEMBER_FULL){
				//NoticeUtil.setOperatorNotice("邀请的队伍已满");
				NoticeManager.setNotice(NoticeType.Notice_id_1403);
			}
		}
		
		/**附近玩家回复
		 * @param msg 收到的协议
		 */	
		private function onNearPlayerResp(msg:SNearPlayerTeamInfo):void{
			if(msg)	_teamWindow.updateNearPlayers(msg.nearPassers);
			else	_teamWindow.updateNearPlayers(null);
		}
		
		/**附近队伍回复
		 * @param msg 收到的协议
		 */	
		private function onNearTeamResp(msg:SNearTeams):void{
			if(msg)	_teamWindow.updateNearTeams(msg.nearLeaders);
			else	_teamWindow.updateNearTeams(null);
		}
		
		/**邀请组队回复
		 * @param msg 收到的协议
		 */		
		private function onInviteResp(msg:STeamInviteNotify):void{
			if(SystemConfigManager.rejectTeam==false){
				TeamDyManager.Instance.addToInvite(msg.invitorInfo.dyId,msg.invitorInfo.power,msg.invitorInfo.name,msg.invitorInfo.level);
				if(_inviteWindow.isOpen)	_inviteWindow.updateList();
				else	YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DisplayBtn,EjectBtnView.RequestTeam);
			}
		}
		
		/**打开邀请面板
		 * @param e 收到的打开邀请面板事件通知
		 */
		private function onInviteUIClick(e:YFEvent):void{
			if(TeamDyManager.Instance.getInviteList().length==1){
				var inviteAlert:InviteAlert = new InviteAlert();
				inviteAlert.open();
				inviteAlert.update();
			}else{
				_inviteWindow.switchOpenClose();
				_inviteWindow.updateList();
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RemoveEjectBtn,EjectBtnView.RequestTeam);
		}

		/**打开组队面板
		 * @param e 收到的打开组队面板事件通知
		 */		
		private function onTeamUIClick(e:YFEvent):void{
			_teamWindow.switchOpenClose();
			if(_teamWindow.isOpen)	_teamWindow.updateMemberView();
		}
		
		/**换队长申请 
		 * @param e 收到的换队长申请事件通知
		 */
		private function changeLeaderReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CChangeTeamLeader,(e.param) as CChangeTeamLeader);
		}
		
		/**踢玩家申请 
		 * @param e 收到的踢玩家申请事件通知
		 */
		private function kickMemberReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CKickTeamMember,(e.param) as CKickTeamMember);
		}
		
		/**入队申请 
		 * @param e 收到的入队申请事件通知
		 */
		private function joinReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CJoinTeam,(e.param) as CJoinTeam);
		}
		
		/**同意入队申请 
		 * @param e 收到的同意入队申请事件通知
		 */		
		private function accJoinReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CApplyJoinTeam,(e.param) as CApplyJoinTeam);
		}
		
		/**离开队申请 
		 * @param e 收到的离开队申请事件通知
		 */	
		private function leaveReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CLeaveTeam,new CLeaveTeam());
		}
		
		/**附近玩家申请 
		 * @param e 收到的附近玩家申请事件通知
		 */	
		private function nearPlayerReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CQueryNearPlayers,new CQueryNearPlayers());
		}
		
		/**附近队伍申请 
		 * @param e 收到的附近队伍申请事件通知
		 */	
		private function nearTeamReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CQueryNearTeams,new CQueryNearTeams());
		}
		
		/**邀请玩家入队申请 
		 * @param e 收到的邀请玩家入队申请事件通知
		 */	
		private function inviteReq(e:YFEvent):void{
			var roleDyVo:RoleDyVo = e.param as RoleDyVo;
			if(TeamDyManager.Instance.containsMember(roleDyVo.dyId)){
				//NoticeUtil.setOperatorNotice("["+roleDyVo.roleName+"]已在你的队伍里");
				NoticeManager.setNotice(NoticeType.Notice_id_1410,-1,roleDyVo.roleName);
			}else{
				var msg:CTeamInviteOther = new CTeamInviteOther();
				msg.dyId = roleDyVo.dyId;
				MsgPool.sendGameMsg(GameCmd.CTeamInviteOther,msg);
				//NoticeUtil.setOperatorNotice("已邀请["+roleDyVo.roleName+"]组队，等待对方回应。");
				NoticeManager.setNotice(NoticeType.Notice_id_1411,-1,roleDyVo.roleName);
			}
		}
		
		/**同意邀请入队申请 
		 * @param e 收到的同意邀请入队申请事件通知
		 */	
		private function accInviteReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CApplyTeamInvite,(e.param) as CApplyTeamInvite);
		}
		
		/**登陆时候获取申请
		 * @param e 收到的登陆时候获取申请事件通知
		 */	
		private function onGameIn(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.COnlineTeamInfo,new COnlineTeamInfo());
		}
	}
} 