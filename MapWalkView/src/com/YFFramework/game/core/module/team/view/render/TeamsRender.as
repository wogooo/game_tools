package com.YFFramework.game.core.module.team.view.render
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.CJoinTeam;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import com.dolo.ui.controls.IconImage;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-3 下午5:12:30
	 * 附近队伍渲染器
	 */
	public class TeamsRender extends ListRenderBase{
		
		private var _dyId:int;
		private var action_button:Button;
		private var format:TextFormat;
		private var _iconImage:IconImage;
		
		public function TeamsRender(){
			_renderHeight = 48;
		}
	
		override protected function resetLinkage():void{
			_linkage = "uiSkin.PlayerInfo";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			action_button = Xdis.getChild(_ui,"action_button");
			_iconImage = Xdis.getChild(_ui,"img_iconImage");
			format = new TextFormat();
			format.underline = true;
		}
		
		override protected function updateView(item:Object):void{
			Xdis.getTextChild(_ui,"nameTxt").htmlText = HTMLFormat.color(item.name + "(等级："+item.lv+")",TypeProps.Cffef95);
			Xdis.getTextChild(_ui,"statusTxt").htmlText = HTMLFormat.color("("+item.memberNum+"/5)",TypeProps.Cffef95);
			if(item.memberNum<5){
				action_button.textField.text = "入队";
				action_button.textField.textColor=TypeProps.Cffef95;
				action_button.addEventListener(MouseEvent.CLICK,onJoin);
			}
			else{
				action_button.textField.text = "已满";
				action_button.textField.textColor=TypeProps.GRAY;
			}
			action_button.textField.setTextFormat(format);
			_dyId = item.dyId;
			_iconImage.url = CharacterPointBasicManager.Instance.getIconURL(item.career,item.sex);
		}
		
		private function onJoin(e:MouseEvent):void{
			if(TeamDyManager.Instance.getMembers().length>1){
				NoticeUtil.setOperatorNotice("你已在队伍中，不能再进入别的队伍");
			}else{
				if(action_button.hasEventListener(MouseEvent.CLICK))
					action_button.removeEventListener(MouseEvent.CLICK,onJoin);
				action_button.textField.text = "已申请";
				action_button.textField.textColor=TypeProps.GRAY;
				action_button.textField.setTextFormat(format);
				var msg:CJoinTeam = new CJoinTeam();
				msg.dyId = _dyId;
				YFEventCenter.Instance.dispatchEventWith(TeamEvent.JoinReq,msg);
				NoticeUtil.setOperatorNotice("申请加入队伍，等待队长批准。");
			}
		}
	}
} 