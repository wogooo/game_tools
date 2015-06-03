package com.YFFramework.game.core.module.system.view
{
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/***
	 *系统设置窗口
	 *@author ludingchang 时间：2013-7-10 上午10:28:14
	 */
	public class SystemWindow extends Window
	{
		private const CHECK_BOX_MAX:int=12;
		
		private var _ui:Sprite;
		
		private var _tabs:TabsManager;
		
		private var _settingPanel:SettingPanel;
		public function SystemWindow()
		{
			_ui = initByArgument(460,585,"system",WindowTittleName.systemTitle);
			content.x=33;
			content.y=43;
//			this.title=WindowTittleName.Forge;
			
			_settingPanel=new SettingPanel(Xdis.getChild(_ui,"view1"))
			
			_tabs=new TabsManager();
			_tabs.initTabs(_ui,"tabs_sp",2,"view");

		}
		
		override public function open():void
		{	
			super.open();
			_tabs.switchToTab(1);
		}

		override public function close(event:Event=null):void
		{
			closeTo(UI.stage.stageWidth-110,190,0.02,0.04);
		}
		
		public function updateSetting():void
		{
			_settingPanel.updateCheckBoxState();
		}
		
	}
}