package com.dolo.common
{
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UI;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 *翻页界面控制基类 
	 * @author flashk
	 * 
	 */
	public class PageControlUI extends Sprite
	{
		protected var _nowPage:int;
		protected var _maxPage:int;
		protected var _nextBtn:SimpleButton;
		protected var _prevBtn:SimpleButton;
		protected var _firstBtn:SimpleButton;
		protected var _lastBtn:SimpleButton;
		protected var _onePageMaxCount:uint = 8;
		protected var _pageTxt:TextField;
		protected var _pageList:PageItemListBase;
		protected var _voList:Vector.<Object>;
		
		public function PageControlUI()
		{
			
		}
		
		protected function initButtonEvents():void
		{
			if(_pageList == null){
				_pageList = new PageItemListBase();
			}
			_nextBtn.addEventListener(MouseEvent.CLICK,nextPage);
			_prevBtn.addEventListener(MouseEvent.CLICK,prevPage);
			
			if(_firstBtn != null)
			{
				_firstBtn.addEventListener(MouseEvent.CLICK,firstPage);
				_firstBtn.enabled=false;
			}
			if(_lastBtn != null)
			{
				_lastBtn.addEventListener(MouseEvent.CLICK,lastPage);
				_lastBtn.enabled=false;
			}
			_nextBtn.enabled=false;
			_prevBtn.enabled=false;		
			
		}
		
		public function get onePageMaxCount():uint
		{
			return _onePageMaxCount;
		}
		
		public function set onePageMaxCount(value:uint):void
		{
			_onePageMaxCount = value;
		}
		
		public function prevPage(event:MouseEvent=null):void
		{
			showPageAt(--_nowPage);
		}
		
		public function nextPage(event:MouseEvent=null):void
		{
			showPageAt(++_nowPage);
		}
		
		public function firstPage(event:MouseEvent=null):void
		{
			_nowPage=1;
			showPageAt(1);
		}
		
		public function lastPage(event:MouseEvent=null):void
		{
			_nowPage=_maxPage;
			showPageAt(_maxPage);
		}
		
		public function initPages():void
		{
			_maxPage = Math.ceil(_voList.length/_onePageMaxCount);
			showPageAt(1);
		}
		
		/**
		 * 初始化一版信息里的所有数据，可能会翻页
		 * @param vos
		 * @param isAfterRunInitPages：true-更新完后跳到第1页，false-不跳到第一页
		 * 
		 */		
		protected function initData(vos:*,isAfterRunInitPages:Boolean=true):void
		{
			_voList = new Vector.<Object>();
			var len:int=vos.length;
			for(var i:int=0;i<len;i++){
				_voList.push(vos[i]);
			}
			if(isAfterRunInitPages == true){
				initPages();
			}
		}
		
		protected function showPageAt(page:int):void
		{
			if(_voList == null) return;
//			else if(_maxPage==0) return;
			if(page > _maxPage){//当页面为1时且最大页面为0时
				page = _maxPage;
			}		
			_nowPage = page;
			updatePageNum();
			
			if(_nowPage < _maxPage && _nowPage > 1)//页数翻到中间的位置，四个按钮都可用
			{
				UI.setEnable(_prevBtn,true);
				UI.setEnable(_nextBtn,true);
				if(_firstBtn && _lastBtn)
				{
					UI.setEnable(_lastBtn,true);
					UI.setEnable(_firstBtn,true);
				}	
			}
			else if(_nowPage == _maxPage && _maxPage > 1)//翻到最后一页，且总页数>1
			{
				UI.setEnable(_prevBtn,true);
				UI.setEnable(_nextBtn,false);
				if(_firstBtn && _lastBtn)
				{
					UI.setEnable(_firstBtn,true);
					UI.setEnable(_lastBtn,false);
				}
			}
			else if(_nowPage == _maxPage && _maxPage == 1)//仅有一页
			{
				UI.setEnable(_prevBtn,false);
				UI.setEnable(_nextBtn,false);			
				if(_firstBtn && _lastBtn)
				{
					UI.setEnable(_firstBtn,false);
					UI.setEnable(_lastBtn,false);
				}
			}
			else if(_nowPage == 1 && _maxPage > 1)//翻到第一页，总页数>1
			{
				UI.setEnable(_prevBtn,false);
				UI.setEnable(_nextBtn,true);
				if(_firstBtn && _lastBtn)
				{
					UI.setEnable(_firstBtn,false);
					UI.setEnable(_lastBtn,true);
				}
			}
			else if(_nowPage == 0 && _maxPage == 0)//没有数据
			{
				UI.setEnable(_prevBtn,false);
				UI.setEnable(_nextBtn,false);
				if(_firstBtn && _lastBtn)
				{
					UI.setEnable(_firstBtn,false);
					UI.setEnable(_lastBtn,false);
				}
			}
			
			
			var startIndex:int;
			var endIndex:int;
			startIndex = (_nowPage-1)*_onePageMaxCount;
			endIndex = (_nowPage)*_onePageMaxCount;
			if(endIndex>_voList.length) {
				endIndex = _voList.length;
			}
			
			_pageList.removeAll();
			if(startIndex < endIndex && startIndex >= 0)
			{
				for(var i:int=startIndex;i<endIndex;i++){
					addOneItem(_voList[i]);
				}
				this.dispatchEvent(new UIEvent(UIEvent.PAGE_CHANGE));
			}
		}
		
		private function addOneItem(vo:Object):void
		{
			_pageList.addItem(vo);
		}
		
		protected function updatePageNum():void
		{
			_pageTxt.text = _nowPage + "/"+ _maxPage;
		}
		
	}
}