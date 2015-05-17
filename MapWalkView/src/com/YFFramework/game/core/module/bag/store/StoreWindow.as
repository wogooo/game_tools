package com.YFFramework.game.core.module.bag.store
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午5:07:07
	 * 
	 */
	
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.BagStoreManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.backPack.BagWindow;
	import com.YFFramework.game.core.module.bag.baseClass.MoveGrid;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.storage.CSortDepotReq;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class StoreWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		private var _alert:Alert;
		
		private var _toggleStore:TabsManager;//五项数据交换控制:全部，消耗，装备，材料
		
		private var _sortBtn:Button;
		private var _tabsManager:TabsManager;
		
		private var _stores:StoreCollection;
		
		private var _page1:Button;
		private var _page2:Button;
		private var _page3:Button;
		private var _page4:Button;
		
		private var _bag:BagWindow;
		
		private var _currentPage:int;
		private var _lastTabIndex:int;
		
		private var _clearAll:Boolean;
		
		private var initGrid:Boolean;
		
		private var btnArr:Array;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function StoreWindow()
		{
			setSize(387,520);
			this.title="仓 库";
			
			_mc = ClassInstance.getInstance("bagUI_store");
			content = _mc;

			AutoBuild.replaceAll(_mc);
			_sortBtn= Xdis.getChild(_mc,"tidy_button");
			_sortBtn.addEventListener(MouseEvent.CLICK,sortStore);
			
			_stores=new StoreCollection(TypeProps.STORAGE_TYPE_DEPOT);
			_stores.x=45;
			_stores.y=70;
			addChild(_stores);
			
			_page1= Xdis.getChild(_mc,"page1_button");
			_page1.addEventListener(MouseEvent.CLICK,onPage1);
			
			_page2= Xdis.getChild(_mc,"page2_button");
			_page2.addEventListener(MouseEvent.CLICK,onPage2);
			
			_page3= Xdis.getChild(_mc,"page3_button");
			_page3.addEventListener(MouseEvent.CLICK,onPage3);
			
			_page4= Xdis.getChild(_mc,"page4_button");
			_page4.addEventListener(MouseEvent.CLICK,onPage4);
			
			btnArr=[_page1,_page2,_page3,_page4];
			
			_tabsManager = new TabsManager();
			for(var i:int=1;i<5;i++){
				_tabsManager.add(Xdis.getChild(_mc.tab,"tab"+i),_stores);
			}
			_tabsManager.addEventListener(TabsManager.INDEX_CHANGE,onTabIndexChange);
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function initOpenDepot():void
		{
			if(isOpen)
			{
				_currentPage=PackSource.PAGE1;
				_lastTabIndex=0;
				initGrid=true;
				
				BtnsEnabled();
				_page1.enabled=false;
				
				_tabsManager.switchToTab(PackSource.TAB_ALL);
				updateDepotNum();
			}
		}
		
		public function openGridsNum(num:int):void
		{
			_stores.updateTab(_tabsManager.nowIndex,_currentPage);
			updateDepotNum();
		}
		
		public function onTabIndexChange(event:Event=null):void
		{			
			setDepotContent(_tabsManager.nowIndex);
		}
		
		
		public function getTabIndex():int
		{
			return _tabsManager.nowIndex;
		}
		
		public function setBag(bag:BagWindow):void
		{
			_bag=bag;
		}
		
		override public function close(event:Event=null):void
		{
			super.close(event);
			PackSource.openStore=false;
			_currentPage=PackSource.PAGE1;
		}
		//======================================================================
		//        private function
		//======================================================================
		/**
		 * 显示背包数量变化 
		 * 
		 */		
		private function updateDepotNum():void
		{
			if(_stores && BagStoreManager.instantce.getAllDepotArray())
			{
				_mc.storeSpace.text=BagStoreManager.instantce.getAllDepotArray().length+"/"+BagStoreManager.instantce.getDepotNum();
			}
		}
		
		private function BtnsEnabled():void
		{
			for each(var btn:Button in btnArr)
			{
				btn.enabled=true;
			}
		}
		
		private function BtnsUnEnabled(i:int):void
		{
			btnArr[i-1].enabled=false;
		}
		
		//======================================================================
		//        event handler
		//======================================================================
		
		private function setDepotContent(index:int):void
		{	
			if(_lastTabIndex != index)
			{
				onPage1();
				if(initGrid)
				{
					_stores.updateAllGrid(index,_currentPage);
					initGrid=false;
				}
				_stores.updateTab(index,_currentPage);
			}
			else
			{
				if(_clearAll)
				{
					_stores.updateAllGrid(index,_currentPage);
					_stores.updateTab(index,_currentPage);
				}
				else
				{
					_stores.updateSomeGrid(index,_currentPage);
				}
			}
			_lastTabIndex=index;
			updateDepotNum();
		}
		
		/**
		 * 专门处理页面切换的方法 
		 * 
		 */		
		private function flipPage():void
		{
			_stores.updateTab(_tabsManager.nowIndex,_currentPage);
		}
		
		private function sortStore(e:MouseEvent):void
		{
			_sortBtn.disableAndAbleLater(5000,"*",1);
			var msg:CSortDepotReq=new CSortDepotReq();
			msg.append=PackSource.SORT;
			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSortDepotReq,msg);
		}
		
		private function onPage1(e:MouseEvent=null):void
		{
			BtnsEnabled();
			_currentPage=PackSource.PAGE1;
			flipPage();
			BtnsUnEnabled(1);
		}
		
		private function onPage2(e:MouseEvent):void
		{
			BtnsEnabled();
			_currentPage=PackSource.PAGE2;
			flipPage();
			BtnsUnEnabled(2);
		}
		
		private function onPage3(e:MouseEvent):void
		{
			BtnsEnabled();
			_currentPage=PackSource.PAGE3;
			flipPage();
			BtnsUnEnabled(3);
		}
		
		private function onPage4(e:MouseEvent):void
		{
			BtnsEnabled();
			_currentPage=PackSource.PAGE4;
			flipPage();
			BtnsUnEnabled(4);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		public function set clearAll(value:Boolean):void
		{
			_clearAll = value;
		}

		public function get clearAll():Boolean
		{
			return _clearAll;
		}

		
	}
} 