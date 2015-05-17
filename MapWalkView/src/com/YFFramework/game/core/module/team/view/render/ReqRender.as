package com.YFFramework.game.core.module.team.view.render
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.CApplyJoinTeam;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-7 上午10:16:40
	 * 
	 */
	public class ReqRender extends ListRenderBase{
		
		private var yes_button:Button;
		private var no_button:Button;
		private var view_button:Button;
		private var _dyId:int;
		private var _nameTxt:TextField;
		
		public function ReqRender(){
			_renderHeight = 58;
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
			view_button.textField.textColor = TypeProps.C5ec700;
			var format:TextFormat = new TextFormat();
			format.underline = true;
			view_button.textField.setTextFormat(format);
			Xdis.getTextChild(_ui,"dataTxt").text = "申请入队，是否同意？";
			_nameTxt = Xdis.getTextChild(_ui,"nameTxt");
		}
		
		override protected function updateView(item:Object):void{
			_nameTxt.htmlText = HTMLFormat.color(item.name,TypeProps.C5ec700) + HTMLFormat.color("（等级"+item.lv+")",TypeProps.Cf0f275);
			_dyId = item.dyId;
		}
		
		private function onYes(e:MouseEvent):void{
			if(TeamDyManager.Instance.getMembers().length==5){
				NoticeUtil.setOperatorNotice("队伍已满，无法加入");
			}else if(TeamDyManager.Instance.containsMember(_dyId)){
				NoticeUtil.setOperatorNotice("队伍已有该成员");
				_list.removeItemAt(_index);
			}else{
				var msg:CApplyJoinTeam = new CApplyJoinTeam();
				msg.dyId = _dyId;
				YFEventCenter.Instance.dispatchEventWith(TeamEvent.AccJoinReq,msg);
				_list.removeItemAt(_index);
			}
		}
		
		private function onNo(e:MouseEvent):void{
			_list.removeItemAt(_index);
			TeamDyManager.Instance.delFromReq(_dyId);
		}
		
		private function onView(e:MouseEvent):void{
			NoticeUtil.setOperatorNotice("等待策划设定。。。");
		}
	}
} 