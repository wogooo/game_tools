package com.YFFramework.game.core.module.guild.view
{
	import com.dolo.common.PageControlUI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *带有首页末页的翻页组件基类
	 *@author ludingchang 时间：2013-7-17 上午10:30:18
	 */
	public class GuildNormalPage extends PageControlUI
	{
		protected var _mc:Sprite;
		protected var _datas:*;//数组
		public function GuildNormalPage(view:Sprite)
		{
			_mc=view;
			
			initPageList();
			
			AutoBuild.replaceAll(_mc);
			
			_nextBtn=Xdis.getChild(_mc,"next_btn");
			_prevBtn=Xdis.getChild(_mc,"prev_btn");
			_firstBtn=Xdis.getChild(_mc,"first_btn");
			_lastBtn=Xdis.getChild(_mc,"last_btn");
			_pageTxt=Xdis.getChild(_mc,"page_txt");
			
			initCustermUI();
			
			initButtonEvents();
			
			_onePageMaxCount=getMaxCount();
			for(var i:int=0;i<_onePageMaxCount;i++)
			{
				var item:Sprite=_mc.getChildByName("item"+(i+1)) as Sprite;
				_pageList.addItemView(item);
			}
		}
		/**new pagelist,子类必须重写*/
		protected function initPageList():void
		{
//			_pageList=new GuildItemPageList();
		}
		
		/**空方法，子类有额外的UI，重写此方法并在此处理*/
		protected function initCustermUI():void
		{
			
		}
		
		/**
		 * 一页最大个数，子类有不同请重写
		 */		
		protected function getMaxCount():int
		{
			return 10;
		}
		
		//=================================================
		//上面方法用于重写，在构造时会调用
		//=================================================
		
		public function updateList(list:*):void
		{
			_datas=list;
			initData(list);
			if(list.length==0)
				setPage(1,1);
//			showPageAt(1);
		}
		protected override function initButtonEvents():void
		{
			super.initButtonEvents();
		}
		
//		override public function showPageAt(page:int):void
//		{
//			super.showPageAt(page);
//		}
		/**释放，需要手动调用*/
		public function dispose():void
		{
			_firstBtn.removeEventListener(MouseEvent.CLICK,firstPage);
			_lastBtn.removeEventListener(MouseEvent.CLICK,lastPage);
			_nextBtn.removeEventListener(MouseEvent.CLICK,nextPage);
			_prevBtn.removeEventListener(MouseEvent.CLICK,prevPage);
			
			_firstBtn=null;
			_lastBtn=null;
			_nextBtn=null;
			_prevBtn=null;
		}
		/**
		 *排序 
		 * @param mc 排序的按钮
		 * @param sortField 排序的字段
		 * 
		 */		
		protected function sort(mc:MovieClip,sortField:String):void
		{
			if(mc.currentFrame==1)
			{
				mc.gotoAndStop(2);
				_datas.sortOn(sortField,Array.NUMERIC|Array.DESCENDING);
			}
			else
			{
				mc.gotoAndStop(1);
				_datas.sortOn(sortField,Array.NUMERIC);
			}
			updateList(_datas);
		}
		/**
		 *手动设置显示的页数 ，只修改页数显示不会跟新显示的数据
		 * @param now 当前页
		 * @param max 总页
		 * 
		 */		
		public function setPage(now:int,max:int):void
		{
			_nowPage=now;
			if(max<=0)
				_maxPage=1;
			else
				_maxPage=max;
			updatePageNum();
		}
	}
}