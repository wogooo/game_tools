package com.YFFramework.game.core.module.wing.view
{
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.dolo.common.PageControlUI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @version 1.0.0
	 * creation time：2013-9-30 上午10:33:41
	 */
	public class WingFeatherPageCtrl extends PageControlUI{
		
		protected var _mc:MovieClip;
		
		public function WingFeatherPageCtrl(mc:MovieClip){
			_pageList = new FeatherItemList();
			
			AutoBuild.replaceAll(mc);
			
			_nextBtn = Xdis.getChild(mc,"next_btn");
			_prevBtn = Xdis.getChild(mc,"prev_btn");
			_firstBtn = null;
			_lastBtn = null;
			_pageTxt = Xdis.getChild(mc,"page_txt");
			
			initButtonEvents();
			
			_onePageMaxCount=8;
			
			for(var i:int=0;i<_onePageMaxCount;i++){
				var item:Sprite=mc.getChildByName("item"+i) as Sprite;
				_pageList.addItemView(item);
			}
		}
		/**更新列表
		 * @param voList
		 */		
		public function updateList(voList:Vector.<PropsDyVo>):void{
			initData(voList);
		}
	}
} 