package com.YFFramework.game.core.module.guild.view.guildJoin
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.OtherGuildListVo;
	import com.YFFramework.game.core.module.guild.view.otherGuilds.GuildOtherPageCtrl;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/***
	 *加入公会面板
	 *@author ludingchang 时间：2013-7-15 上午10:35:23
	 */
	public class GuildJoinWindow extends Window
	{
		/**原件在fla中的名字*/
		private static const uiName:String="Guild_join";
		private static const bgURL:String="guild/guild_join_bg.swf";
		
		private static var _inst:GuildJoinWindow;
		
		private var _mc:Sprite;
		private var _create_btn:Button;
		private var _pageCtrl:GuildOtherPageCtrl;
		private var _bgSmall:Sprite;
		private var _bgBig:Sprite;
		private var _hasInit:Boolean=false;
		
		public static function get Instence():GuildJoinWindow
		{
			if(!_inst)
				_inst=new GuildJoinWindow;
			return _inst;
		}
		
		public function GuildJoinWindow()
		{
		}
		
		private function init():void
		{
			if(!_hasInit)
			{
				_hasInit=true;
				
				_mc=initByArgument(717,576,uiName,WindowTittleName.Guild);
				setContentXY(25,27);
				
				AutoBuild.replaceAll(_mc);
				_bgBig=new Sprite;
				_mc.addChildAt(_bgBig,0);
				_bgSmall=new Sprite;
				_mc.addChildAt(_bgSmall,1);
				
				var page:Sprite=_mc.getChildByName(GuildOtherPageCtrl.uiName) as Sprite;
				_pageCtrl=new GuildOtherPageCtrl(page);
				
				_create_btn=Xdis.getChildAndAddClickEvent(onCreate,_mc,"create_button");
			}
		}
		
		
		private function onCreate(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.ShowCreateWindow);
		}
		
		override public function open():void
		{
			init();
			checkBackground();
			update();
			super.open();
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level>=GuildConfig.GuildMinCreateLv)
				_create_btn.enabled=true;
			else
				_create_btn.enabled=false;
			_pageCtrl.resetTxt();
		}
		override public function dispose():void
		{
			_mc=null;
			_create_btn.removeEventListener(MouseEvent.CLICK,onCreate);
			_create_btn=null;
			_pageCtrl.dispose();
			_pageCtrl=null;
			_bgSmall=null;
			_bgBig=null;
			 
			super.dispose();
		}
		override public function update():void
		{
			var vo:OtherGuildListVo=GuildInfoManager.Instence.otherGuildList;
			if(vo)
			{
				_pageCtrl.updateList(vo.guild_list);
				_pageCtrl.setPage(vo.current_page,vo.total_page);
			}
			else
			{
				_pageCtrl.updateList([]);
				_pageCtrl.setPage(1,1);
			}
		}
		private function checkBackground():void
		{
			if(_bgBig.numChildren==0)
				GuildBackgroundManager.Instence.loadBG(DyModuleUIManager.guildMarketWinBg,_bgBig);
			if(_bgSmall.numChildren==0)
				GuildBackgroundManager.Instence.loadBG(URLTool.getDyModuleUI(bgURL),_bgSmall);
		}
		override public function close(event:Event=null):void
		{
			closeTo(StageProxy.Instance.getWidth()-150,StageProxy.Instance.getHeight()-100);
		}
	}
}