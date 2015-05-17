package com.YFFramework.game.core.module.shop
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.shop.vo.ShopBasicVo;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.InitUtils;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.dolo.ui.managers.UIManager;
	import com.YFFramework.game.core.module.bag.backPack.BagWindow;
	import com.YFFramework.game.core.module.shop.vo.NPCShopBasicManager;
	
	/**
	 * 商店 
	 * @author flashk
	 * 
	 */
	public class ShopWindow extends Window
	{
		private static var _ins:ShopWindow;
		
		private var _ui:Sprite;
		private var _fixAllButton:Button;
		private var _fixButton:ToggleButton;
		private var _tabsManager:TabsManager;
		private var _buyBtn:ToggleButton;
		private var _sellBtn:ToggleButton;
		private var _mouseMode:int = 0;
		private var _tabViews:Array = [];
		private var _buyBack:BuyBackCOL;
		//tab支持最大个数
		private var _tabMax:int = 5;
		
		public function ShopWindow()
		{
			super();
			_ins = this;
			_ui = initByArgument(390,510,"ui.ShopUI","商店");
			_buyBack = new BuyBackCOL();
			_buyBack.initUI(Xdis.getChild(_ui,"buyBack_sp"));
			var tabView:NPCShopOneTabView;
			_tabsManager = new TabsManager();
			for(var i:int=1;i<=_tabMax;i++){
				tabView = new NPCShopOneTabView();
				_ui.addChild(tabView);
				_tabViews.push(tabView);
				_tabsManager.add(Xdis.getChild(_ui,"tabs_sp","tab"+i),tabView);
				Xdis.getTextChild(_ui,"tabs_sp","tabTxt"+i).mouseEnabled = false;
			}
			_tabsManager.switchToTab(1);
			_fixAllButton = Xdis.getChild(_ui,"fixAll_button");
			_fixAllButton.addEventListener(MouseEvent.CLICK,onFixAllBtnClick);
			_fixButton = Xdis.getChild(_ui,"fix_toggleButton");
			_fixButton.addEventListener(Event.CHANGE,onFixBtnChange);
			_buyBtn = Xdis.getChild(_ui,"buy_toggleButton");
			_sellBtn = Xdis.getChild(_ui,"sell_toggleButton");
			_buyBtn.addEventListener(Event.CHANGE,onBuyBtnChange);
			_sellBtn.addEventListener(Event.CHANGE,onSellBtnChange);
		}
		
		public static function get ins():ShopWindow
		{
			return _ins;
		}
		
		override public function open():void
		{
			super.open();
			_buyBtn.selected = true;
		}
		
		override public function close(event:Event=null):void
		{
			super.close(event);
			_fixButton.selected = false;
			_sellBtn.selected = false;
			MouseManager.resetToDefaultMouse();
			if(BuyWindow.ins && BuyWindow.ins.isOpen){
				BuyWindow.ins.close();
			}
		}
		
		/**
		 * 设置某个Tab标签的文本 
		 * @param tabIndex
		 * @param tabName
		 * 
		 */
		public function setTabName(tabIndex:int,tabName:String):void
		{
			Xdis.getTextChild(_ui,"tabs_sp","tabTxt"+tabIndex).text = tabName;
		}
		
		/**
		 * 刷新某个标签的所以数据，翻页将被重置到第一页 
		 * @param voList
		 * @param tabIndex
		 * @param label
		 * 
		 */
		public function updateList(voList:Vector.<ShopBasicVo>,tabIndex:int,label:String):void
		{
			showHideTab(tabIndex,true);
			NPCShopOneTabView(_tabViews[tabIndex-1]).updateList(voList);
			Xdis.getTextChild(_ui,"tabs_sp","tabTxt"+tabIndex).text = label;
		}
		
		/**
		 * 当前是否为购买模式 
		 * @return 
		 * 
		 */
		public function get isBuyMode():Boolean
		{
			if(_mouseMode == 1) return true;
			return false;
		}
		
		/**
		 *  显示某个标签
		 * @param index 从1开始，1为显示第1个标签
		 * 
		 */
		public function switchTabAt(index:int):void
		{
			_tabsManager.switchToTab(index);
		}
		
		/**
		 * 重置标签 
		 * 
		 */
		public function reset():void
		{
			for(var i:int=1;i<=_tabMax;i++){
				showHideTab(i,false);
			}
		}
		
		private function showHideTab(index:int,isVisible:Boolean):void
		{
			Xdis.getDisplayObjectChild(_ui,"tabs_sp","tab"+index).visible = isVisible;
			Xdis.getTextChild(_ui,"tabs_sp","tabTxt"+index).visible = isVisible;
		}
		
		private function onFixBtnChange(event:Event):void
		{
			if(_fixButton.selected == true){
				_buyBtn.selected = false;
				_sellBtn.selected = false;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_FIX_CLICK,true);
			}else{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_FIX_CLICK,false);
			}
		}
		
		/**
		 * 当在购买模式点击商品项弹出购买小窗口 
		 * @param event
		 * 
		 */
		private function onSellBtnChange(event:Event):void
		{
			if(_sellBtn.selected == true){
				_buyBtn.selected = false;
				_fixButton.selected = false;
				_mouseMode = 2;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_SELL_CLICK,true);
				var bagWindow:BagWindow=ModuleManager.bagModule.getBagWindow();
				if(bagWindow.isOpen == false){
					bagWindow.open();
					UIManager.centerMultiWindows(this,bagWindow,5);
				}
			}else{
				_mouseMode = 0;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_SELL_CLICK,false);
			}
		}
		
		/**
		 * 购买状态切换 
		 * @param event
		 * 
		 */
		private function onBuyBtnChange(event:Event=null):void
		{
			if(_buyBtn.selected == true){
				_sellBtn.selected = false;
				_fixButton.selected = false;
				_mouseMode = 1;
			}else{
				_mouseMode = 0;
			}
		}
		
		/**
		 * 全部修理 
		 * @param event
		 * 
		 */
		private function onFixAllBtnClick(event:MouseEvent=null):void
		{
			ModuleShop.ins.fix.fixAll();
		}
		
	}
}