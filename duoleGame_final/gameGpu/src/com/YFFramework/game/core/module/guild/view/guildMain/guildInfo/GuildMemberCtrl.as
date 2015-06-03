package com.YFFramework.game.core.module.guild.view.guildMain.guildInfo
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	/***
	 *公会成员管理
	 *@author ludingchang 时间：2013-8-3 下午1:39:19
	 */
	public class GuildMemberCtrl
	{
		private var _view:Sprite;
		private var _memberPage:GuildMemberPage;
		private var _invaterBtn:Button;
		private var _goBackBtn:Button;
		private var _last_publish_time:int=-60000;
		public function GuildMemberCtrl(view:Sprite)
		{
			_view=view;
			var membPage:Sprite=view.getChildByName(GuildMemberPage.uiName) as Sprite;
			_memberPage=new GuildMemberPage(membPage);
			_invaterBtn=Xdis.getChildAndAddClickEvent(onBtnClick,view,"invater_button");
			_goBackBtn=Xdis.getChildAndAddClickEvent(onBtnClick,view,"goback_button");
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _invaterBtn:
					var t:int=getTimer();
					if(t-_last_publish_time<GuildConfig.PublicInvatorCoolDown)
					{
//						NoticeUtil.setOperatorNotice("您发布的太频繁了，请稍候再试");
						NoticeManager.setNotice(NoticeType.Notice_id_1325);
					}
					else
					{
						var count:int=GuildInfoManager.Instence.invater_count;
						if(count<GuildConfig.PublicInvatorMaxFreeCount)
							Alert.show("每天可免费发布2次，额外可通过消耗魔钻发布10次邀请信息 ,本次发布免费。","发布邀请",publishHandler,["发布","取消"]);
						else if(count<GuildConfig.PublicInvatorMaxFreeCount+GuildConfig.publicInvatorMaxMoneyCount)
							Alert.show("每天可免费发布2次，额外可通过消耗魔钻发布10次邀请信息 ,本次发布消耗10魔钻。","发布邀请",publishHandler,["发布","取消"]);
						else
//							NoticeUtil.setOperatorNotice("今天的发布邀请次数已用完，请明天再发布！");
							NoticeManager.setNotice(NoticeType.Notice_id_1326);
					}
					break;
				case _goBackBtn:
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.GoBackGuild);
					break;
			}
		}
		private function publishHandler(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex==1)
			{
				_last_publish_time=getTimer();
				YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.PublishInvitor);//聊天频道发布邀请
			}
		}
		public function update(vo:GuildInfoVo):void
		{
			_memberPage.updateList(vo.members);
			_memberPage.resetSelectedItem();
			var pos:int=GuildInfoManager.Instence.me.position;
			_invaterBtn.enabled=TypeGuild.canPostInvater(pos);
		}
		public function dispose():void
		{
			_memberPage.dispose();
			_memberPage=null;
			
			_invaterBtn.removeMouseClickEventListener(onBtnClick);
			_goBackBtn.removeMouseClickEventListener(onBtnClick);
			_invaterBtn=null;
			_goBackBtn=null;
			_view=null;
		}
	}
}