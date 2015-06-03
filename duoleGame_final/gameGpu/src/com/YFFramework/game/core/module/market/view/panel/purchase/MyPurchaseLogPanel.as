package com.YFFramework.game.core.module.market.view.panel.purchase
{
	/**
	 * 求购窗口下的——我的求购
	 * @version 1.0.0
	 * creation time：2013-6-1 下午4:04:35
	 * 
	 */
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.simpleView.MyConsignPurchasePageList;
	import com.dolo.common.PageControlUI;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MyPurchaseLogPanel extends PageControlUI
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
//		private var _firstPageBtn:Button;
//		private var _lastPageBtn:Button;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MyPurchaseLogPanel(mc:MovieClip)
		{
			_mc=mc;
			
			_pageList = new MyConsignPurchasePageList(MarketSource.PURCHASE);
			
			AutoBuild.replaceAll(mc);
			
			_nextBtn = Xdis.getChild(mc,"nextPage_btn");
			_prevBtn = Xdis.getChild(mc,"prevPage_btn");
			_firstBtn = Xdis.getChild(mc,'first_btn');
			_lastBtn = Xdis.getChild(mc,'last_btn');
			_pageTxt = Xdis.getChild(mc,"curPage");
			
			initButtonEvents();
			
			_onePageMaxCount=4;
			
			for(var i:int=0;i<_onePageMaxCount;i++)
			{
				_pageList.addItemView(mc.getChildByName("item"+i) as Sprite);
			}
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function updateList():void
		{
			initData(MarketDyManager.instance.getMyPurchaseList());
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 