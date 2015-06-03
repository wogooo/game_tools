package com.YFFramework.game.core.module.mall.view
{
	/**
	 * @version 1.0.0
	 * creation time：2013-4-27 下午3:30:53
	 * 
	 */
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.dolo.common.PageControlUI;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class MallPageControl extends PageControlUI
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MallPageControl()
		{
			this.x = 124.5;
			this.y = 82;
			
			_pageList = new MallPageList();	
			var mc:MovieClip = ClassInstance.getInstance("mallPageControl");
			addChild(mc);
			AutoBuild.replaceAll(mc);
			
			_nextBtn = Xdis.getChild(mc,"nextPage_btn");
			_prevBtn = Xdis.getChild(mc,"prevPage_btn");
			_firstBtn = Xdis.getChild(mc,'first_btn');
			_lastBtn = Xdis.getChild(mc,'last_btn');
			_pageTxt = Xdis.getChild(mc,"curPage");
			
			initButtonEvents();
			
			_onePageMaxCount=9;
			
			for(var i:int=0;i<_onePageMaxCount;i++)
			{
				var item:Sprite=mc.getChildByName("item"+i) as Sprite;
				_pageList.addItemView(item);
			}
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function updateList(voList:Vector.<ShopBasicVo>):void
		{
			initData(voList);
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