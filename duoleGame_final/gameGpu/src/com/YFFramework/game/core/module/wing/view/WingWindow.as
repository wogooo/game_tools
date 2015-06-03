package com.YFFramework.game.core.module.wing.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @version 1.0.0
	 * creation time：2013-9-27 上午10:21:02
	 */
	public class WingWindow extends Window{
		
		private var _ui:Sprite;
		public var _tabs:TabsManager;
		public var _wingLvUp:WingLvUp;
		public var _wingFeather:WingFeather;
		
		public function WingWindow(){
			_ui = initByArgument(578,660,"ui.WingWindowUI",WindowTittleName.Forge,true,DyModuleUIManager.wingWinBg);
			setContentXY(30,26);
				
			_tabs = new TabsManager();
			
			_wingLvUp = new WingLvUp(Xdis.getChild(_ui,"tabView1"),this);
			_wingFeather = new WingFeather(Xdis.getChild(_ui,"tabView2"));
			
			_tabs.initTabs(_ui,"tabs_sp",2);
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
		}
		/**切换Tab更新
		 * @param e
		 */		
		private function onTabChange(e:Event):void{
			if(_tabs.nowIndex == 1)	_wingLvUp.initPanel();
			else if(_tabs.nowIndex == 2)	_wingFeather.initPanel();
		}
		/**打开tab 
		 * @param id
		 */		
		public function openTab(id:int):void{
			_tabs.switchToTab(id);
		}
		
		override public function close(event:Event=null):void{
			closeTo(UI.stage.stageWidth-345,UI.stage.stageHeight-65,0.02,0.04);
			_wingLvUp.onClose();
		}
		
		public function getTarget():Point
		{
			var p:Point=new Point;
			p.x=this.x+this.width+5;
			p.y=this.y+5;
			return p;
		}
		
	}
} 