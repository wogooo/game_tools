package com.YFFramework.game.core.module.market.view.panel.log
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.view.simpleView.ConsignItemsCollection;
	import com.YFFramework.game.core.module.market.view.simpleView.MarketLogItem;
	import com.dolo.common.PageControlUI;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.market_pro.CMyDealList;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 市场窗口下的——交易记录
	 * @version 1.0.0
	 * creation time：2013-5-28 上午10:16:59
	 * 
	 */
	public class TransactionLogPanel
	{		
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		/**首页 
		 */		
		private var _firstPageBtn:Button;
		/**尾页 
		 */		
		private var _lastPageBtn:Button;
		/**上一页 
		 */		
		private var _upPageBtn:Button;
		/**下一页 
		 */		
		private var _downPageBtn:Button;
		/**当前页/全部页 
		 */		
		private var _curPageView:TextField;
		
		//********************自定义变量*****************//
		private var _items:ConsignItemsCollection;
		
		private var _curPage:int;
		private var _totalPage:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function TransactionLogPanel(mc:MovieClip)
		{
			_mc=mc;
			
			//初始化翻页按钮
			_firstPageBtn=Xdis.getChild(_mc,"firstPage_button");
			_firstPageBtn.addEventListener(MouseEvent.CLICK,onFirstPage);
			
			_lastPageBtn=Xdis.getChild(_mc,"prevPage_button");
			_lastPageBtn.addEventListener(MouseEvent.CLICK,onLastPage);
			
			_upPageBtn=Xdis.getChild(_mc,"nextPage_button");
			_upPageBtn.addEventListener(MouseEvent.CLICK,upPage);
			
			_downPageBtn=Xdis.getChild(_mc,"lastPage_button");
			_downPageBtn.addEventListener(MouseEvent.CLICK,downPage);
			
			_curPageView=Xdis.getChild(_mc,"curPage");
			
			_items=new ConsignItemsCollection(Xdis.getChild(_mc,"items"),MarketLogItem);
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function searchToServerReq(page:int=0):void
		{
			if(page > 0)
				_curPage=page;
			if(_curPage == 0)
				_curPage=1;
			
			var msg:CMyDealList=new CMyDealList();
			msg.page=_curPage;
			
			YFEventCenter.Instance.dispatchEventWith(MarketEvent.CMyDealList,msg);
		}
		
		public function searchResp(totalPage:int):void
		{		
			if(totalPage > 0)//有记录
			{
				_items.disposeLogData();
				_items.initLogData();
			}
			else//没记录
			{
				_items.disposeLogData();
			}
			
			_totalPage=totalPage;
			if(_curPage > _totalPage)//如果请求的这页不存在，重置当前页数
				_curPage = _totalPage;
			
			checkPageBtn();
			updatePageNumView();
		}
		
		//======================================================================
		//        private function
		//======================================================================
		public function updatePageNumView():void
		{
			_curPageView.text=_curPage.toString()+'/'+_totalPage.toString();
		}
		
		private function checkPageBtn():void
		{
			if(_curPage < _totalPage && _curPage > 1)
			{
				_upPageBtn.enabled=true;
				_downPageBtn.enabled=true;
				
				_lastPageBtn.enabled=true;			
				_firstPageBtn.enabled=true;
			}
			else if(_curPage == _totalPage && _totalPage > 1)//翻到末页
			{
				_upPageBtn.enabled=true;
				_firstPageBtn.enabled=true;
				
				_downPageBtn.enabled=false;
				_lastPageBtn.enabled=false;		
				
			}
			else if(_curPage == _totalPage && _totalPage == 1)//只有唯一的一页
			{
				_upPageBtn.enabled=false;
				_firstPageBtn.enabled=false;
				
				_downPageBtn.enabled=false;
				_lastPageBtn.enabled=false;
			}
			else if(_curPage == 1)//在首页
			{			
				_downPageBtn.enabled=true;				
				_lastPageBtn.enabled=true;
				
				_firstPageBtn.enabled=false;
				_upPageBtn.enabled=false;
			}
			else if(_curPage == 0 && _totalPage == 0)//没有搜索结果
			{
				_upPageBtn.enabled=false;
				_downPageBtn.enabled=false;
				
				_lastPageBtn.enabled=false;	
				_firstPageBtn.enabled=false;
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onFirstPage(e:MouseEvent):void
		{
			_curPage=1;
			searchToServerReq(_curPage);
		}
		
		private function onLastPage(e:MouseEvent):void
		{
			_curPage=_totalPage;
			searchToServerReq(_curPage);
		}
		
		private function upPage(e:MouseEvent):void
		{
			_curPage--;
			searchToServerReq(_curPage);
		}
		
		private function downPage(e:MouseEvent):void
		{
			_curPage++;
			searchToServerReq(_curPage);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 