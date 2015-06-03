package com.YFFramework.game.core.module.bag.backPack
{
	
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.baseClass.MoveGrid;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.bag.source.JInputWindow;
	import com.YFFramework.game.core.module.bag.store.StoreWindow;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.shop.view.ShopWindow;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.trade.model.LockItemDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.hero.SUseItem;
	import com.msg.storage.CSortPackReq;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午1:58:26
	 * 
	 */
	public class BagWindow extends Window
	{
		
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:Sprite;
		private var _storeWindow:StoreWindow;
//		private var _shopWindow:ShopWindow;
		
		private var _tabsManager:TabsManager;
		
		private var _sortBtn:Button;
		private var _shopBtn:Button;
		private var _storeBtn:Button;
		
		private var _page1:ToggleButton;
		private var _page2:ToggleButton;
		private var _page3:ToggleButton;
		private var _page4:ToggleButton;
		
		private var _payTxt:TextField;
		
		/** 魔钻 */		
		private var _money:TextField;
		/** 银币 */		
//		private var _currency:TextField;
		/** 礼券 */		
		private var _giftCertificate:TextField;
		/** 银锭 */		
		private var _boundCurrency:TextField;
		
		private var _bags:BagCollection;
		private var _currentPage:int=0;
		private var _lastTabIndex:int=BagSource.TAB_ALL;	
		private var _clearAll:Boolean;
		private var _btnAry:Array;

		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagWindow()
		{
			_mc=initByArgument(430,500,"bagUI_bag",WindowTittleName.Bag,true,DyModuleUIManager.bagWinBg);
			setContentXY(28,40);
			
			var bagSprite:Sprite=Xdis.getChild(_mc,"bagCollection");
			_bags=new BagCollection(TypeProps.STORAGE_TYPE_PACK,bagSprite);
			
			_tabsManager = new TabsManager();
			for(var i:int=1;i<=5;i++){
				_tabsManager.add(Xdis.getChild(Object(_mc).tab,"tab"+i),bagSprite);
			}
//			_tabsManager.switchToTab(PackSource.TAB_ALL);
			_tabsManager.addEventListener(TabsManager.INDEX_CHANGE,onPackTabChange);
			
			_money=Object(_mc).money;
//			_currency=Object(_mc).currency;
			_giftCertificate=Object(_mc).giftCertificate;
			_boundCurrency=Object(_mc).boundCurrency;
			
			Xtip.registerTip(_money,NoticeUtils.getStr(NoticeType.Notice_id_100013));
//			Xtip.registerTip(_currency,NoticeUtils.getStr(NoticeType.Notice_id_100014));
			Xtip.registerTip(_giftCertificate,NoticeUtils.getStr(NoticeType.Notice_id_100015));
			Xtip.registerTip(_boundCurrency,NoticeUtils.getStr(NoticeType.Notice_id_100016));

			_shopBtn= Xdis.getChild(_mc,"shop_button");
			_shopBtn.addEventListener(MouseEvent.CLICK,openShop);
			
			_storeBtn=Xdis.getChild(_mc,"store_button");
			_storeBtn.addEventListener(MouseEvent.CLICK,openStore);
			
			_sortBtn= Xdis.getChild(_mc,"tidy_button");
			_sortBtn.addEventListener(MouseEvent.CLICK,sortPack);

			_page1= Xdis.getChild(_mc,"page1_toggleButton");
			_page1.alwaysSelectedEffect=true;
			_page1.addEventListener(Event.CHANGE,onPage1);
			
			_page2= Xdis.getChild(_mc,"page2_toggleButton");
			_page2.alwaysSelectedEffect=true;
			_page2.addEventListener(Event.CHANGE,onPage2);
			
			_page3= Xdis.getChild(_mc,"page3_toggleButton");
			_page3.alwaysSelectedEffect=true;
			_page3.addEventListener(Event.CHANGE,onPage3);
			
			_page4= Xdis.getChild(_mc,"page4_toggleButton");
			_page4.alwaysSelectedEffect=true;
			_page4.addEventListener(Event.CHANGE,onPage4);
			
			_btnAry=[,_page1,_page2,_page3,_page4];
			
			_payTxt=Xdis.getChild(_mc,"pay");
			_payTxt.addEventListener(MouseEvent.CLICK,onPay);
			
			_storeWindow=new StoreWindow();
//			_storeWindow.setBag(this);

		}

		//======================================================================
		//        public function
		//======================================================================
		public function shopModeChange(mode:int):void
		{
			BagSource.shopMode=mode;
		}
		
//		public function mendMode(isMend:Boolean):void
//		{
//			BagSource.shopMend=isMend;
//		}
		
		/** 
		 * 交易或寄售模式
		 */		
		public function lockMode():void
		{
			updateMoney();
			
			_bags.boundStatus();//里面已经判断了是不是在交易或寄售模式下
		
			var tradeMode:Boolean=TradeDyManager.isTrading;
			var consignMode:Boolean= MarketSource.ConsignmentStatus;
			if(tradeMode == false && consignMode == false)//只有都不是两个状态，才能解锁!!!
			{
				//交易解锁格子
				var lockItems:Array=TradeDyManager.Instance.getMyLockItem();
				for each(var item:LockItemDyVo in lockItems)
				{
					_bags.setLockStatusGrid(item.pos,false);
				}
				
				//寄售解锁格子
				var lockPos:int=MarketSource.curLockPos;
				_bags.setLockStatusGrid(lockPos,false);
				
				if(_sortBtn.isCDing())	_sortBtn.enabled=false;
				else	_sortBtn.enabled=true;
				
				updatePackEquips(true);//把背包里职业不符的装备变红
			}
			else if(tradeMode || consignMode)
			{
				_sortBtn.enabled=false;
				//去掉背包里职业不同的红色
				updatePackEquips(false);
			}
		}
		
		public function setGridLockStatus(pos:int,lock:Boolean):void
		{
			_bags.setLockStatusGrid(pos,lock);
		}	
		
		/** 获取背包格子单元UI 
		 */
		public function getBagMoveGrid(pos:int):MoveGrid
		{
			return _bags.getMoveGrid(pos);
		}
		
		//*****************************背包************************//
		/** 
		 * 重写open方法,里面包括了交易、寄售模式
		 */		
		override public function open():void
		{
			super.open();
			
			_lastTabIndex=0;
			
			_bags.initGrid();
			_tabsManager.switchToTab(BagSource.TAB_ALL);
			
			_page1.selected=true;
			
			updatePackNum();
			updateMoney();
			
			lockMode();
			
			checkShopBtn();
		}
		
		override public function close(event:Event=null):void
		{
			ModuleManager.moduleShop.closeShop();
			closeTo(UI.stage.stageWidth-495,UI.stage.stageHeight-50,0.02,0.04);
			
			_storeWindow.close();
			if(JInputWindow.Instance().isOpen)
				JInputWindow.Instance().close();
			
			handleHideGuide();
		}
		
		/**
		 * 不仅更新数字，还要更新界面 
		 */		
		public function setPackGridNum():void
		{
			_bags.updateTab(_tabsManager.nowIndex,_currentPage);
			updatePackNum();
		}
		
		/**
		 * 更新背包里所有装备的状态 ,是否显示职业不符装备的红色蒙版
		 * true-显示
		 * false-不显示
		 */		
		public function updatePackEquips(show:Boolean):void
		{
			_bags.changeEquipStatus(show);
			checkShopBtn();
		}
		
		/**
		 * 更新背包容量数字 
		 */		
		public function updatePackNum():void
		{
			Object(_mc).bagSpace.text=BagStoreManager.instantce.getAllPackArray().length+"/"+BagStoreManager.instantce.getPackNum();
		}
		
		public function onPackTabChange(event:Event=null):void
		{	
			setPackContent(_tabsManager.nowIndex);	
		}
		
		/**
		 * 先刷背包里道具的数量，如果没有就刷新仓库的数量(仅刷新数量)
		 * @param propsId
		 * 
		 */		
		public function changePropsNum(propsId:int):void
		{
			var pos:int=PropsDyManager.instance.getPropsPosFromBag(propsId);
			if(pos > 0)
			{
				_bags.updateGridNum(pos);
			}
			else
			{
				_storeWindow.updatePropsNum(propsId);
			}
		}
		
		public function delGrid(type:int,id:int):void
		{
			var pos:int=0
			if(type == TypeProps.ITEM_TYPE_PROPS)
			{
				pos=PropsDyManager.instance.getPropsPosFromBag(id);
				if(pos == 0)
					pos= PropsDyManager.instance.getPropsPosFromDepot(id);
			}
			else
			{
				pos=EquipDyManager.instance.getEquipPosFromBag(id);
				if(pos == 0)
					pos = EquipDyManager.instance.getEquipPosFromDepot(id);
			}
			
			if(pos >= 101 && pos < 300)
			{
				_bags.delGrid(_tabsManager.nowIndex,_currentPage,pos);
				BagStoreManager.instantce.delPackList(pos);
				updatePackNum();
			}
			else if(pos >= 301)
			{
				_storeWindow.delDepotGrid(pos);
				BagStoreManager.instantce.delDepotList(pos);
				setDepotGridNum();
			}
		}
		
		/**
		 * 调用cd动画的方法 
		 * @param tabIndex
		 * @param page
		 * @param packArr
		 * 
		 */		
		public function playCdAnimation(packArr:Array):void
		{
			_bags.playCd(packArr);
		}
		
		public function getPackTabIndex():int
		{
			return _tabsManager.nowIndex;
		}
		
		public function changePropsEquipBound(type:int,id:int):void
		{
			var pos:int;
			if(type == TypeProps.ITEM_TYPE_EQUIP)
				pos=EquipDyManager.instance.getEquipPosFromBag(id);
			else
				pos=PropsDyManager.instance.getPropsPosFromBag(id);
			_bags.changePropsEquipBound(type,pos);
		}
		
		/** 播放开启背包关闭格子cd */
		public function playCloseGridCd():void
		{
			var openNum:int=BagStoreManager.instantce.getPackNum();
			var start:int=35-((_currentPage+1)*35-openNum);
			if(start < 35)
				_bags.playCloseGridCd(start);
		}
		
		/*******************************************仓库***********************************************/
		public function setDepotGridNum():void
		{			
			_storeWindow.setDepotNum();	
		}
		
		public function setDepotContent():void
		{
			_storeWindow.onTabIndexChange();
		}
		
		public function getDepotTabIndex():int
		{
			return _storeWindow.getTabIndex();
		}

		public function setDepotClearAll(clearAll:Boolean):void
		{
			_storeWindow.clearAll=clearAll;
		}
		
		public function getDepotClearAll():Boolean
		{
			return _storeWindow.clearAll;
		}
		
		public function updateMoney():void
		{
			_money.text=DataCenter.Instance.roleSelfVo.diamond.toString();
//			_currency.text=DataCenter.Instance.roleSelfVo.silver.toString();
			_giftCertificate.text=DataCenter.Instance.roleSelfVo.coupon.toString();
			_boundCurrency.text=DataCenter.Instance.roleSelfVo.note.toString();
		}
		
		public function useItemResp(msg:SUseItem):void
		{
			if(msg.itemTemplateId > 0)
			{
				var template:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(msg.itemTemplateId);
				var posArr:Array=BagStoreManager.instantce.findAllSameCdType(template.cd_type);
				_bags.playCd(posArr);
			}
			
		}
		
		//======================================================================
		//        private function
		//======================================================================
		private function checkShopBtn():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.career == TypeRole.CAREER_NEWHAND)
				_shopBtn.enabled=false;
			else
				_shopBtn.enabled=true;
		}
		
		private function setPackContent(index:int):void
		{
			if(_lastTabIndex != index)//这里其实不更新什么就是切换标签
			{
				_bags.updateTab(index,_currentPage);
			}
			else
			{
				if(clearAll)
				{
					_bags.updateAllGrid(index,_currentPage);
				}
				else
				{
					_bags.updateSomeGrid(index,_currentPage);
				}
			}
			
			_lastTabIndex=index;
			
			updatePackNum();				
		}
		
		/**
		 * 专门处理页面切换的方法 
		 * 
		 */		
		private function flipPage():void
		{
			_bags.updateTab(_tabsManager.nowIndex,_currentPage);
		}
		
		private function onClose():void{
			ModuleManager.moduleShop.closeShop();
			if(_storeWindow.isOpen)
				_storeWindow.close();
		}
		
		
		//======================================================================
		//        event handler
		//======================================================================
		private function sortPack(e:MouseEvent):void
		{
			if(TradeDyManager.isTrading == false && MarketSource.ConsignmentStatus == false)
			{
				//_sortBtn.disableAndAbleLater(5000,"$*",1);
				_sortBtn.STAddCDTime(5000,true);
				var msg:CSortPackReq=new CSortPackReq();
				msg.append=BagSource.SORT;
				YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSortPackReq,msg);
			}
			
		}
		
		private function openShop(e:MouseEvent):void
		{
			if(ModuleManager.moduleShop.view.isOpen==false)//打开商店
			{
				ModuleManager.moduleShop.openShopByID(1);
				var shopWindow:ShopWindow=ModuleManager.moduleShop.view;
				UIManager.centerMultiWindows(shopWindow,this,5);
//				_storeBtn.enabled=false;
			}
			else
			{
				ModuleManager.moduleShop.closeShop();
				UIManager.tweenToCenter(this);
//				_storeBtn.enabled=true;
			}
		}
		
		private function openStore(e:MouseEvent):void
		{
			if(_storeWindow.isOpen == false)
			{
				_storeWindow.open();
				UIManager.centerMultiWindows(_storeWindow,this);
				BagSource.openStore=true;
			}
			else
			{
				_storeWindow.close();
				if(ModuleManager.moduleShop.view.isOpen == false)
					UIManager.tweenToCenter(this);
				BagSource.openStore=false;
			}
		}
		
		//充值
		private function onPay():void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.Recharge);
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

		private function btnsDisable(index:int):void
		{
			for(var i:int=1;i<=4;i++)
			{
				if(i != index)
					ToggleButton(_btnAry[i]).selected=false;
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
		
		/**引导关闭 窗口
		 */
		public function handleGuideCloseBag():Boolean
		{
			if(NewGuideStep.BagPackGuideStep==NewGuideStep.BagPackCloseBagWindow)
			{
//				var pt:Point=UIPositionUtil.getPosition(_closeButton,this);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
				var pt:Point=UIPositionUtil.getUIRootPosition(_closeButton);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,_closeButton);
				NewGuideStep.BagPackGuideStep=NewGuideStep.BagPackNone;
				return true;
			}
			return false ;
		}
		/**隐藏引导箭头  关闭按钮时候触发
		 */ 
		private function handleHideGuide():Boolean
		{
			if(NewGuideStep.BagPackGuideStep==NewGuideStep.BagPackNone)
			{
				NewGuideMovieClipWidthArrow.Instance.hide();
				NewGuideStep.BagPackGuideStep=-1;
				NewGuideManager.DoGuide();
				return true;
			}
			return false;
		}
	
		override public function getNewGuideVo():*
		{
			var trigger:Boolean=false;
			trigger=handleGuideCloseBag();
			if(!trigger)
			{
				trigger=handleHideGuide();
			}
			return trigger;
		}
	}
} 