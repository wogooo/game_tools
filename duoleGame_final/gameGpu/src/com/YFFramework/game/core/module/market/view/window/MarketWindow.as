package com.YFFramework.game.core.module.market.view.window
{
	/**
	 * 市场窗口（包括：寄售物品、求购物品、交易记录）
	 * @version 1.0.0
	 * creation time：2013-5-27 下午3:41:28
	 * 
	 */
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.view.tips.ModuleLoader;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.market.view.panel.consign.ConsignmentPanel;
	import com.YFFramework.game.core.module.market.view.panel.log.TransactionLogPanel;
	import com.YFFramework.game.core.module.market.view.panel.purchase.PurchasePanel;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class MarketWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const tabMax:int=3;
		
		private var _mc:Sprite;
		private var _tabs:TabsManager;
		
		/**寄售信息  */		
		private var _consignmentPanel:ConsignmentPanel;
		/**求购信息  */		
		private var _purchasePanel:PurchasePanel;
		/**交易记录  */		
		private var _transactionLogPanel:TransactionLogPanel;
		/**魔钻  */		
		private var _diamondTxt:TextField;
		/**银币  */		
//		private var _silverTxt:TextField;
		
		/**寄售物品窗口  */		
//		private var _consignItemWin:ConsignItemWindow;
		/**求购物品窗口  */		
//		private var _purchaseItemWin:PurchaseItemWindow;
		
		//每个页面的bg
		private var _tabView12Bg:Sprite;
		private var _tabView3Bg:Sprite;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MarketWindow()
		{
			_mc = initByArgument(725,575,"market",WindowTittleName.marketTitle,true,DyModuleUIManager.guildMarketWinBg);
			setContentXY(29,27);
			
//			_consignItemWin=new ConsignItemWindow();
//			_purchaseItemWin=new PurchaseItemWindow();
			
			_tabs = new TabsManager();
			var _toogleBtn:MovieClip = Object(_mc).tabs_sp;
			
			for(var i:int=1;i<=tabMax;i++)
			{
				var temp:MovieClip = Object(_mc)["tabView"+i];
				_tabs.add(Xdis.getChild(_toogleBtn,"tab"+i),temp);
			}
			
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
			_consignmentPanel=new ConsignmentPanel(Xdis.getChild(_mc,"tabView1"));		
			_purchasePanel=new PurchasePanel(Xdis.getChild(_mc,"tabView2"));
			_transactionLogPanel=new TransactionLogPanel(Xdis.getChild(_mc,"tabView3"));
			
			_tabView12Bg=Xdis.getChild(_mc,'tabView12Bg');
			_tabView3Bg=Xdis.getChild(_mc,'tabView3Bg');
			
			_diamondTxt=Xdis.getChild(_mc,"diamondTxt");
			Xtip.registerTip(_diamondTxt,NoticeUtils.getStr(NoticeType.Notice_id_100013));
//			_silverTxt=Xdis.getChild(_mc,"silverTxt");
//			Xtip.registerTip(_silverTxt,NoticeUtils.getStr(NoticeType.Notice_id_100014));
			updateMoney();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function open():void
		{
			super.open();
			_tabs.switchToTab(1);
		}
		
		public function updateMoney():void
		{
			_diamondTxt.text=DataCenter.Instance.roleSelfVo.diamond.toString();
//			_silverTxt.text=DataCenter.Instance.roleSelfVo.silver.toString();
		}
		
		/**
		 * 在背包单击，移动到寄售物品 
		 * @param item
		 */		
		public function moveToConsignItem(item:ItemDyVo):void
		{
			ConsignItemWindow.instance.consignItem(item);
		}
		
		/** 
		 * 购买成功后，再刷新一次寄售列表
		 */		
		public function refreshConsignListReq():void
		{
			_consignmentPanel.searchToServer();
		}
		
		/**
		 * 寄售信息列表更新 
		 * @param totalPage
		 * 
		 */		
		public function consignListResp(totalPage:int):void
		{
			_consignmentPanel.searchResp(totalPage);
		}
		
		/** 
		 * 重置寄售物品panel
		 */		
		public function resetConsignItemPanel():void
		{
			ConsignItemWindow.instance.resetConsignItemPanel();
		}
		
		/** 
		 * 重置寄售货币panel
		 */		
//		public function resetConsignMoneyPanel():void
//		{
//			_consignItemWin.resetConsignMoneyPanel();
//		}
		
		/** 
		 * 我的寄售列表更新
		 */		
		public function myConsignListResp():void
		{
			ConsignItemWindow.instance.myConsignItemsList();
		}
		
		/** 
		 * 出售成功后，再请求刷新一次出售列表
		 */		
		public function refreshPurchaseListReq():void
		{
			_purchasePanel.searchToServer();
		}
		
		/**
		 * 求购列表更新 
		 * @param totalPage
		 * 
		 */		
		public function purchaseListResp(totalPage:int):void
		{
			_purchasePanel.searchResp(totalPage);
		}
		
		/** 
		 * 重置求购物品面板
		 */		
		public function resetPurchaseItemPanel():void
		{
			PurchaseItemWindow.instance.resetPurchaseItemPanel();
		}
		
		/** 
		 * 我的求购列表更新
		 */		
		public function myPurchaseListResp():void
		{
			PurchaseItemWindow.instance.myPurchasetemsList();
		}
		
		/**
		 * 我的交易记录更新
		 * @param totalPage
		 * 
		 */		
		public function myLogListResp(totalPage:int):void
		{
			_transactionLogPanel.searchResp(totalPage);
		}
		
		/** 
		 * 取回物品成功后再次请求当前页面的交易记录
		 */		
		public function reFreshMyLog():void
		{
			_transactionLogPanel.searchToServerReq(0);
		}
		
		override public function close(event:Event=null):void
		{
			closeTo(UI.stage.stageWidth-300,UI.stage.stageHeight-45,0.02,0.04);
			_consignmentPanel.resetPanel();
			_purchasePanel.resetPanel();
			if(ConsignItemWindow.instance.isOpen)
				ConsignItemWindow.instance.close();
			if(PurchaseItemWindow.instance.isOpen)
				PurchaseItemWindow.instance.closeTwoWindow();
			
		}
		//======================================================================
		//        private function
		//======================================================================
		private function loadTabBg(url:String,holder:Sprite):void
		{
			var loader:UILoader=new UILoader();
			loader.initData(url,holder,url);
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onTabChange(e:Event=null):void
		{
			//先把背景加进来
			if(_tabs.nowIndex == 1 || _tabs.nowIndex == 2)
			{
				if(_tabView12Bg.numChildren == 0)
					loadTabBg(DyModuleUIManager.marketTabBg1,_tabView12Bg);
				_tabView12Bg.visible=true;
				_tabView3Bg.visible=false;
			}
			else
			{
				if(_tabView3Bg.numChildren == 0)
					loadTabBg(DyModuleUIManager.marketTabBg2,_tabView3Bg);
				_tabView12Bg.visible=false;
				_tabView3Bg.visible=true;
			}
			
			if(_tabs.nowIndex == 1)//寄售界面
			{
				_consignmentPanel.searchToServer();
			}
			else if(_tabs.nowIndex == 2)//求购界面
			{
				_purchasePanel.searchToServer();
				
				PurchaseItemWindow.instance.resetPurchaseItemPanel();
				PurchaseItemWindow.instance.resetSiftWin();
			}
			else//交易记录
			{
				_transactionLogPanel.searchToServerReq(1);
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 