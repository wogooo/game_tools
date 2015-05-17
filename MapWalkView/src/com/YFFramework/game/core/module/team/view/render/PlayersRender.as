package com.YFFramework.game.core.module.team.view.render
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.CTeamInviteOther;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-3 下午3:46:28
	 * 附近玩家渲染器
	 */
	public class PlayersRender extends ListRenderBase{
	
		private var _dyId:int;
		private var _name:String;
		private var action_button:Button;
		private var format:TextFormat;
		private var _iconImage:IconImage;
		
		public function PlayersRender(){
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
			Xdis.getTextChild(_ui,"statusTxt").htmlText = HTMLFormat.color(item.status,TypeProps.Cffef95);
			if(item.memberNum==0){
				action_button.textField.text = "邀请";
				action_button.textField.textColor=TypeProps.Cffef95;
				action_button.addEventListener(MouseEvent.CLICK,onInvite);
			}else{
				action_button.textField.text = "已组队";
				action_button.textField.textColor=TypeProps.GRAY;
			}
			action_button.textField.setTextFormat(format);
			_dyId = item.dyId;
			_name = item.name;
			_iconImage.url = CharacterPointBasicManager.Instance.getIconURL(item.career,item.sex);
		}
	
		private function onInvite(e:MouseEvent):void{
			if(TeamDyManager.Instance.getMembers().length>1 && TeamDyManager.LeaderId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
				NoticeUtil.setOperatorNotice("不是队长不能邀请");
			}else if(TeamDyManager.Instance.getMembers().length==5){
				NoticeUtil.setOperatorNotice("队伍已满，不能邀请");	
			}else{
				if(action_button.hasEventListener(MouseEvent.CLICK))
					action_button.removeEventListener(MouseEvent.CLICK,onInvite);
				action_button.textField.text = "已邀请";
				action_button.textField.textColor=TypeProps.GRAY;
				action_button.textField.setTextFormat(format);
				var msg:CTeamInviteOther = new CTeamInviteOther();
				msg.dyId = _dyId;
				YFEventCenter.Instance.dispatchEventWith(TeamEvent.InviteReq,msg);
				NoticeUtil.setOperatorNotice("已邀请["+_name+"]组队，等待对方回应。");
			}
		}
	}
} 