package com.YFFramework.game.core.module.rank.view
{
	/**
	 * 排行子类页面控制，会在这里区分表格头显示名称
	 * @version 1.0.0
	 * creation time：2013-6-19 上午11:02:56
	 * 
	 */
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.rank.data.RankBasicManager;
	import com.YFFramework.game.core.module.rank.data.RankBasicVo;
	import com.YFFramework.game.core.module.rank.data.RankDyManager;
	import com.YFFramework.game.core.module.rank.source.RankSource;
	import com.dolo.common.PageControlUI;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class RankPageControl extends PageControlUI
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		private var _updateTimeTxt:TextField;
		private var _myRankTxt:TextField;
		private var _titleSp:Sprite;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function RankPageControl(mc:MovieClip)
		{
			_mc=mc;
			_pageList = new RankPageList();
			
			AutoBuild.replaceAll(_mc);
			
			_nextBtn = Xdis.getChild(_mc,"nextPage_btn");
			_prevBtn = Xdis.getChild(_mc,"prevPage_btn");
			_firstBtn = Xdis.getChild(_mc,"firstPage_btn");
			_lastBtn = Xdis.getChild(_mc,"lastPage_btn");
			_pageTxt = Xdis.getChild(_mc,"curPage");
			
			_titleSp=Xdis.getChild(_mc,"title");
			_myRankTxt=Xdis.getChild(_mc,"myRank");
			_updateTimeTxt=Xdis.getChild(_mc,"updateTime");
			
			initButtonEvents();
			
			_onePageMaxCount=10;
			
			for(var i:int=0;i<_onePageMaxCount;i++)
			{
				var item:Sprite=_mc.getChildByName("item"+i) as Sprite;
				_pageList.addItemView(item);
			}
			
		}
		
		//======================================================================
		//        public function
		//======================================================================	
		public function updateList(vo:RankBasicVo):void
		{
			UI.removeAllChilds(_titleSp);
			var title:Sprite=ClassInstance.getInstance("rank"+vo.classic_type)
			_titleSp.addChild(title);
			
			if(vo.classic_type >= RankSource.TITLE_POWER11 && vo.classic_type <= RankSource.TITLE_MONEY31)
				_updateTimeTxt.text='每十分钟更新一次';
			else if(vo.classic_type >= RankSource.TITLE_ACTIVITY41)
				_updateTimeTxt.text='每次活动结束后更新';
			else
				_updateTimeTxt.text='';
			
			if(RankDyManager.instance.getMyRankIndex(vo.classic_type))
			{
				if(RankDyManager.instance.getMyRankIndex(vo.classic_type) > 0)
					_myRankTxt.text='您当前的排名为第'+RankDyManager.instance.getMyRankIndex(vo.classic_type)+'名';
				else
					_myRankTxt.text='您当前未上榜，加油吧！';
			}
			else
				_myRankTxt.text='您当前未上榜，加油吧！';
			
			var list:Array=RankDyManager.instance.getRankInfo(vo.classic_type);
			initData(list);
		}
		
		/** 控制分页mc是否显示 */
		public function visibleMc(show:Boolean):void
		{
			_mc.visible=show;
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