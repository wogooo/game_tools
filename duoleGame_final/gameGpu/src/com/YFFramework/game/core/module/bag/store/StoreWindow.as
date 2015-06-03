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
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.bag.backPack.BagWindow;
	import com.YFFramework.game.core.module.bag.baseClass.MoveGrid;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.storage.CSortDepotReq;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
		private var _mc:Sprite;
		private var _alert:Alert;
		
		private var _toggleStore:TabsManager;//五项数据交换控制:全部，消耗，装备，材料
		
		private var _sortBtn:Button;
		private var _tabsManager:TabsManager;
		
		private var _stores:StoreCollection;
		
		private var _page1:ToggleButton;
		private var _page2:ToggleButton;
		private var _page3:ToggleButton;
		private var _page4:ToggleButton;
		
//		private var _bag:BagWindow;
		
		private var _currentPage:int;
		private var _lastTabIndex:int;
		
		private var _clearAll:Boolean;
		
		private var initGrid:Boolean;
		
		private var _btnAry:Array;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function StoreWindow()
		{
			_mc=initByArgument(415,455,"bagUI_store",WindowTittleName.Storage);
			setContentXY(29,40);
			
			_sortBtn= Xdis.getChild(_mc,"tidy_button");
			_sortBtn.addEventListener(MouseEvent.CLICK,sortStore);
			
			var storeSprite:Sprite=Xdis.getChild(_mc,"storeCollection");
			_stores=new StoreCollection(TypeProps.STORAGE_TYPE_DEPOT,storeSprite);
			
			_page1= Xdis.getChild(_mc,"page1_toggleButton");
			_page1.addEventListener(Event.CHANGE,onPage1);
			
			_page2= Xdis.getChild(_mc,"page2_toggleButton");
			_page2.addEventListener(Event.CHANGE,onPage2);
			
			_page3= Xdis.getChild(_mc,"page3_toggleButton");
			_page3.addEventListener(Event.CHANGE,onPage3);
			
			_page4= Xdis.getChild(_mc,"page4_toggleButton");
			_page4.addEventListener(Event.CHANGE,onPage4);
			
			_btnAry=[,_page1,_page2,_page3,_page4];
			
			_tabsManager = new TabsManager();
			for(var i:int=1;i<5;i++){
				_tabsManager.add(Xdis.getChild(Object(_mc).tab,"tab"+i),storeSprite);
			}
			_tabsManager.addEventListener(TabsManager.INDEX_CHANGE,onTabIndexChange);
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function open():void
		{
			super.open();
			
			_lastTabIndex=0;
			
			_page1.selected=true;
			
			_stores.initGrid();
			_tabsManager.switchToTab(BagSource.TAB_ALL);
			
			updateDepotNum();
		}
		
		/**
		 * 更新仓库开启数量并刷新仓库 
		 * @param num
		 * 
		 */		
		public function setDepotNum():void
		{
			updateDepotNum();
			_stores.updateTab(_tabsManager.nowIndex,_currentPage);
		}
		
		/**
		 * 显示仓库数量变化 
		 * 
		 */		
		public function updateDepotNum():void
		{
			if(_stores && BagStoreManager.instantce.getAllDepotArray())
			{
				Object(_mc).storeSpace.text=BagStoreManager.instantce.getAllDepotArray().length+"/"+BagStoreManager.instantce.getDepotNum();
			}
		}
		
		public function onTabIndexChange(event:Event=null):void
		{			
			setDepotContent(_tabsManager.nowIndex);
		}
		
		
		public function getTabIndex():int
		{
			return _tabsManager.nowIndex;
		}
		
//		public function setBag(bag:BagWindow):void
//		{
//			_bag=bag;
//		}
		
		public function updatePropsNum(propsId:int):void
		{
			var pos:int=PropsDyManager.instance.getPropsPosFromDepot(propsId);
			_stores.updateGridNum(pos);
		}
		
		public function delDepotGrid(pos:int):void
		{
			_stores.delGrid(_tabsManager.nowIndex,_currentPage,pos);
		}
		
		override public function close(event:Event=null):void
		{
			super.close(event);
			BagSource.openStore=false;
		}
		//======================================================================
		//        private function
		//======================================================================
		private function btnsDisable(index:int):void
		{
			for(var i:int=1;i<=4;i++)
			{
				if(i != index)
					ToggleButton(_btnAry[i]).selected=false;
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		private function setDepotContent(index:int):void
		{	
			if(_lastTabIndex != index)
			{
				_stores.updateTab(index,_currentPage);
			}
			else
			{
				if(_clearAll)
				{
					_stores.updateAllGrid(index,_currentPage);
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
			//_sortBtn.disableAndAbleLater(5000,"$*",1);
			_sortBtn.STAddCDTime(5000,true);
			var msg:CSortDepotReq=new CSortDepotReq();
			msg.append=BagSource.SORT;
			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSortDepotReq,msg);
		}
		
		private function onPage1(e:Event=null):void
		{	
			if(_page1.selected)
			{
				_currentPage=BagSource.PAGE1;
				flipPage();
				btnsDisable(1);
			}				
		}
		
		private function onPage2(e:Event):void
		{	
			if(_page2.selected)
			{
				_currentPage=BagSource.PAGE2;
				flipPage();
				btnsDisable(2);
			}
			
		}
		
		private function onPage3(e:Event):void
		{	
			if(_page3.selected)
			{
				_currentPage=BagSource.PAGE3;
				flipPage();
				btnsDisable(3);
			}	
		}
		
		private function onPage4(e:Event):void
		{	
			if(_page4.selected)
			{
				_currentPage=BagSource.PAGE4;
				flipPage();
				btnsDisable(4);
			}
			
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