package com.YFFramework.game.core.module.market.view.panel.consign
{
	/**
	 * 我的寄售
	 * @version 1.0.0
	 * creation time：2013-6-1 下午3:16:19
	 * 
	 */
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
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
	
	public class MyConsignLogPanel extends PageControlUI
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		private var _firstPageBtn:Button;
		private var _lastPageBtn:Button;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MyConsignLogPanel(mc:MovieClip)
		{
			_mc=mc;
			
			_pageList = new MyConsignPurchasePageList(MarketSource.CONSIGH);
			
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
				var item:Sprite=mc.getChildByName("item"+i) as Sprite;
				_pageList.addItemView(item);
			}
			
//			_firstPageBtn=Xdis.getChild(mc,"firstPage_button");
//			_firstPageBtn.addEventListener(MouseEvent.CLICK,onFirstPage);
//			
//			_lastPageBtn=Xdis.getChild(mc,"lastPage_button");
//			_lastPageBtn.addEventListener(MouseEvent.CLICK,onLastPage);
//			
//			addEventListener(UIEvent.PAGE_CHANGE,onPageChange);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function updateList():void
		{
			var list:Vector.<MarketRecord>=MarketDyManager.instance.getMyConsignList();
			initData(list);
//			checkPageBtn();
		}

		
	}
} 