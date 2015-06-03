package com.YFFramework.game.core.module.team.view.render
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.CApplyTeamInvite;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-2 下午5:35:40
	 * 邀请列表的渲染器
	 */
	public class InviteRender extends ListRenderBase{
		
		private var yes_button:Button;
		private var no_button:Button;
		private var view_button:Button;
		private var _nameTxt:TextField;
		private var _dyId:int;
		
		public function InviteRender(){
			_renderHeight = 71;
		}
		
		override protected function resetLinkage():void{
			_linkage = "uiSkin.Invite";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			yes_button = Xdis.getChildAndAddClickEvent(onYes,_ui,"yes_button");
			no_button = Xdis.getChildAndAddClickEvent(onNo,_ui,"no_button");
			view_button = Xdis.getChildAndAddClickEvent(onView,_ui,"view_button");
			view_button.textField.text = "查看信息";
			view_button.textField.textColor = TypeProps.C1ff1e0;
			var format:TextFormat = new TextFormat();
			format.underline = true;
			view_button.textField.setTextFormat(format);
			Xdis.getTextChild(_ui,"dataTxt").text = "邀请你入队，是否同意？";
			_nameTxt = Xdis.getTextChild(_ui,"nameTxt");
		}
		
		override protected function updateView(item:Object):void{
			_nameTxt.htmlText = HTMLFormat.color(item.name,TypeProps.C5ec700) + HTMLFormat.color("（等级"+item.lv+"）",TypeProps.Cf0f275);
//			_nameTxt.text = item.name + "(等级"+item.lv+")";
			_dyId = item.dyId;
		}
		
		override public function dispose():void{
			super.dispose();
			yes_button.removeEventListener(MouseEvent.CLICK,onYes);
			yes_button=null;
			no_button.removeEventListener(MouseEvent.CLICK,onNo);
			no_button=null;
			view_button.removeEventListener(MouseEvent.CLICK,onView);
			view_button=null;
			_nameTxt=null;
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
			_list.removeItemAt(_index);
			YFEventCenter.Instance.dispatchEventWith(TeamEvent.CloseInviteWindow);
		}
		
		private function onNo(e:MouseEvent):void{
			_list.removeItemAt(_index);
			YFEventCenter.Instance.dispatchEventWith(TeamEvent.CloseInviteWindow);
		}
		
		private function onView(e:MouseEvent):void{
			ModuleManager.rankModule.otherPlayerReq(_dyId);
		}
	}
} 