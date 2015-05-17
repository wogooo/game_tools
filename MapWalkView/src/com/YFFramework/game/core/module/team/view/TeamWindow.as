package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.view.player.SimplePlayer;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
		private var _players:Array;
		
		private var near_button:Button;
		private var req_button:Button;
		private var announce_button:Button;
		private var quit_button:Button;
		private var autoJoin_checkbox:CheckBox;
		
		public function TeamWindow(){
			_teamWindow = initByArgument(615,495,"teamPanel","组队") as MovieClip;
			AutoBuild.replaceAll(_teamWindow);
			near_button = Xdis.getChildAndAddClickEvent(onNear,_teamWindow,"near_button");
			req_button = Xdis.getChildAndAddClickEvent(onReq,_teamWindow,"req_button");
			announce_button = Xdis.getChildAndAddClickEvent(onAnnounce,_teamWindow,"announce_button");
			quit_button = Xdis.getChildAndAddClickEvent(onQuit,_teamWindow,"quit_button");
			autoJoin_checkbox = Xdis.getChild(_teamWindow,"autoJoin_checkBox");
			autoJoin_checkbox.addEventListener(Event.CHANGE,onAutoJoin);
			_reqWindow = new ReqWindow();
		}
		
		public function init():void{
			_nearWindow = new NearWindow();
			_players = new Array();
		}
	
		override public function dispose():void{
			_nearWindow = null;
			_players = null;
			for(var i:int=0;i<5;i++){
				if(_teamWindow["i"+i].numChildren>0){
					_teamWindow["i"+i].getChildAt(0).dispose();
					_teamWindow["i"+i].removeChildAt(0);
				}
			}
		}
		
		override public function close(event:Event=null):void{
			super.close(event);
			_nearWindow.close();
			dispose();
		}
		
		/**更新队员等级
		 */		
		public function updateLv():void{
			if(this.isOpen){
				var members:Array = TeamDyManager.Instance.getMembers();
				for(var i:int=0;i<members.length;i++){
					_teamWindow["t"+i].text = members[i].name + "(等级："+members[i].lv+")";
				}
			}
		}
		
		/**更新组队面板
		 */		
		public function updateMemberView():void{
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
				for(var i:int=0;i<members.length;i++){
					_teamWindow["t"+i].text = members[i].name + "(等级："+members[i].lv+")";
					_teamWindow["ot"+i].text = TypeRole.getCareerName(members[i].profession);
					
					var player:SimplePlayer = new SimplePlayer();
					if(members[i].clothId<0){
						player.initDefaultCloth(members[i].sex,members[i].profession);
					}else{
						player.updateClothId(members[i].clothId,members[i].sex);
					}
					player.updateWeaponId(members[i].weaponId,members[i].sex);
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
		
		/**打开发布面板 
		 * @param e MouseEvent.Click
		 */		
		private function onAnnounce(e:MouseEvent):void{
			NoticeUtil.setOperatorNotice("需要等待聊天系统建立完成。。。");
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
				var menu:Menu = new Menu();
				if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==TeamDyManager.LeaderId){
					//自己是队长
					if(clickDyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
						menu.addItem("退出队伍",onSelfQuitClick);
					}else{
						menu.addItem("私聊",onLeaderMemberClick);
						menu.addItem("窗口聊天",onLeaderMemberClick);
						menu.addItem("移交队长",onLeaderMemberClick,"",clickDyId);
						menu.addItem("请出队伍",onLeaderMemberClick,"",clickDyId);
						menu.addItem("加为好友",onLeaderMemberClick);
						menu.addItem("跟随",onLeaderMemberClick);
						menu.addItem("观察",onLeaderMemberClick);
					}
				}else{
					//自己不是队长
					if(e.currentTarget.getDyId()!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
						menu.addItem("私聊",onMemberClick);
						menu.addItem("窗口聊天",onMemberClick);
						menu.addItem("加为好友",onMemberClick);
						menu.addItem("跟随",onMemberClick);
						menu.addItem("观察",onMemberClick);
					}
				}
				menu.show();
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
		 * @param index	0.私聊；1.窗口聊天；2.移交队长；3.请出队伍；4.加为好友；5.跟随；6.观察
		 * @param label 对应上面的文字
		 * @param dyId	点击的队员的dyId
		 */		
		private function onLeaderMemberClick(index:uint,label:String,dyId:int=0):void{
			switch(index){
				case 0:
					break;
				case 1:
					break;
				case 2:
					if(TeamDyManager.Instance.getMemberDyVo(dyId).isOnline==false){
						NoticeUtil.setOperatorNotice("不能移交队长，队员已离线");
					}else{
						var msg_ctl:CChangeTeamLeader = new CChangeTeamLeader();
						msg_ctl.dyId = dyId;
						YFEventCenter.Instance.dispatchEventWith(TeamEvent.ChangeLeaderReq,msg_ctl);
					}
					break;
				case 3:
					var msg_ck:CKickTeamMember = new CKickTeamMember();
					msg_ck.dyId = dyId;
					YFEventCenter.Instance.dispatchEventWith(TeamEvent.KickMemberReq,msg_ck);
					break;
				case 4:
					break;
				case 5:
					break;
				case 6:
					break;
			}
		}
		
		/**队员点击其他人的下拉框 
		 * @param index	0.私聊；1.窗口聊天；2.加为好友；3.跟随；4.观察
		 * @param label 对应上面的文字
		 * @param dyId 点击的队员的dyId
		 */		
		private function onMemberClick(index:uint,label:String,dyId:int=0):void{
		}
		
		/**自动入队 
		 * @param e MouseEvent.Click
		 */		
		private function onAutoJoin(e:Event):void{
			if(autoJoin_checkbox.selected==true){
				TeamDyManager.isAutoJoin=true;
				for(var i:int=0;i<Math.min(5-TeamDyManager.Instance.getMembers().length,TeamDyManager.Instance.getReqList().length);i++){
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