package com.dolo.common
{
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
		
		public function initPages():void
		{
			_maxPage = Math.ceil(_voList.length/_onePageMaxCount);
			_nowPage = 1;
			if(_voList.length == 0){
				_maxPage = 0;
				_nowPage = 0;
				updatePageNum();
				UI.setEnable(_prevBtn,false);
				UI.setEnable(_nextBtn,false);
				_pageList.removeAll();
			}else{
				showPageAt(1);
			}
		}
		
		public function initData(vos:*,isAfterRunInitPages:Boolean=false):void
		{
			_voList = new Vector.<Object>();
			for(var i:int=0;i<vos.length;i++){
				_voList.push(vos[i]);
			}
			if(isAfterRunInitPages == true){
				initPages();
			}
		}
		
		public function showPageAt(page:int):void
		{
			if(_voList == null) return;
			if(page > _maxPage){
				page = _maxPage;
			}
			if(page < 1 ){
				page = 1;
			}
			_nowPage = page;
			if(_nowPage == 1){
				UI.setEnable(_prevBtn,false);
			}else{
				UI.setEnable(_prevBtn,true);
			}
			if(_nowPage == _maxPage){
				UI.setEnable(_nextBtn,false);
			}else{
				UI.setEnable(_nextBtn,true);
			}
			updatePageNum();
			var startIndex:int;
			var endIndex:int;
			startIndex = (_nowPage-1)*_onePageMaxCount;
			endIndex = (_nowPage)*_onePageMaxCount;
			if(endIndex>_voList.length) {
				endIndex = _voList.length;
			}
			_pageList.removeAll();
			for(var i:int=startIndex;i<endIndex;i++){
				addOneItem(_voList[i]);
			}
		}
		
		protected function addOneItem(vo:Object):void
		{
			_pageList.addItem(vo);
		}
		
		protected function updatePageNum():void
		{
			_pageTxt.text = _nowPage + "/"+ _maxPage;
		}
		
	}
}