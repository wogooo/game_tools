package com.YFFramework.game.core.module.guild.view
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.view.guildMain.activity.GuildActivityView;
	import com.YFFramework.game.core.module.guild.view.guildMain.addMember.GuildAddMemberView;
	import com.YFFramework.game.core.module.guild.view.guildMain.building.GuildBuildingView;
	import com.YFFramework.game.core.module.guild.view.guildMain.guildInfo.GuildInfoView;
	import com.YFFramework.game.core.module.guild.view.guildMain.shop.GuildShopView;
	import com.YFFramework.game.core.module.guild.view.guildMain.skill.GuildSkillView;
	import com.YFFramework.game.core.module.guild.view.otherGuilds.GuildOtherView;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.FlashEff;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/***
	 *已加入公会的主面板
	 *@author ludingchang 时间：2013-7-15 下午5:00:13
	 */
	public class GuildTabWindow extends Window
	{
		private static var _inst:GuildTabWindow;
		private var _mc:Sprite;
		private var _tabs:Vector.<SimpleButton>;
		private var _views:Vector.<Sprite>;
		private var _tab:TabsManager;
		private var _bg:Sprite;
		private var _hasInit:Boolean=false;
		
		private var _guildinfo:GuildInfoView;
		private var _guildOtherView:GuildOtherView;
		private var _guildBuildingView:GuildBuildingView;
		private var _guildSkillView:GuildSkillView;
		private var _guildShopView:GuildShopView;
		private var _guildActivityView:GuildActivityView;
		private var _guildAddMemberView:GuildAddMemberView;
		/**公会有人申请入会时特效*/
		private var _eff:FlashEff;
		
		public static function get Instence():GuildTabWindow
		{
			if(!_inst)
				_inst=new GuildTabWindow;
			return _inst;
		}
		
		public function GuildTabWindow()
		{
			
		}
		
		private function init():void
		{
			if(!_hasInit)
			{
				_hasInit=true;
				
				_mc=initByArgument(718,581,"Guild_tab",WindowTittleName.Guild);
				_bg=new Sprite;
				_mc.addChildAt(_bg,0);
				setContentXY(25,28);
				
				var i:int,len:int=6;
				_tabs=new Vector.<SimpleButton>(len+1);
				_views=new Vector.<Sprite>(len+1);
				_tab=new TabsManager;
				
				_views[1]=_mc.getChildByName(GuildInfoView.uiName) as Sprite;
				_guildinfo=new GuildInfoView(_views[1]);
				
				_views[2]=_mc.getChildByName(GuildBuildingView.uiName) as Sprite;
				_guildBuildingView=new GuildBuildingView(_views[2]);
				
				_views[3]=_mc.getChildByName(GuildSkillView.uiName) as Sprite;
				_guildSkillView=new GuildSkillView(_views[3]);
				
				_views[4]=_mc.getChildByName(GuildShopView.uiName) as Sprite;
				_guildShopView=new GuildShopView(_views[4]);
				
				_views[5]=_mc.getChildByName(GuildActivityView.uiName) as Sprite;
				_guildActivityView=new GuildActivityView(_views[5]);
				
				_views[6]=_mc.getChildByName(GuildAddMemberView.uiName) as Sprite;
				_guildAddMemberView=new GuildAddMemberView(_views[6]);
				
				for(i=1;i<=len;i++)
				{
					_tabs[i]=Xdis.getSimpleButtonChild(_mc,"tab"+i);
					_tab.add(_tabs[i],_views[i]);
				}
				
				_tab.switchToTab(1);
				_tab.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
			}
		}
		
		protected function onTabChange(event:Event):void
		{
			switch(_tab.nowIndex)
			{
				case 1:
					_guildinfo.checkBackground();
					break;
				case 2:
					_guildBuildingView.checkBackgroud();
					break;
				case 3:
					_guildSkillView.checkBackgroud();
					break;
				case 4:
					_guildShopView.checkBackgroud();
					break;
				case 5:
					_guildActivityView.checkBackgroud();
					break;
				case 6://更新入会成员申请表
					_guildAddMemberView.checkBackgroud();
					break;
			}
			update();
		}
		override public function dispose():void
		{
			_mc=null;
			_tabs.length=0;
			_guildBuildingView.dispose();
			_guildinfo.dispose();
			_guildShopView.dispose();
			_guildSkillView.dispose();
			_guildActivityView.dispose();
			_guildAddMemberView.dispose();
			
			_guildActivityView=null;
			_guildAddMemberView=null;
			_guildBuildingView=null;
			_guildinfo=null;
			_guildShopView=null;
			_guildSkillView=null;
			_bg=null;
			
			super.dispose();
		}
		public override function update():void
		{
			if(isOpen)
			{
				var rightToAddMember:Boolean=GuildInfoManager.Instence.hasRightToAddMember();
				if(!rightToAddMember)
				{
					UI.setEnable(_tabs[6],false,true);
					if(_tab.nowIndex==6)
						_tab.switchToTab(1);
				}
				else
					UI.setEnable(_tabs[6],true,false);
				
				switch(_tab.nowIndex)
				{
					case 1://公会信息
						_guildinfo.update();
						break;
					case 2://公会建筑
						_guildBuildingView.update();
						break;
					case 3://公会技能
						_guildSkillView.update();
						break;
					case 4://公会商店
						_guildShopView.update();
						break;
					case 6://成员招收
						_guildAddMemberView.update();
						break;
				}
				//是否有人申请入会且有接受入会权限
				if(GuildInfoManager.Instence.flashAddMemberIcon())
				{
					if(!_eff)
					{
						_eff=new FlashEff(URLTool.getCommonAssets("flashEff.swf"),"btn_flash_eff",45);
						_tabs[6].parent.addChild(_eff);
						_eff.x=_tabs[6].x+_tabs[6].width/2-_eff.width/2;
						_eff.y=_tabs[6].y-_tabs[6].height;
						_eff.play();
					}
				}
				else if(_eff)
				{
					_eff.stop();
					_eff.parent.removeChild(_eff);
					_eff.dispose();
					_eff=null;
				}
			}
		}
		
		/**更新下面贡献、金钱等*/
		public function updateDownInfo():void
		{
			if(isOpen)
			{
				switch(_tab.nowIndex)
				{
					case 1://公会信息
						_guildinfo.updateDownInfo();
						break;
					case 3://公会技能
						_guildSkillView.updateDownInfo();
						break;
					case 4://公会商店
						_guildShopView.updateDownInfo();
						break;
				}
			}
		}
		
		override public function open():void
		{
			init();
			checkBackgroud();
			super.open();
			onTabChange(null);
		}
		private function checkBackgroud():void
		{
			if(_bg.numChildren==0)
				GuildBackgroundManager.Instence.loadBG(DyModuleUIManager.guildMarketWinBg,_bg);
		}
		override public function close(event:Event=null):void
		{
			closeTo(StageProxy.Instance.getWidth()-150,StageProxy.Instance.getHeight()-100);
		}
	}
}