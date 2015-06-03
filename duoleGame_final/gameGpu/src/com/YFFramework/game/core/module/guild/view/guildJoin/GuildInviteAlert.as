package com.YFFramework.game.core.module.guild.view.guildJoin
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildInviteVo;
	import com.YFFramework.game.core.module.guild.model.GuildItemVo;
	import com.YFFramework.game.core.module.guild.model.GuildWarningWindowHtml;
	import com.YFFramework.game.core.module.team.view.InviteAlert;
	import com.msg.guild.CAcceptGuildInvite;
	import com.net.MsgPool;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/***
	 *
	 *@author ludingchang 时间：2013-8-13 上午11:58:37
	 */
	public class GuildInviteAlert extends InviteAlert
	{
		private var _item:GuildInviteVo;
		public function GuildInviteAlert()
		{
			super(WindowTittleName.GuildInvite);
			_mc.nameTxt.textColor=TypeProps.C5ec700;
		}
		override public function update():void
		{
			var vo:GuildInviteVo=GuildInfoManager.Instence.invite_data[0] as GuildInviteVo;
			_mc.nameTxt.text=vo.inviterName;
			_mc.statusTxt.htmlText=GuildWarningWindowHtml.getInviteHtml(vo.guildName);
			_item=vo;
		}
		override protected function onYes(e:MouseEvent):void
		{
			var msg:CAcceptGuildInvite=new CAcceptGuildInvite;
			msg.guildId=_item.guildId;
			MsgPool.sendGameMsg(GameCmd.CAcceptGuildInvite,msg);
			close();
		}
		override protected function onView(e:MouseEvent):void
		{
			var vo:GuildItemVo=new GuildItemVo;
			vo.id=_item.guildId;
			vo.name=_item.guildName;
			vo.master="?";
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.LookupGuildInfo,vo);
		}
	}
}