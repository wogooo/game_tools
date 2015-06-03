package com.YFFramework.game.core.module.guild.view.guildMain.addMember
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.view.guildMain.guildInfo.GuildInfoCtrl;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/***
	 *公会招收成员窗口
	 *@author ludingchang 时间：2013-7-19 下午3:02:56
	 */
	public class GuildAddMemberView extends AbsView
	{
		public static const uiName:String="guild_add_member";
		private static const bgURL:String="guild/guild_add_member_bg.swf";
		
		
		private var _lookupBtn:Button;
		private var _page:ReMemberPage;
		private var _guildInfoCtrl:GuildInfoCtrl;
		private var _bg:Sprite;
		
		public function GuildAddMemberView(view:Sprite)
		{
			var pos:int=view.parent.getChildIndex(view);
			view.parent.addChildAt(this,pos);
			this.addChild(view);
			_bg=new Sprite;
			view.addChildAt(_bg,0);
			var sp:Sprite=view;
			
			_guildInfoCtrl=new GuildInfoCtrl(view);
			var page:Sprite=sp.getChildByName(ReMemberPage.uiName) as Sprite;
			_page=new ReMemberPage(page);
			_page.setPage(1,1);
		
			_lookupBtn=Xdis.getChildAndAddClickEvent(onLookup,sp,"lookup_button");
			
			update();
		}
		
		private function onLookup(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.LookupMember);
		}
		public function update():void
		{
			var vo:GuildInfoVo=GuildInfoManager.Instence.myGuildInfo;
			_guildInfoCtrl.update(vo);
			var reMembers:Array=GuildInfoManager.Instence.reMembers;
			_page.updateList(reMembers);
		}
		public function checkBackgroud():void
		{
			if(_bg.numChildren==0)
			{
				GuildBackgroundManager.Instence.loadBG(URLTool.getDyModuleUI(bgURL),_bg);
			}
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_bg=null;
			_lookupBtn.dispose();
			_lookupBtn=null;
			_page.dispose();
			_page=null;
			_guildInfoCtrl.dispose();
			_guildInfoCtrl=null;
		}
		override protected function removeEvents():void
		{
			_lookupBtn.removeMouseClickEventListener(onLookup);
		}
	}
}