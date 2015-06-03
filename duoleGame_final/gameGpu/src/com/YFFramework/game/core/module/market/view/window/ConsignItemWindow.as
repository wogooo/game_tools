package com.YFFramework.game.core.module.market.view.window
{
	/**
	 * 寄售物品窗口(包括：寄售物品、寄售货币、我的寄售)
	 * @version 1.0.0
	 * creation time：2013-5-30 下午12:04:30
	 * 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.backPack.BagWindow;
	import com.YFFramework.game.core.module.market.data.manager.MarketConfigBasicManager;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.panel.consign.ConsignItemPanel;
	import com.YFFramework.game.core.module.market.view.panel.consign.ConsignMoneyPanel;
	import com.YFFramework.game.core.module.market.view.panel.consign.MyConsignLogPanel;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ConsignItemWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var tabMax:int=2;
		
		private var _mc:Sprite;
		private var _tabs:TabsManager;
		
		/**寄售物品 
		 */		
		private var _consignItemPanel:ConsignItemPanel;
		
		/**寄售货币 
		 */		
//		private var _consignMoneyPanel:ConsignMoneyPanel;
		
		/**我的寄售  */		
		private var _myConsignLogPanel:MyConsignLogPanel;
		
		private static var _instance:ConsignItemWindow;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ConsignItemWindow()
		{
			_mc = initByArgument(387,350,"consignWindow",WindowTittleName.consignTitle);
			setContentXY(27,37);
			
			_tabs = new TabsManager();
			var _toogleBtn:MovieClip = Object(_mc).tab_sp;
			
			_consignItemPanel=new ConsignItemPanel(Xdis.getChild(_mc,"tabView1"));
//			_consignMoneyPanel=new ConsignMoneyPanel(Xdis.getChild(_mc,"tabView2"));
			_myConsignLogPanel=new MyConsignLogPanel(Xdis.getChild(_mc,"tabView2"));
			
			for(var i:int=1;i<=tabMax;i++)
			{
				var temp:MovieClip = Object(_mc)["tabView"+i];
				_tabs.add(Xdis.getChild(_toogleBtn,"tab"+i),temp);
			}
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onTabChange); 
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 打开指定的面板
		 * @param index
		 */		
		public function openPanel(index:int):void
		{
			_tabs.switchToTab(index);
		}
		
		public function getTabIndex():int
		{
			return _tabs.nowIndex;
		}
		
		/**
		 * 已经关闭了寄售模式 ,并且背包回复正常模式：解锁;
		 * @param event
		 * 
		 */		
		override public function close(event:Event=null):void
		{
			super.close(event);
			
			changeBagStatus(false);
			
			var bag:BagWindow=ModuleManager.bagModule.getBagWin();
			if(bag.isOpen)
				bag.close();
			
			_consignItemPanel.resetPanel();
//			_consignMoneyPanel.resetPanel();
			
			//针对寄售物品
			MarketSource.lastLockPos=0;
			MarketSource.curLockPos=0;
			
			MarketSource.ConsignmentStatus=false;
			
		}
		
		public function consignItem(item:ItemDyVo):void
		{
			//回头要加上判断，是否已满10条信息，和能不能寄售
			var myCNum:int=MarketDyManager.instance.myConsignItemsNum;
//			trace("寄售数量",myCNum)
			if(myCNum == MarketSource.MY_TOTAL_ITEMS)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1605);
				return;
			}
			else
			{
				var tmpId:int;
				if(item.type == TypeProps.ITEM_TYPE_EQUIP)
				{
					tmpId=EquipDyManager.instance.getEquipInfo(item.id).template_id;
				}
				else
				{
					tmpId=PropsDyManager.instance.getPropsInfo(item.id).templateId;
				}
				if(MarketConfigBasicManager.Instance.getItemInfo(item.type,tmpId) == null)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1611);
					return;
				}
			}
			
			if(isOpen == true && _tabs.nowIndex == 1)//寄售物品时打开的，并且在第一个标签
			{
				_consignItemPanel.consignItem(item);
				
				var lastPos:int=MarketSource.lastLockPos;
				if(lastPos > 0 && lastPos != item.pos)
				{
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.UnlockItem,MarketSource.lastLockPos);
				}
				
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.LockItem,item.pos);
				
				//下面两句必须是这个顺序，要不然会找不到这个道具
				MarketSource.curLockPos=item.pos;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);//告诉各个面板把锁定的数量减去
				
				MarketSource.lastLockPos=item.pos;
			}
		}
		
		/** 清空寄售物品窗口下的寄售界面 
		 */		
		public function resetConsignItemPanel():void
		{
			_consignItemPanel.resetPanel();
		}
		
		/** 清空寄售货币面板 
		 */		
//		public function resetConsignMoneyPanel():void
//		{
//			_consignMoneyPanel.resetPanel();
//		}
		
		/** 更新我的寄售
		 */		
		public function myConsignItemsList():void
		{
			_myConsignLogPanel.updateList();
		}
		//======================================================================
		//        private function
		//======================================================================
		/**
		 * 切换不同状态初始化：寄售模式或非寄售模式 
		 * @param status
		 * 
		 */		
		private function changeBagStatus(status:Boolean):void
		{
			MarketSource.ConsignmentStatus=status;
			if(status)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.LockItem,MarketSource.curLockPos);
			}
			else
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.UnlockItem,MarketSource.curLockPos);
			}
		}
		
		private function openOrCloseBag(open:Boolean):void
		{
			var bag:BagWindow=ModuleManager.bagModule.getBagWin();
			this.switchToTop();
			if(open)
			{			
				if(bag.isOpen == false)
					bag.open();			
				UIManager.centerMultiWindows(this,bag);
			}
			else
			{
				if(bag.isCloseing==false)
					bag.close();
				if(this.isOpen)
					UIManager.tweenToCenter(this);
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onTabChange(e:Event=null):void
		{			
			if(_tabs.nowIndex == 1)//寄售物品界面
			{
				changeBagStatus(true);
				openOrCloseBag(true);
				YFEventCenter.Instance.dispatchEventWith(MarketEvent.CMySaleListNumber);
			}
			else if(_tabs.nowIndex == 2)//寄售货币
			{	
				changeBagStatus(false);
				openOrCloseBag(true);
				var myCNum:int=MarketDyManager.instance.myConsignItemsNum;
				if(myCNum == MarketSource.MY_TOTAL_ITEMS)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1605);
				}
			}
			else//我的寄售界面
			{
				YFEventCenter.Instance.dispatchEventWith(MarketEvent.CMySaleList);
				
				changeBagStatus(false);
				openOrCloseBag(false);
			}
		}

		public static function get instance():ConsignItemWindow
		{
			if(_instance == null) _instance=new ConsignItemWindow();
			return _instance;
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 