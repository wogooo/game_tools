package com.YFFramework.game.core.module.rank.view
{
	/**
	 * @version 1.0.0
	 * creation time：2013-6-18 上午9:52:47
	 * 
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.rank.data.OtherHeroDyVo;
	import com.YFFramework.game.core.module.rank.data.OtherHeroPetDyManager;
	import com.YFFramework.game.core.module.rank.data.RankBasicManager;
	import com.YFFramework.game.core.module.rank.data.RankBasicVo;
	import com.YFFramework.game.core.module.rank.data.RankDyManager;
	import com.YFFramework.game.core.module.rank.data.RankDyVo;
	import com.YFFramework.game.core.module.rank.event.RankEvent;
	import com.YFFramework.game.core.module.rank.source.RankSource;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.DoubleDeckTree;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.controls.WindowEx;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.Xdis;
	import com.msg.rank_pro.CMyRank;
	import com.msg.rank_pro.CRankRequest;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class RankWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		
		private var _pageControl:RankPageControl;
		
		protected var _tree:DoubleDeckTree;
		
		private var _curRankBsVo:RankBasicVo;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function RankWindow()
		{
			_mc = initByArgument(712,530,"rank",WindowTittleName.rankTitle,true,DyModuleUIManager.rankBg) as MovieClip;
			setContentXY(20,-12);
			
			_pageControl=new RankPageControl(Xdis.getChild(_mc,"pageControl"));
			
			//初始化分类树			
			_tree = Xdis.getChild(_mc,"all_tree");
			_tree.canTrunkSelect = true;
			_tree.addEventListener(UIEvent.TREE_TRUNK_CHANGE,onTreeTrunkChange);
			_tree.addEventListener(UIEvent.USER_CHANGE,onSelectItem);
			
			var item:ListItem;
			var trunkAry:Vector.<RankBasicVo>=RankBasicManager.Instance.getTypeArray();
			var nodesAry:Array;
			var typeLen:int=trunkAry.length;
			
			for(var i:int=1;i<typeLen;i++)
			{
				item=new ListItem();
				item.label=trunkAry[i].classic_name;
				_tree.addTrunk(item);
				nodesAry=RankBasicManager.Instance.getSubTypeAry(i);
				for each(var node:RankBasicVo in nodesAry)
				{
					item=new ListItem();
					item.label=node.subClassic_name;
					item.vo=node;
					_tree.addNote(item,i-1);
				}		
			}		
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function open():void
		{
			super.open();
			resetPanel();
			showRankInfo(_curRankBsVo.classic_type);
		}
		
		public function searchToServer():void
		{
			ModuleManager.rankModule.rankReq(_curRankBsVo.classic_type);
		}
		
		/** 查询第一个玩家信息 */		
		public function searchDefaultFirstInfo():void
		{
			var ary:Array;
			if(_curRankBsVo.classic_type == RankSource.TITLE_POWER11)
			{
				ary=RankDyManager.instance.getRankInfo(_curRankBsVo.classic_type);
				if(ary)
					ModuleManager.rankModule.otherPlayerReq(RankDyVo(ary[0]).characterId,true);
			}
			else if(_curRankBsVo.classic_type == RankSource.TITLE_POWER12)
			{
				ary=RankDyManager.instance.getRankInfo(_curRankBsVo.classic_type);
				if(ary && ary.length>0)
					ModuleManager.rankModule.otherPetReq(RankDyVo(ary[0]).petId);
			}
		}
		
		/**
		 * 显示查询的人物、宠物详细信息 
		 * @param playerId
		 * @param petId
		 * 
		 */		
		public function showRoleDetail(vo:OtherHeroDyVo):void
		{
			if(RankPetInfoWindow.instance.isOpen)
				RankPetInfoWindow.instance.close();
			var win:RankRoleInfoWindow=RankRoleInfoWindow.instance.updateCharacter(vo,true);
			win.open();
			UIManager.centerMultiWindows(this,win,5);
		}
		
		public function showPetDetail(vo:PetDyVo):void
		{
			if(RankRoleInfoWindow.instance.isOpen)
				RankRoleInfoWindow.instance.close();
			var win:RankPetInfoWindow=RankPetInfoWindow.instance.updatePetInfo(vo);
			win.open();
			UIManager.centerMultiWindows(this,win,5);
		}
		
		/** 显示该分类下的排行信息 */		
		public function showRankInfo(type:int):void
		{
			var ary:Array=RankDyManager.instance.getRankInfo(_curRankBsVo.classic_type);
			if(ary)
			{
				_pageControl.visibleMc(true);
				if(type == _curRankBsVo.classic_type)
					_pageControl.updateList(_curRankBsVo);
			}
			else
				_pageControl.visibleMc(false);
		}
		
		override public function close(event:Event=null):void
		{
			closeTo(UI.stage.stageWidth-40,110,0.02,0.04);
			if(RankRoleInfoWindow.instance.isOpen)
				RankRoleInfoWindow.instance.close();
			if(RankPetInfoWindow.instance.isOpen)
				RankPetInfoWindow.instance.close();
		}
		//======================================================================
		//        private function
		//======================================================================	
		private function resetPanel():void
		{	
			for(var i:int=0;i<_tree.trunkLength;i++)
			{
				_tree.openTrunk(i,false,false);	
			}
			_tree.clearSelection(false);
			_tree.openTrunk(0,true);//为了展开第一个树干，选中第一个树枝，如不需要可注释掉
			
		}
		//======================================================================
		//        event handler
		//======================================================================
		/**
		 * 树干改变调用的函数 ,并且默认选择第一个子类
		 * @param event
		 */			
		protected function onTreeTrunkChange(event:Event):void
		{
			var index:int = _tree.selectedTrunkIndex;
			if(_tree.isTrunkOpen(index)==true)
			{
				_tree.selectedTrunkIndex = index;
				_tree.selectedIndex = 0;
				
				onSelectItem();				
			}
			
		}
		
		//选择子类
		private function onSelectItem(e:Event=null):void
		{
			if(_tree.selectedItem)
			{
				_curRankBsVo=_tree.selectedItem.vo;
				
				searchToServer();
				searchDefaultFirstInfo();
			}
			
		}
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 