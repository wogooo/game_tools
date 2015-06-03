package com.YFFramework.game.core.module.guild.view.guildJoin.rander
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildInviteVo;
	import com.YFFramework.game.core.module.guild.model.GuildItemVo;
	import com.YFFramework.game.core.module.guild.model.GuildWarningWindowHtml;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/***
	 *公会邀请列表渲染
	 *@author ludingchang 时间：2013-7-23 下午12:00:31
	 */
	public class GuildInviteRander extends ListRenderBase
	{

		private var _yesBtn:Button;
		private var _noBtn:Button;
		private var _name:TextField;
		private var _info:TextField;
		private var _view:Button;
		private var _item:GuildInviteVo;
		
		public function GuildInviteRander()
		{
			_renderHeight = 72;
		}
		override protected function resetLinkage():void
		{
			_linkage="uiSkin.Guild_invite_item";
		}
		override protected function onLinkageComplete():void
		{
			_ui.y=20;
			_ui.x=15;
			AutoBuild.replaceAll(_ui);
			_yesBtn=Xdis.getChildAndAddClickEvent(onYes,_ui,"yes_button");
			_noBtn=Xdis.getChildAndAddClickEvent(onNo,_ui,"no_button");
			_name=Xdis.getTextChild(_ui,"nameTxt");
			_name.textColor=TypeProps.C5ec700;
			_info=Xdis.getTextChild(_ui,"dataTxt");
			_view=Xdis.getChildAndAddClickEvent(onView,_ui,"view_button");
			_view.label="查看信息";
			var fmt:TextFormat=new TextFormat;
			fmt.underline=true;
			_view.textField.setTextFormat(fmt);
		}
		
		private function onView(e:MouseEvent):void
		{
			var vo:GuildItemVo=new GuildItemVo;
			vo.id=_item.guildId;
			vo.name=_item.guildName;
			vo.master="?";
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.LookupGuildInfo,vo);
		}
		override protected function updateView(item:Object):void
		{
			_item=item as GuildInviteVo;
			_name.text=item.inviterName;
			_info.htmlText=GuildWarningWindowHtml.getInviteHtml(item.guildName);
		}
		override public function dispose():void
		{
			super.dispose();
			
			_yesBtn.removeMouseClickEventListener(onYes);
			_noBtn.removeMouseClickEventListener(onNo);
			_view.removeMouseClickEventListener(onView);
			
			_view=null;
			_info=null;
			_yesBtn=null;
			_noBtn=null;
			_name=null;
		}
		private function onNo(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.RejectGuildInvite,_data);
		}
		
		private function onYes(e:MouseEvent):void
		{
			if(GuildInfoManager.Instence.hasGuild)
//				NoticeUtil.setOperatorNotice("你已有公会，无法加入。");
				NoticeManager.setNotice(NoticeType.Notice_id_1302);
			else
				YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AcceptGuildInvite,_data);
		}
	}
}