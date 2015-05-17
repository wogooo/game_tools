package com.YFFramework.game.core.module.forge.view
{
	import flash.display.Sprite;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.controls.CheckBox;
	import flash.events.Event;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.Button;
	import flash.events.MouseEvent;
	import com.dolo.ui.sets.ButtonTextStyle;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.dolo.ui.managers.UI;
	import flash.system.System;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.system.Capabilities;
	import flash.profiler.showRedrawRegions;
	
	public class RightMenu
	{
		private var _ui:Sprite;
		private var _tabs:TabsManager = new TabsManager();
		private var _materialTabs:TabsManager = new TabsManager();
		private var _numStep:NumericStepper;
		private var _perCheckBox:CheckBox;
		private var _strengthenButton:Button;
		private var _menu:Menu;
		private var _debugAdd:int=0;
		private var _showRedraw:Boolean = false;
		
		public function RightMenu(targetUI:Sprite)
		{
			UI.stage.addEventListener("rightMouseDown",onStageRightClick);
		}
		
		protected function onStageRightClick(event:MouseEvent):void
		{
			test();
		}
		
		private function onStrengthenBtnClick(event:MouseEvent):void
		{
		}
		
		private function test():void{
			if(!_menu){
				_menu = new Menu();
				//可写可不写
				//				_menu.setSkin(Menu.defaultBagckGroundLinkage,Menu.defaultMenuItemLinkage);
				//				_menu.initByArray(["跟随","跟随",Menu.creatDefautSpace(),"跟随","跟随跟随跟随","跟随",Menu.creatDefautSpace(),"跟随"],onMenuItemClick);
				if(Capabilities.isDebugger){
					_menu.addItem("显示重绘区域",onMenuItemClick);
					_debugAdd = 1;
				}
				_menu.addItem("客户端版本: 0.1 alpha ",onMenuItemClick,"flyBoot");
				_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("Flash Player 设置",onMenuItemClick2);
				_menu.addItem("FlashPlayer 全局设置",onMenuItemClick3);
				_menu.addItem("Adobe Flash Player"+Capabilities.version.slice(3)+"...",null);
				_menu.disableItem(0+_debugAdd);
				_menu.disableItem(3+_debugAdd);
				//可写可不写
			}
			_menu.changeIcon(0+_debugAdd,"flyBoot");
			_menu.show();
			UI.stage.addEventListener(Event.RESIZE,onStageReseze);
		}
		
		protected function onStageReseze(event:Event):void
		{
			if(_menu) _menu.hide();
		}
		
		private function onMenuItemClick(index:uint,label:String):void
		{
			_showRedraw = !_showRedraw;
			showRedrawRegions(_showRedraw,0x0099FF);
			if(_showRedraw == true){
				_menu.changeIcon(0,"menuSelect");
			}else{
				_menu.changeIcon(0,null);
			}
		}
		
		private function onMenuItemClick2(index:uint,label:String):void
		{
			Security.showSettings();
		}
		
		private function onMenuItemClick3(index:uint,label:String):void
		{
			Security.showSettings(SecurityPanel.SETTINGS_MANAGER);
		}
		
		protected function onPer100Change(event:Event):void
		{
			if(_perCheckBox.selected == true){
				_numStep.enabled = false;
				_numStep.value = 20;
			}else{
				_numStep.enabled = true;
				_numStep.value = 4;
			}
		}
		
	}
}