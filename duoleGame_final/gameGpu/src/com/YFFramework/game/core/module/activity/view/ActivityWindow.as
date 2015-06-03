package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/***
	 *活动界面
	 *@author ludingchang 时间：2013-7-12 下午12:03:08
	 */
	public class ActivityWindow extends Window{
		
		private var _mc:Sprite;
		private var _tab:TabsManager;
		private var _raidView:RaidView;
		private var _taskView:TaskView;
		private var _dailyView:DailyView;
		private var _bossView:BossView;
		
		public function ActivityWindow(){
			_mc=initByArgument(720,580,"ActivityWindow",WindowTittleName.ActivityTitle,true,DyModuleUIManager.guildMarketWinBg);
			setContentXY(25,28);
			_taskView = new TaskView(Xdis.getChild(_mc,"tabView1"));
			_raidView = new RaidView(Xdis.getChild(_mc,"tabView2"));
			_dailyView = new DailyView(Xdis.getChild(_mc,"tabView3"));
			_bossView = new BossView(Xdis.getChild(_mc,"tabView4"));
			
			var _toogleBtn:MovieClip = Xdis.getChild(_mc,"tab");
			_tab=new TabsManager;
			_tab.initTabs(_mc,"tab",4,"tabView");
			_tab.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
		}
		/**切换按钮点击
		 * @param event
		 */		
		protected function onTabChange(event:Event):void{
			switch(_tab.nowIndex){
				case 1:
					_taskView.onTabUpdate();
					break;
				case 2:
					_raidView.onTabUpdate();
					break;
				case 3:
					_dailyView.onTabUpdate();
					break;
				case 4:
					_bossView.onTabUpdate();
					break;
			}
		}
		/**面板打开
		 */		
		public function onOpen():void{
			_tab.switchToTab(1);
		}

	}
}