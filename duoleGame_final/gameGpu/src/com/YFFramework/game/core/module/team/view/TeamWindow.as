package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.view.player.SimplePlayer;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.im.model.RequestFriendVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.model.MemberDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-3-28 下午4:43:51
	 * 
	 */
	public class TeamWindow extends Window{
		
		private var _teamWindow:MovieClip;
		private var _nearWindow:NearWindow;
		private var _reqWindow:ReqWindow;
		private var _menu:Menu;
		private var _lastTeamLen:int=1;
		
		private var near_button:Button;
		private var req_button:Button;
		private var announce_button:Button;
		private var quit_button:Button;
		private var autoJoin_checkbox:CheckBox;
		
		public function TeamWindow(){
			_teamWindow = initByArgument(655,505,"teamPanel",WindowTittleName.TeamTitle) as MovieClip;
			AutoBuild.replaceAll(_teamWindow);
			near_button = Xdis.getChildAndAddClickEvent(onNear,_teamWindow,"near_button");
			req_button = Xdis.getChildAndAddClickEvent(onReq,_teamWindow,"req_button");
			announce_button = Xdis.getChildAndAddClickEvent(onAnnounce,_teamWindow,"announce_button");
			quit_button = Xdis.getChildAndAddClickEvent(onQuit,_teamWindow,"quit_button");
			autoJoin_checkbox = Xdis.getChild(_teamWindow,"autoJoin_checkBox");
			autoJoin_checkbox.textField.width=80;
			autoJoin_checkbox.addEventListener(Event.CHANGE,onAutoJoin);
			_reqWindow = new ReqWindow();
			_nearWindow = new NearWindow();
			_menu=new Menu();
		}
		
		override public function dispose():void{
			for(var i:int=0;i<5;i++){
				if(_teamWindow["i"+i].numChildren>0){
					_teamWindow["i"+i].getChildAt(0).dispose();
					_teamWindow["i"+i].removeChildAt(0);
				}
			}
		}
		
		override public function close(event:Event=null):void{
			closeTo(UI.stage.stageWidth-95,UI.stage.stageHeight-45,0.02,0.04);
			if(_nearWindow)	_nearWindow.close();
			this.dispose();
		}
		
		/**更新队员等级
		 */		
		public function updateLv():void{
			if(this.isOpen){
				var members:Array = TeamDyManager.Instance.getMembers();
				var len:int=members.length;
				for(var i:int=0;i<len;i++){
					_teamWindow["t"+i].text = members[i].name + "(等级："+members[i].lv+")";
				}
			}
		}
		
		/**更新组队面板
		 */		
		public function updateMemberView(updateSelf:Boolean=true):void{
			if(this.isOpen){
				clearContent();

				if(TeamDyManager.LeaderId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId && TeamDyManager.Instance.getMembers().length<5){
					autoJoin_checkbox.enabled = true;
				}else{
					autoJoin_checkbox.enabled = false;
				}
				
				if(TeamDyManager.Instance.getMembers().length==5 || TeamDyManager.Instance.getMembers().length==1){
					autoJoin_checkbox.selected = false;
				}
				
				var members:Array = TeamDyManager.Instance.getMembers();
				var len:int=members.length;
				if(_lastTeamLen!=len){
					_menu.remove();
					_lastTeamLen=len;
				}
				for(var i:int=0;i<len;i++){
					if(updateSelf)	TeamDyManager.Instance.updateSelf();
					_teamWindow["t"+i].text = members[i].name + "(等级："+members[i].lv+")";
					_teamWindow["ot"+i].text = TypeRole.getCareerName(members[i].profession);
					
					var player:SimplePlayer = new SimplePlayer();
					if(members[i].clothId<0){
						player.initDefaultCloth(members[i].sex,members[i].profession);
					}else{
						player.updateClothId(members[i].clothId,members[i].sex,members[i].profession,members[i].clothEnhanceLv);
					}
					if(members[i].weaponId>0)	player.updateWeaponId(members[i].weaponId,members[i].sex,members[i].profession,members[i].weaponEnhanceLv);
					else	player.updateWeaponId(members[i].weaponId,members[i].sex,members[i].profession,-1);
					player.updateWingId(members[i].wingId,members[i].sex);
					player.setDyId(members[i].dyId);
					_teamWindow["i"+i].addChild(player);
					player.start();
					player.playDefault();
					player.addEventListener(MouseEvent.CLICK,onMenu);
					if(members[i].isOnline==false){
						player.filters=FilterConfig.dead_filter;
					}
				}
				if(members.length>1){
					_teamWindow.leaderImg.visible=true;
					quit_button.enabled = true;
				}else{
					_teamWindow.leaderImg.visible=false;
					quit_button.enabled = false;
				}
			}
		}
		
		/**更新请求面板 
		 */		
		public function updateReqWindow():void{
			if(_reqWindow.isOpen)	_reqWindow.updateList();
		}

		/**更新附近玩家
		 * @param players 附近玩家
		 */		
		public function updateNearPlayers(players:Array):void{
			_nearWindow.updateNearPlayers(players);
		}
		
		/**更新附近队伍 
		 * @param teams 附近队伍
		 */		
		public function updateNearTeams(teams:Array):void{
			_nearWindow.updateNearTeams(teams);
		}
		
		/**清除旧数据 
		 */		
		private function clearContent():void{
			for(var i:int=0;i<5;i++){
				_teamWindow["t"+i].text = "";
				_teamWindow["ot"+i].text = "";
				if(_teamWindow["i"+i].numChildren>0){
					_teamWindow["i"+i].getChildAt(0).dispose();
					_teamWindow["i"+i].removeChildAt(0);
				}
			}
		}
		
		/**打开附近面板 
		 * @param e MouseEvent.Click
		 */		
		private function onNear(e:MouseEvent):void{
			if(_nearWindow.isOpen){
				_nearWindow.close();
				UIManager.tweenToCenter(this);
			}else{
				_nearWindow.open();
				UIManager.centerMultiWindows(this,_nearWindow);
				this.switchToTop();
				YFEventCenter.Instance.dispatchEventWith(TeamEvent.NearPlayersReq);
				YFEventCenter.Instance.dispatchEventWith(TeamEvent.NearTeamsReq);
			}
		}
		
		/**打开请求面板 
		 * @param e MouseEvent.Click
		 */		
		private function onReq(e:MouseEvent):void{
			_reqWindow.switchOpenClose();
			_reqWindow.updateList();
		}
		
		public function openReqWindow():void
		{
			_reqWindow.open();
			_reqWindow.updateList();
		}
		
		/**打开发布面板 
		 * @param e MouseEvent.Click
		 */		
		private function onAnnounce(e:MouseEvent):void{
//			var chatInvite:ChatTeamInvite = new ChatTeamInvite();
//			chatInvite.open();
			ChatTeamInvite.Instance.switchOpenClose();
		}
		
		/**退出队伍 
		 * @param e MouseEvent.Click
		 */		
		private function onQuit(e:MouseEvent):void{
			YFEventCenter.Instance.dispatchEventWith(TeamEvent.LeaveReq);
		}
		
		/**打开下拉框
		 * @param e MouseEvent.Click
		 */		
		private function onMenu(e:MouseEvent):void{
			var clickDyId:int = e.currentTarget.getDyId();
			if(TeamDyManager.Instance.getMembers().length>1){
				_menu=new Menu();
				if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==TeamDyManager.LeaderId){
					//自己是队长
					if(clickDyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
						_menu.addItem("退出队伍",onSelfQuitClick);
					}else{
						_menu.addItem("私聊",onLeaderMemberClick,"",clickDyId);
						_menu.addItem("移交队长",onLeaderMemberClick,"",clickDyId);
						_menu.addItem("请出队伍",onLeaderMemberClick,"",clickDyId);
						_menu.addItem("加为好友",onLeaderMemberClick,"",clickDyId);
						_menu.addItem("观察",onLeaderMemberClick,"",clickDyId);
					}
				}else{
					//自己不是队长
					if(e.currentTarget.getDyId()!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
						_menu.addItem("私聊",onMemberClick,"",clickDyId);
						_menu.addItem("加为好友",onMemberClick,"",clickDyId);
						_menu.addItem("观察",onMemberClick,"",clickDyId);
					}
				}
				_menu.show();
			}
		}

		/**自己退出队伍 
		 * @param index
		 * @param label
		 */		
		private function onSelfQuitClick(index:uint,label:String):void{
			YFEventCenter.Instance.dispatchEventWith(TeamEvent.LeaveReq);
		}
		
		/**队长点击队员出现的下拉框 
		 * @param index	0.私聊；1.移交队长；2.请出队伍；3.加为好友；4.观察
		 * @param label 对应上面的文字
		 * @param dyId	点击的队员的dyId
		 */		
		private function onLeaderMemberClick(index:uint,label:String,dyId:int=0):void{
			switch(index){
				case 0:
					//YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatPrivateTalk,TeamDyManager.Instance.getMemberDyVo(dyId).name);
					var talkVo:PrivateTalkPlayerVo = new PrivateTalkPlayerVo();
					var memberVo:MemberDyVo = TeamDyManager.Instance.getMemberDyVo(dyId);
					talkVo.dyId = dyId;
					talkVo.name = memberVo.name;
					talkVo.sex = memberVo.sex;
					talkVo.career = memberVo.profession;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,talkVo);
					break;
				case 1:
					if(TeamDyManager.Instance.getMemberDyVo(dyId).isOnline==false){
						NoticeUtil.setOperatorNotice("不能移交队长，队员已离线");
					}else{
						var msg_ctl:CChangeTeamLeader = new CChangeTeamLeader();
						msg_ctl.dyId = dyId;
						YFEventCenter.Instance.dispatchEventWith(TeamEvent.ChangeLeaderReq,msg_ctl);
					}
					break;
				case 2:
					var msg_ck:CKickTeamMember = new CKickTeamMember();
					msg_ck.dyId = dyId;
					YFEventCenter.Instance.dispatchEventWith(TeamEvent.KickMemberReq,msg_ck);
					break;
				case 3:
					var reqFrdVo:RequestFriendVo = new RequestFriendVo();
					reqFrdVo.dyId = dyId;
					reqFrdVo.name = TeamDyManager.Instance.getMemberDyVo(dyId).name;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestAddFriend,reqFrdVo);
					break;
				case 4:
					ModuleManager.rankModule.otherPlayerReq(dyId);
					break;
			}
		}
		
		/**队员点击其他人的下拉框 
		 * @param index	0.私聊；1.加为好友；2.观察
		 * @param label 对应上面的文字
		 * @param dyId 点击的队员的dyId
		 */		
		private function onMemberClick(index:uint,label:String,dyId:int=0):void{
			switch(index){
				case 0:
					var talkVo:PrivateTalkPlayerVo = new PrivateTalkPlayerVo();
					var memberVo:MemberDyVo = TeamDyManager.Instance.getMemberDyVo(dyId);
					talkVo.dyId = dyId;
					talkVo.name = memberVo.name;
					talkVo.sex = memberVo.sex;
					talkVo.career = memberVo.profession;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,talkVo);
					break;
				case 1:
					var reqFrdVo:RequestFriendVo = new RequestFriendVo();
					reqFrdVo.dyId = dyId;
					reqFrdVo.name = TeamDyManager.Instance.getMemberDyVo(dyId).name;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestAddFriend,reqFrdVo);
					break;
				case 2:
					ModuleManager.rankModule.otherPlayerReq(dyId);
					break;
			}
		}
		
		/**自动入队 
		 * @param e MouseEvent.Click
		 */		
		private function onAutoJoin(e:Event):void{
			if(autoJoin_checkbox.selected==true){
				TeamDyManager.isAutoJoin=true;
				var len:int = Math.min(5-TeamDyManager.Instance.getMembers().length,TeamDyManager.Instance.getReqList().length);
				for(var i:int=0;i<len;i++){
					var msg:CApplyJoinTeam= new CApplyJoinTeam();
					msg.dyId = TeamDyManager.Instance.getReqList()[i].dyId;
					TeamDyManager.Instance.delFromReq(msg.dyId);
					YFEventCenter.Instance.dispatchEventWith(TeamEvent.AccJoinReq,msg);
				}
			}else{
				TeamDyManager.isAutoJoin=false;
			}
		}
	}
} 