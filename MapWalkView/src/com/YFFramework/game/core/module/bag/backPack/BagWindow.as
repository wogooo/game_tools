package com.YFFramework.game.core.module.bag.backPack
{
	
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.manager.BagStoreManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.baseClass.MoveGrid;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.YFFramework.game.core.module.bag.store.StoreWindow;
	import com.YFFramework.game.core.module.shop.ShopWindow;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.SUseItem;
	import com.msg.storage.CSortPackReq;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

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
		private var _mc:MovieClip;
		private var _storeWindow:StoreWindow;
		private var _shopWindow:ShopWindow;
		
		private var _tabsManager:TabsManager;
		
		private var _sortBtn:Button;
		private var _shopBtn:Button;
		private var _storeBtn:Button;
		
		private var _page1:Button;
		private var _page2:Button;
		private var _page3:Button;
		private var _page4:Button;
		
		private var _money:TextField;
		private var _currency:TextField;
		private var _giftCertificate:TextField;
		private var _boundCurrency:TextField;
		
		private var _bags:BagCollection;

		private var _currentPage:int=0;
		private var _lastTabIndex:int=PackSource.TAB_ALL;
		
		private var _clearAll:Boolean;
		
		private var btnArr:Array;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagWindow()
		{
			setSize(387,520);
			this.title="背 包";
			_mc = ClassInstance.getInstance("bagUI_bag") as MovieClip;
			content = _mc;
			AutoBuild.replaceAll(_mc);
			
			_bags=new BagCollection(TypeProps.STORAGE_TYPE_PACK);
			_bags.x=45;
			_bags.y=70;
			addChild(_bags);
			
			_tabsManager = new TabsManager();
			for(var i:int=1;i<=5;i++){
				_tabsManager.add(Xdis.getChild(_mc.tab,"tab"+i),_bags);
			}
			_tabsManager.switchToTab(PackSource.TAB_ALL);
			_tabsManager.addEventListener(TabsManager.INDEX_CHANGE,onPackTabChange);
			
			_money=_mc.money;//魔钻
			_currency=_mc.currency;//银币
			_giftCertificate=_mc.giftCertificate;//礼券
			_boundCurrency=_mc.boundCurrency;//银锭
			
			Xtip.registerTip(_money,"RMB充值得到，同账号角色共。");
			Xtip.registerTip(_currency,"不绑定的游戏币，可以流通");
			Xtip.registerTip(_giftCertificate,"系统赠送，商城礼券专区使用");
			Xtip.registerTip(_boundCurrency,"绑定的游戏币，不能流通");

			_shopBtn= Xdis.getChild(_mc,"shop_button");
			_shopBtn.addEventListener(MouseEvent.CLICK,openShop);
			
			_storeBtn=Xdis.getChild(_mc,"store_button");
			_storeBtn.addEventListener(MouseEvent.CLICK,openStore);
			
			_sortBtn= Xdis.getChild(_mc,"tidy_button");
			_sortBtn.addEventListener(MouseEvent.CLICK,sortPack);

			_page1= Xdis.getChild(_mc,"page1_button");
			_page1.addEventListener(MouseEvent.CLICK,onPage1);
			
			_page2= Xdis.getChild(_mc,"page2_button");
			_page2.addEventListener(MouseEvent.CLICK,onPage2);
			
			_page3= Xdis.getChild(_mc,"page3_button");
			_page3.addEventListener(MouseEvent.CLICK,onPage3);
			
			_page4= Xdis.getChild(_mc,"page4_button");
			_page4.addEventListener(MouseEvent.CLICK,onPage4);
			
			btnArr=[_page1,_page2,_page3,_page4];
			
			_storeWindow=new StoreWindow();
			_storeWindow.setBag(this);

		}

		//======================================================================
		//        public function
		//======================================================================
		override public function close(event:Event=null):void
		{
			ModuleManager.moduleShop.closeShop();
			if(ModuleManager.moduleShop.isNPCShopOpened == false)
				UIManager.tweenToCenter(this);
			_storeWindow.close();
			super.close(event);
		}
		
		public function sellMode(isSell:Boolean):void
		{
			PackSource.shopSell=isSell;
		}
		
		public function mendMode(isMend:Boolean):void
		{
			PackSource.shopMend=isMend;
		}
		
		//背包
		/**
		 * 只在进入游戏时初始化一次！ 
		 * 
		 */		
		public function init():void
		{
			_bags.init();
		}
		
		public function openPack():void
		{		
			_currentPage=PackSource.PAGE1;
			_lastTabIndex=0;
			
			BtnsEnabled();
			_page1.enabled=false;
			_tabsManager.switchToTab(PackSource.TAB_ALL);
			updatePackNum();	
		}
		
		public function setPackGridNum():void
		{
			var num:int=BagStoreManager.instantce.getPackNum();
			_bags.updateTab(_tabsManager.nowIndex,_currentPage);
			updatePackNum();
		}
		
		public function onPackTabChange(event:Event=null):void
		{	
			setPackContent(_tabsManager.nowIndex);	
		}
		
		public function changePropsNum(propsId:int):void
		{
			var pos:int=PropsDyManager.instance.getPropsPostion(propsId);
			_bags.updateGridNum(pos);
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
		
		//仓库
		public function setDepotGridNum():void
		{
			var num:int=BagStoreManager.instantce.getDepotNum();
			_storeWindow.openGridsNum(num);	
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
			_currency.text=DataCenter.Instance.roleSelfVo.silver.toString();
			_giftCertificate.text=DataCenter.Instance.roleSelfVo.coupon.toString();
			_boundCurrency.text=DataCenter.Instance.roleSelfVo.note.toString();
		}
		
		public function useItemResp(msg:SUseItem):void
		{
			if(msg.code == TypeProps.RSPMSG_SUCCESS)
			{
				var template:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(msg.itemTemplateId);
				if(template)
				{
					var posArr:Array=BagStoreManager.instantce.findAllSameCdType(template.cd_type);
					_bags.playCd(posArr);
				}
			}
		}
		
		public function respTips(tip:int):void
		{
			switch(tip){
				case RspMsg.RSPMSG_PACK_FULL:
					NoticeUtil.setOperatorNotice("背包已满！");					
					break;
				case RspMsg.RSPMSG_USEITEM_FAILED:
					NoticeUtil.setOperatorNotice("使用失败");
					break;
				case RspMsg.RSPMSG_BALANCE_LESS:
					NoticeUtil.setOperatorNotice("余额不足");
					break;
			}
		}
		
		//======================================================================
		//        private function
		//======================================================================
		/**
		 *  
		 * @param index 这个是标签序号，从1开始
		 * 
		 */		
		private function setPackContent(index:int):void
		{
			if(_lastTabIndex != index)//这里其实不更新什么就是切换标签
			{
				onPage1();
				_bags.updateTab(index,_currentPage);
			}
			else
			{
				if(clearAll)
				{
					_bags.updateAllGrid(index,_currentPage);
					_bags.updateTab(index,_currentPage);
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
		
		/**
		 * 更新背包容量数字 
		 * 
		 */		
		private function updatePackNum():void
		{
			_mc.bagSpace.text=BagStoreManager.instantce.getAllPackArray().length+"/"+BagStoreManager.instantce.getPackNum();
		}
		
		//======================================================================
		//        event handler
		//======================================================================
		private function sortPack(e:MouseEvent):void
		{
			_sortBtn.disableAndAbleLater(5000,"*",1);
			var msg:CSortPackReq=new CSortPackReq();
			msg.append=PackSource.SORT;
			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSortPackReq,msg);
		}
		
		private function openShop(e:MouseEvent):void
		{
			if(ModuleManager.moduleShop.view.isOpen==false)
			{
				ModuleManager.moduleShop.openShopByID(1);
				_shopWindow=ModuleManager.moduleShop.view;
				UIManager.centerMultiWindows(_shopWindow,this,5);
			}
			else
			{
				ModuleManager.moduleShop.closeShop();
				UIManager.tweenToCenter(this);
			}
		}
		
		private function openStore(e:MouseEvent):void
		{
			if(_storeWindow.isOpen == false)
			{
				UIManager.switchOpenClose(_storeWindow);
				UIManager.centerMultiWindows(_storeWindow,this);
				_storeWindow.initOpenDepot();
				PackSource.openStore=true;
			}
			else
			{
				if(ModuleManager.moduleShop.view.isOpen == false)
					UIManager.tweenToCenter(this);
				PackSource.openStore=false;
				_storeWindow.close();
			}
		}
		
		//充值
		private function onPay():void
		{
			trace("充值");
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