package com.YFFramework.game.core.module.market.view.window
{
	/**
	 * 求购物品窗口（包括：求购物品、我的求购）
	 * @version 1.0.0
	 * creation time：2013-6-1 下午4:00:07
	 * 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.panel.purchase.MyPurchaseLogPanel;
	import com.YFFramework.game.core.module.market.view.panel.purchase.PurchaseItemPanel;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PurchaseItemWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const tabMax:int=2;
		
		private var _mc:Sprite;
		private var _tabs:TabsManager;
		
		private var _purchasePanel:PurchaseItemPanel;
		private var _myPurchasePanel:MyPurchaseLogPanel;
		
//		private var _siftWindow:SiftItemWindow;
		private static var _instance:PurchaseItemWindow;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PurchaseItemWindow()
		{
			_instance = this;
			_mc = initByArgument(387,355,"purchaseWindow",WindowTittleName.purchaseTitle);
			setContentXY(27,37);
			
//			_siftWindow=new SiftItemWindow(this);
			
			_tabs = new TabsManager();
			var _toogleBtn:MovieClip = Object(_mc).tabs;
			
			_purchasePanel=new PurchaseItemPanel(Xdis.getChild(_mc,"tabView1"));
			_myPurchasePanel=new MyPurchaseLogPanel(Xdis.getChild(_mc,"tabView2"));
			
			for(var i:int=1;i<=tabMax;i++)
			{
				var temp:MovieClip = Object(_mc)["tabView"+i];
				_tabs.add(Xdis.getChild(_toogleBtn,"tab"+i),temp);
			}
			
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
			_closeButton.removeEventListener(MouseEvent.CLICK,close);
			_closeButton.addEventListener(MouseEvent.CLICK,closeTwoWindow);
			
			YFEventCenter.Instance.addEventListener(MarketEvent.MOVE_TO_PURCHASE_ITEM,moveToPurchasePanel);
			YFEventCenter.Instance.addEventListener(MarketEvent.RESET_PURCHASE_PANEL,clearPurchasePanel);
		}
		
		//======================================================================
		//        public function
		//======================================================================
//		override public function open():void
//		{
//			super.open();
//			openPanel(1);
//		}
		/**
		 * 打开指定的面板
		 * @param index
		 * 
		 */		
		public function openPanel(index:int):void
		{
			_tabs.switchToTab(index);
		}
		
//		public function getSiftWindow():SiftItemWindow
//		{
//			return _siftWindow;
//		}
		
		public function getTabIndex():int
		{
			return _tabs.nowIndex;
		}
		
		public function resetPurchaseItemPanel():void
		{
			_purchasePanel.resetPanel();
		}
		
		public function resetSiftWin():void
		{
			SiftItemWindow.instance.resetPanel();
		}
		
		/** 我的求购列表
		 */		
		public function myPurchasetemsList():void
		{
			_myPurchasePanel.updateList();
		}
		
		/**
		 * 同时关闭求购物品和筛选物品面板 
		 * @param event
		 * 
		 */		
		public function closeTwoWindow(event:Event=null):void
		{
			this.close();
			if(SiftItemWindow.instance.isOpen)
				SiftItemWindow.instance.close();
			SiftItemWindow.instance.resetPanel();
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onTabChange(e:Event=null):void
		{
			if(_tabs.nowIndex == 1)
			{
				if(SiftItemWindow.instance.isOpen == false)
				{
					SiftItemWindow.instance.open();
				}
				UIManager.centerMultiWindows(this,SiftItemWindow.instance);
				if(MarketDyManager.instance.myPurchaseItemsNum == MarketSource.MY_TOTAL_ITEMS)
					NoticeManager.setNotice(NoticeType.Notice_id_1605);
				this.switchToTop();
//				_purchasePanel.resetPanel();
				YFEventCenter.Instance.dispatchEventWith(MarketEvent.CMyWantListNumber);
			}
			else
			{
				if(SiftItemWindow.instance.isOpen)
				{
					SiftItemWindow.instance.close();
//					_siftWindow.resetPanel();
					UIManager.tweenToCenter(this);
				}
				
				YFEventCenter.Instance.dispatchEventWith(MarketEvent.CMyWantList);
			}
		}
		
		private function moveToPurchasePanel(e:YFEvent):void
		{
			_purchasePanel.moveToPurchaseItem(e.param as ItemDyVo);
		}
		
		private function clearPurchasePanel(e:YFEvent):void
		{
			_purchasePanel.resetPanel();
		}

		public static function get instance():PurchaseItemWindow
		{
			if(_instance == null) _instance =new PurchaseItemWindow();
			return _instance;
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 