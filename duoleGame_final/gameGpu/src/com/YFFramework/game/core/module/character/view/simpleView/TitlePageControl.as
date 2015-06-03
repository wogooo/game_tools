package com.YFFramework.game.core.module.character.view.simpleView
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * 第一版：creation time：2013-4-24 上午11:00:21
	 * 第二版：creation time：2013-11-21 上午10:17:33（呵呵呵，我要看看傻逼策划能改几回）
	 */
	import com.YFFramework.game.core.module.character.model.TitleBasicManager;
	import com.dolo.common.PageControlUI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class TitlePageControl extends PageControlUI
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
		
		public function TitlePageControl(mc:MovieClip)
		{
			_pageList = new TitlePageList();
			
			AutoBuild.replaceAll(mc);
			
			_nextBtn = Xdis.getChild(mc,"nextPage_btn");
			_prevBtn = Xdis.getChild(mc,"prevPage_btn");
			_firstBtn = Xdis.getChild(mc,"firstPage_btn");
			_lastBtn = Xdis.getChild(mc,"lastPage_btn");
			_pageTxt = Xdis.getChild(mc,"curPage");
			
			initButtonEvents();
			
			_onePageMaxCount=3;
			
			for(var i:int=0;i<_onePageMaxCount;i++)
			{
				var item:Sprite=mc.getChildByName("item"+i) as Sprite;
				_pageList.addItemView(item);
			}
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function updateList(titleType:int):void
		{
			var ary:Array=TitleBasicManager.Instance.getTitleType(titleType);
			initData(ary);
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