package com.YFFramework.game.core.module.guild.view.guildMain.guildInfo
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.GuildMemberVo;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/***
	 *已有公会时，公会信息页下面的内容
	 *@author ludingchang 时间：2013-7-16 下午3:50:37
	 */
	public class GuildInfoView extends AbsView
	{
		public static const uiName:String="guild_info_view";
		private static const bgURL:String="guild/guild_info_bg.swf";
		
		private var _view:Sprite;
		private var _bg:Sprite;
		private var _guildInfoCtrl:GuildInfoCtrl;
		private var _guildMemberCtrl:GuildMemberCtrl;
		private var _guildInfoDownCtrl:GuildInfoDownCtrl;
		
		public function GuildInfoView(view:Sprite)
		{
			var pos:int=view.parent.getChildIndex(view);
			view.parent.addChildAt(this,pos);
			this.addChild(view);
			_bg=new Sprite;
			view.addChildAt(_bg,0);
			
			_view=view;
			_guildInfoCtrl=new GuildInfoCtrl(view);
			_guildMemberCtrl=new GuildMemberCtrl(view);
			_guildInfoDownCtrl=new GuildInfoDownCtrl(view);
		}
		
		public function update():void
		{
			var vo:GuildInfoVo=GuildInfoManager.Instence.myGuildInfo;
			_guildMemberCtrl.update(vo);
			_guildInfoCtrl.update(vo);
			_guildInfoDownCtrl.update();
		}
		
		public function updateDownInfo():void
		{
			_guildInfoDownCtrl.update();
		}
		
		/**释放资源*/
		override public function dispose(e:Event=null):void
		{
			if(_view&&_view.parent)
			{
				_view.parent.removeChild(_view);
				_view=null;
			}
			_bg=null;
			_guildInfoCtrl.dispose();
			_guildInfoCtrl=null;
			_guildMemberCtrl.dispose();
			_guildMemberCtrl=null;
			_guildInfoDownCtrl.dispose();
			_guildInfoDownCtrl=null;
			super.dispose();
		}
		/**
		 *检查背景，如果背景还没有就直接加载 
		 */		
		public function checkBackground():void
		{
			if(_bg.numChildren==0)
			{
				trace("load "+bgURL);
				GuildBackgroundManager.Instence.loadBG(URLTool.getDyModuleUI(bgURL),_bg);
			}
		}
	}
}