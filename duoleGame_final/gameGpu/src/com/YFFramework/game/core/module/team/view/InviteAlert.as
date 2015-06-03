package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.model.InviteDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.CApplyTeamInvite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-12 上午11:20:07
	 * 组队邀请框 - 只有一个邀请时出现
	 */
	public class InviteAlert extends PopMiniWindow{
		
		protected var _mc:MovieClip;
		private var yes_button:Button;
		private var no_button:Button;
		private var view_button:Button;
		private var _dyId:int;
		
		public function InviteAlert(tit:String=WindowTittleName.TeamInvite){
			_mc = initByArgument(300,160,"inviteAlert",tit) as MovieClip;
			
			AutoBuild.replaceAll(_mc);
			yes_button = Xdis.getChildAndAddClickEvent(onYes,_mc,"yes_button");
			no_button = Xdis.getChildAndAddClickEvent(onNo,_mc,"no_button");
			view_button = Xdis.getChildAndAddClickEvent(onView,_mc,"view_button");
			view_button.textField.text = "查看信息";
			view_button.textField.textColor = TypeProps.C1ff1e0;
			var format:TextFormat = new TextFormat();
			format.underline = true;
			view_button.textField.setTextFormat(format);
			var text:TextField=_mc.statusTxt;
			text.wordWrap=true;
			text.multiline=true;
			text.text = "邀请您进队，是否同意？";
			text.textColor= TypeProps.Cfff0b6;
		}
		/**更新
		 */		
		override public function update():void{
			var inviteDyVo:InviteDyVo = TeamDyManager.Instance.getInviteList()[0];
			_mc.nameTxt.htmlText = HTMLFormat.color(inviteDyVo.name,TypeProps.C5ec700) + HTMLFormat.color("(等级"+inviteDyVo.lv+")",TypeProps.Cf0f275);
			_dyId = inviteDyVo.dyId;
			TeamDyManager.Instance.emptyInviteList();
		}
		
		override public function close(event:Event=null):void{
			super.close();
			this.dispose();
		}
		
		override public function dispose():void{
			yes_button.removeEventListener(MouseEvent.CLICK,onYes);
			yes_button=null;
			no_button.removeEventListener(MouseEvent.CLICK,onNo);
			no_button=null;
			view_button.removeEventListener(MouseEvent.CLICK,onView);
			view_button=null;
			_mc=null;
			super.dispose();
		}
		
		/**接受
		 * @param e
		 */
		protected function onYes(e:MouseEvent):void{
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
		
		/**拒绝
		 * @param e
		 */		
		protected function onNo(e:MouseEvent):void{
			this.close();
		}
		
		/**查看信息
		 * @param e
		 */		
		protected function onView(e:MouseEvent):void{
			ModuleManager.rankModule.otherPlayerReq(_dyId);
		}
	}
} 