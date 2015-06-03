package com.YFFramework.game.core.module.shop.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.backPack.BagWindow;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.character.ModuleCharacter;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.InitUtils;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 商店 
	 * @author flashk
	 * 
	 */
	public class ShopWindow extends Window
	{
		private static var _instance:ShopWindow;
		
		/** 0 */
		private const NONE:int=0;
		/** 1 */
		private const BUY:int=1;
		/** 2 */
		private const SELL:int=2;		
		
		private var _ui:Sprite;
		private var _fixAllButton:Button;
		private var _fixButton:ToggleButton;
		private var _tabsManager:TabsManager;
		private var _buyBtn:ToggleButton;
		private var _sellBtn:ToggleButton;
//		private var _mouseMode:int = 0;
		private var _tabViews:Array = [];
		private var _buyBack:BuyBackCOL;
		//tab支持最大个数
		private var _tabMax:int = 5;
		
		public function ShopWindow()
		{
			super();
			_ui = initByArgument(390,500,"ui.ShopUI",WindowTittleName.shopTitle);
			setContentXY(34,42);
			_buyBack = new BuyBackCOL();
			_buyBack.initUI(Xdis.getChild(_ui,"buyBack_sp"));
			
			var tabView:ShopPageControl;
			_tabsManager = new TabsManager();
			for(var i:int=1;i<=_tabMax;i++){
				tabView = new ShopPageControl();
				_ui.addChild(tabView);
				_tabViews.push(tabView);
				_tabsManager.add(Xdis.getChild(_ui,"tabs_sp","tab"+i),tabView,Xdis.getChild(_ui,"tabs_sp","tabTxt"+i));
//				Xdis.getTextChild(_ui,"tabs_sp","tabTxt"+i).mouseEnabled = false;
			}
//			_tabsManager.switchToTab(1);
			
			_fixAllButton = Xdis.getChild(_ui,"fixAll_button");
			_fixAllButton.addEventListener(MouseEvent.CLICK,onFixAllBtnClick);
			
			_fixButton = Xdis.getChild(_ui,"fix_toggleButton");
			_fixButton.addEventListener(Event.CHANGE,onFixBtnChange);
			_fixButton.alwaysSelectedEffect=true;
			
			_buyBtn = Xdis.getChild(_ui,"buy_toggleButton");
			_buyBtn.addEventListener(Event.CHANGE,onBuyBtnChange);
			_buyBtn.alwaysSelectedEffect=true;
			
			_sellBtn = Xdis.getChild(_ui,"sell_toggleButton");		
			_sellBtn.addEventListener(Event.CHANGE,onSellBtnChange);
			_sellBtn.alwaysSelectedEffect=true;
		}
		
		public static function get instance():ShopWindow
		{
			if(_instance == null) _instance=new ShopWindow();
			return _instance;
		}
		
		override public function open():void
		{
			super.open();
			_tabsManager.switchToTab(1);
			_buyBtn.selected = true;
			MouseManager.resetToDefaultMouse();
		}
		
		override public function close(event:Event=null):void
		{
			super.close(event);
//			_fixButton.selected = false;
//			_sellBtn.selected = false;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_SHOP_MODE,BagSource.SHOP_NONE);
			if(BuyWindow.instance && BuyWindow.instance.isOpen){
				BuyWindow.instance.close();
			}
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
			ShopPageControl(_tabViews[tabIndex-1]).updateList(voList);
			_tabsManager.labelTxts[tabIndex-1].text = label;
		}
		
		/**
		 * 显示某个标签
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
				
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_SHOP_MODE,BagSource.SHOP_FIX);
				ModuleCharacter(ModuleManager.moduleCharacter).getCharacterWindow().open();
				if(ModuleManager.bagModule.getBagWin().isOpen==false){
					ModuleManager.bagModule.getBagWin().open();
				}
				ModuleManager.bagModule.getBagWin().open();
				UIManager.centerMultiWindows(ModuleCharacter(ModuleManager.moduleCharacter).getCharacterWindow(),ModuleManager.bagModule.getBagWin());
				ModuleCharacter(ModuleManager.moduleCharacter).getCharacterWindow().setToTop();
			}
//			else{
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_FIX_CLICK,false);
//			}
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
//				_mouseMode = SELL;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_SHOP_MODE,BagSource.SHOP_SELL);
				var bagWindow:BagWindow=ModuleManager.bagModule.getBagWin();
				if(bagWindow.isOpen == false){
					bagWindow.open();
					UIManager.centerMultiWindows(this,bagWindow,5);
				}
			}
//			else
//				_buyBtn.selected=true;
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
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USER_SHOP_MODE,BagSource.SHOP_BUY);
		
//				_mouseMode = BUY;
			}
//			else
//				_sellBtn.selected=true;
		}
		
		/**
		 * 全部修理 
		 * @param event
		 * 
		 */
		private function onFixAllBtnClick(event:MouseEvent=null):void
		{
			ModuleShop.instance.fix.fixAll();
		}
		
	}
}