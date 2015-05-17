package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.model.InviteDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.CApplyTeamInvite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-12 上午11:20:07
	 * 组队邀请框 - 只有一个邀请时出现
	 */
	public class InviteAlert extends Window{
		
		private var _mc:MovieClip;
		private var yes_button:Button;
		private var no_button:Button;
		private var view_button:Button;
		private var _dyId:int;
		
		public function InviteAlert(){
			_mc = initByArgument(300,160,"inviteAlert","邀请") as MovieClip;
			
			AutoBuild.replaceAll(_mc);
			yes_button = Xdis.getChildAndAddClickEvent(onYes,_mc,"yes_button");
			no_button = Xdis.getChildAndAddClickEvent(onNo,_mc,"no_button");
			view_button = Xdis.getChildAndAddClickEvent(onView,_mc,"view_button");
			view_button.textField.text = "查看信息";
			view_button.textField.textColor = TypeProps.C5ec700;
			var format:TextFormat = new TextFormat();
			format.underline = true;
			view_button.textField.setTextFormat(format);
		}
		
		override public function update():void{
			var inviteDyVo:InviteDyVo = TeamDyManager.Instance.getInviteList()[0];
			_mc.nameTxt.htmlText = HTMLFormat.color(inviteDyVo.name,TypeProps.C5ec700) + HTMLFormat.color("（等级"+inviteDyVo.lv+")",TypeProps.Cf0f275);
			_dyId = inviteDyVo.dyId;
			TeamDyManager.Instance.emptyInviteList();
			
		}
		
		private function onYes(e:MouseEvent):void{
			if(TeamDyManager.Instance.getMembers().length>1){
				NoticeUtil.setOperatorNotice("你已组队，无法加入。");
			}else if(TeamDyManager.Instance.containsMember(_dyId)){
				NoticeUtil.setOperatorNotice("队伍已有该成员");
			}else{
				var msg:CApplyTeamInvite = new CApplyTeamInvite();
				msg.dyId = _dyId;
				YFEventCenter.Instance.dispatchEventWith(TeamEvent.AccInviteReq,msg);
			}
			this.close();
		}
		
		private function onNo(e:MouseEvent):void{
			this.close();
		}
		
		private function onView(e:MouseEvent):void{
			NoticeUtil.setOperatorNotice("等待策划设定。。。");
		}
	}
} 