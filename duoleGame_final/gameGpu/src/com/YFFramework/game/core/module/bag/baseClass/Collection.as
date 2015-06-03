package com.YFFramework.game.core.module.bag.baseClass
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.ZHitTester;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.bag.backPack.OpenBagGridManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.data.OpenCellBasicManager;
	import com.YFFramework.game.core.module.bag.data.OpenCellBasicVo;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.managers.UI;
	import com.msg.item.Unit;
	import com.msg.storage.CMoveItemReq;
	import com.msg.storage.CPutToBodyReq;
	import com.msg.storage.CRemoveFromDepotReq;
	import com.msg.storage.CRemoveFromPackReq;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;

	/**
	 * @version 1.0.0
	 * creation time：2012-11-22 上午11:52:09
	 * 
	 */
	
	
	public class Collection extends EventDispatcher
	{
		//======================================================================
		//        const variable
		//======================================================================
		private static const WIDTH:int=45+1;
		private static const PAGE_NUM:int=35;
		private static const TXT_NUM:int=7;
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================
		private var _mc:Sprite;
		private var _closeGridsContainer:Sprite;
		private var _gridsContainer:Sprite;
		private var _bgContainer:Sprite;
		
		private var _moveGrids:HashMap;
		
		private var _closeGrids:Vector.<MoveGrid>;
		private var _num:int;
		
		public var _boxType:int;
		
		private var _alter:Alert;
		private var _isInside:Boolean;
		
		private var _offset:int;
		private var isPack:Boolean;
		
		private var _curPage:int;
		
		private var lastPage:int=-1;
		
//		private var _itemsPool:ObjectPool;
		private var _lastPos:int=0;
		private var _lastTime:Number;
		//======================================================================
		//        constructor
		//======================================================================
		public function Collection(boxType:int,mc:Sprite)
		{
			_mc=mc;
			
			_closeGridsContainer=new Sprite();
			_gridsContainer=new Sprite();
			_bgContainer=new Sprite();
			
			_mc.addChild(_bgContainer);
			_mc.addChild(_gridsContainer);
			_mc.addChild(_closeGridsContainer);

			_closeGrids=new Vector.<MoveGrid>(PAGE_NUM);
			_moveGrids=new HashMap();
			
			_boxType=boxType;//判定未开启的格子是仓库还是背包
			
			if(boxType == TypeProps.STORAGE_TYPE_PACK)
			{
				_offset=BagSource.BAG_OFFSET;
				isPack=true;
			}
			else if(boxType == TypeProps.STORAGE_TYPE_DEPOT)
			{
				_offset=BagSource.STORE_OFFSET;
				isPack=false;
			}
			
			//设置35个背景
			for(var j:int=0;j<PAGE_NUM;j++)
			{
				var bgGrid:MoveGrid=new MoveGrid();
				bgGrid.x=(j%7)*WIDTH;
				bgGrid.y=int(j/7)*WIDTH;
				if(isPack)
					bgGrid.boxType=TypeProps.STORAGE_TYPE_PACK;
				else
					bgGrid.boxType=TypeProps.STORAGE_TYPE_DEPOT;
				bgGrid.openGrid();
				_bgContainer.addChild(bgGrid);
			}
			
			//设置35个关闭格子
			for(var i:int=0;i<_closeGrids.length;i++)
			{
				_closeGrids[i]=new MoveGrid();
				_closeGrids[i].x=(i%7)*WIDTH;
				_closeGrids[i].y=int(i/7)*WIDTH;
				if(isPack)
					_closeGrids[i].boxType=TypeProps.STORAGE_TYPE_PACK;
				else
					_closeGrids[i].boxType=TypeProps.STORAGE_TYPE_DEPOT;
				_closeGrids[i].closeGrid();
				_closeGridsContainer.addChild(_closeGrids[i]);
			}
			
			_mc.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_mc.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			_mc.addEventListener(MouseEvent.MOUSE_OVER,rollOverHandler);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,rollOutHandler);
			_mc.addEventListener(BagEvent.ITEM_SELECT,highLight);
		} 
		
		//======================================================================
		//        function
		//======================================================================
		/** 
		 * 初始化所有格子
		 */		
		public function initGrid():void
		{
			clearAllContent();
			
			var packArr:Array=[];
			
			if(isPack)
				packArr=BagStoreManager.instantce.getAllPackArray();
			else
				packArr=BagStoreManager.instantce.getAllDepotArray();
			
			for each(var item:ItemDyVo in packArr)
			{
				var grid:MoveGrid=new MoveGrid();
				grid.setContent(item);
				if(isPack)
					grid.boxType=TypeProps.STORAGE_TYPE_PACK;
				else
					grid.boxType=TypeProps.STORAGE_TYPE_DEPOT;
				if(item.type == TypeProps.ITEM_TYPE_PROPS)
				{
					playRemainCdTime(item,grid);
				}
				_moveGrids.put(grid.info.pos,grid);
			}
		}
		
		/**
		 * 基本就是整理背包时调用这个方法 
		 * @param tabIndex
		 * @param pageIndex
		 * 
		 */		
		public function updateAllGrid(tabIndex:int,pageIndex:int):void
		{
			_curPage=pageIndex;
			
			clearAllContent();
			initGrid();
			
			updateTab(tabIndex,pageIndex);
			
		}
		
		/**
		 * 整个事件处理流程：type==0，移除；type ！= 0，原来这个位置有东西，停cd，重置cd；没有东西， 如果有cd，开始cd
		 * @param tabIndex
		 * @param pageIndex
		 * 
		 */		
		public function updateSomeGrid(tabIndex:int,pageIndex:int):void
		{
			_curPage=pageIndex;
			
			var newArr:Array;
			if(isPack)
				newArr=BagStoreManager.instantce.newPackCells;
			else
				newArr=BagStoreManager.instantce.newDepotCells;
			
			var updateGrids:Array=[];
			
			for each(var item:ItemDyVo in newArr)
			{
				var grid:MoveGrid=_moveGrids.get(item.pos);
				if(grid)
				{
					if(item.type != TypeProps.ITEM_TYPE_EMPTY)
					{
						grid.disposeContent();
						grid.setContent(item);
						if(item.type == TypeProps.ITEM_TYPE_PROPS)
						{
							playRemainCdTime(item,grid);
							if(TradeDyManager.isTrading && isPack)
							{
								grid.setBoundStatus();
							}
						}
						updateGrids.push(grid);
					}
					else
					{
						_moveGrids.remove(item.pos);
						grid.dispose();
//						_itemsPool.returnObject(grid);
						if(grid.parent)
							grid.parent.removeChild(grid);
					}
				}
				else
				{
					var moveGrid:MoveGrid=new MoveGrid();
					moveGrid.setContent(item);
					_moveGrids.put(item.pos,moveGrid);
					if(isPack)
						moveGrid.boxType=TypeProps.STORAGE_TYPE_PACK;
					else
						moveGrid.boxType=TypeProps.STORAGE_TYPE_DEPOT;
					if(item.type == TypeProps.ITEM_TYPE_PROPS)
					{
						playRemainCdTime(item,moveGrid);
						if(TradeDyManager.isTrading && isPack)
						{
							moveGrid.setBoundStatus();
						}
					}
					updateGrids.push(moveGrid);
				}

			}
			
			updateTab(tabIndex,pageIndex,updateGrids);
			
		}
		
		public function delGrid(tabIndex:int,pageIndex:int,pos:int):void
		{
			var grid:MoveGrid=_moveGrids.get(pos);
			if(grid)
			{
				_moveGrids.remove(pos);
				grid.dispose();
				if(grid.parent)
					grid.parent.removeChild(grid);
			}
			
		}
		
		
		/** 获取鼠标悬停在 背包 或者仓库面板上时  鼠标所指向的格子  索引  
		 *  index 从 0 开始
		 */
		public function getMouseOverGridIndex():int
		{
			var mX:Number=_gridsContainer.mouseX;
			var mY:Number=_gridsContainer.mouseY;
			
			var colunm:int=mX/WIDTH; //列
			var row:int=mY/WIDTH;	//行
			var index:int=row*7+colunm;
			index=index+PAGE_NUM*_curPage;// pageIndex是从 0开始的
			return index;
		}
		
		/**
		 * 主要管理开关格子显示
		 * @param 
		 * @param tabIndex
		 * @param pageIndex 从0开始
		 * @param hideAll 是否把以前的隐藏
		 * 
		 */		
		public function updateTab(tabIndex:int=1,pageIndex:int=0,newGrids:Array=null):void
		{
			_curPage=pageIndex;
			
			var openNum:int;
			
			if(isPack)
				openNum=BagStoreManager.instantce.getPackNum();
			else
				openNum = BagStoreManager.instantce.getDepotNum();
			
			var grids:Array;		
			if(newGrids != null)
			{		
				if(tabIndex != BagSource.TAB_ALL)
				{
					grids=_moveGrids.values();
					grids.sortOn("actualPos");
				}
				else
				{
					grids=newGrids;
				}
			}
			else
			{
				if(_moveGrids)
				{
					grids=_moveGrids.values();
					grids.sortOn("actualPos");
				}
				
			}
			
			switch(tabIndex)
			{
				case BagSource.TAB_ALL:
					hideAllCloseContent();//否则页面切换回来都是关闭的格子
					if(((pageIndex+1)*PAGE_NUM - openNum) <= 0)//初始开了35，在第一页;或者全开
					{
						if(newGrids == null || _curPage != lastPage)
							hideAllContent();
						displayGrid(grids,pageIndex*PAGE_NUM,(pageIndex+1)*PAGE_NUM,tabIndex,pageIndex);
					}
					else if(((pageIndex+1)*PAGE_NUM - openNum) > 0)//翻到半关,或者全关有文字
					{
						if(newGrids == null || _curPage != lastPage)
							hideAllContent();			
						displayGrid(grids,pageIndex*PAGE_NUM,openNum,tabIndex,pageIndex);
						
						displayCloseGrid(openNum,pageIndex);	
						
					}
					break;
				case BagSource.TAB_CONSUME:
				case BagSource.TAB_EQUIPMENT:
				case BagSource.TAB_MATERIAL:
				case BagSource.TAB_MISSION:
					hideAllCloseContent();
					if(newGrids == null || _curPage != lastPage)
						hideAllContent();
					displayGrid(grids,pageIndex*PAGE_NUM,openNum,tabIndex,pageIndex);
					break;
			}
			
			lastPage=_curPage;
//			trace("显示完成！共有子对象：",this.numChildren)
		}
		
		/**
		 * 刷新某个道具的数量 
		 * @param pos
		 * 
		 */		
		public function updateGridNum(pos:int):void
		{
			var grid:MoveGrid=_moveGrids.get(pos);
			if(grid)
				grid.changePropsNum();
		}
		
		/** 获取背包格子单元UI 
		 */
		public function getMoveGrid(pos:int):MoveGrid
		{
			return _moveGrids.get(pos);
		}
		
		/**
		 * 高亮某个格子 
		 * @param pos
		 * 
		 */		
		public function highLight(e:BagEvent):void
		{
			var pos:int=e.data as int;
			var grid:MoveGrid=_moveGrids.get(_lastPos);
			if(grid)
			{
				grid.selected=false;
			}	
			_lastPos=pos;
		}
		
		public function playCd(cdArray:Array):void
		{
			for each(var pos:int in cdArray)
			{
				var grid:MoveGrid=_moveGrids.get(pos);
				if(grid)//有时候删和播cd不同步
					grid.playCd();
			}
		}
		
		/**
		 * 寄售、交易模式下，绑定的物品改变格子状态 
		 * 
		 */		
		public function boundStatus():void
		{
			var bags:Array=_moveGrids.values();
			for each(var grid:MoveGrid in bags)
			{
				if(TradeDyManager.isTrading || MarketSource.ConsignmentStatus)
					grid.setBoundStatus();
				else
					grid.clearBoundStatus();
			}

		}
		
		/**
		 * 交易、寄售的绑定效果（有白色蒙版的）
		 * @param pos
		 * @param lock
		 * 
		 */		
		public function setLockStatusGrid(pos:int,lock:Boolean):void
		{
			if(_moveGrids.hasKey(pos))
			{
				var grid:MoveGrid=_moveGrids.get(pos);
				if(lock)
					grid.setLockGrid();
				else
					grid.unLockGrid();
			}
		}
		
		/**
		 * 改变装备是不是符合玩家职业的状态 
		 * true-显示
		 * false-不显示
		 */		
		public function changeEquipStatus(show:Boolean):void
		{
			var arr:Array=BagStoreManager.instantce.getAllPackArray();
			for each(var item:ItemDyVo in arr)
			{
				if(item.type == TypeProps.ITEM_TYPE_EQUIP)
				{
					var grid:MoveGrid=_moveGrids.get(item.pos);
					if(grid)
						grid.changeEquipStatus(show);
				}
			}
		}
		
		/**
		 * 重新显示装备、道具的绑定
		 * @param type
		 * @param pos
		 */		
		public function changePropsEquipBound(type:int,pos:int):void
		{
			var grid:MoveGrid = _moveGrids.get(pos);
			if(grid)
				grid.changePropsEquipBound(type);
		}
		
		/** 播放时间开启格子cd */
		public function playCloseGridCd(start:int):void
		{
			if(isPack)
			{
				_closeGrids[start].playCloseCd();
			}
		}
		
		private function clearCloseGridCd():void
		{
			if(isPack)
			{
				for(var i:int=0;i<_closeGrids.length;i++)
				{
					_closeGrids[i].clearCloseCd();
				}				
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		/**
		 * 播放剩余cd时间 
		 * @param item 新的位置信息
		 * @param curGrid 新的格子
		 */		
		private function playRemainCdTime(curItem:ItemDyVo,curGrid:MoveGrid):void
		{
			if(isPack && PropsDyManager.instance.getPropsInfo(curItem.id))
			{
				var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(curItem.id);//当前要播cd的对象
				var curTemplate:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(propsDyVo.templateId);
				var item:ItemDyVo;
				var cdGrid:MoveGrid;
				
				if(BagStoreManager.instantce.hasCdType(curTemplate.cd_type))
				{
					var cd:YFCD=BagStoreManager.instantce.getCd(curTemplate.cd_type);
					curGrid.resetCd(cd);
				}
			}
			
		}
		
		/**
		 * 显示开启的格子 ，在0-139范围内；格子分类
		 * @param start
		 * @param end
		 * 
		 */		
		private function displayGrid(grids:Array,openStart:int,openEnd:int,tabIndex:int,pageIndex:int):void
		{	
			var tmpArr:Array=[];
			var templateId:int;
			
			for each(var grid:MoveGrid in grids)
			{
				switch(tabIndex)
				{
					case BagSource.TAB_ALL:
						if(grid.info.type == TypeProps.ITEM_TYPE_EQUIP)
						{
							var actualPos:int=grid.info.pos-_offset;//从0-139；
							if(actualPos >= openStart && actualPos < openEnd)
							{
								var pos:int=actualPos%PAGE_NUM;//为了排位置，再把位置转化为0-35
								grid.x=(pos%7)*WIDTH;
								grid.y=int(pos/7)*WIDTH;
								_gridsContainer.addChild(grid);
							}
						}
						else if(grid.info.type == TypeProps.ITEM_TYPE_PROPS)
						{
							if(PropsDyManager.instance.getPropsInfo(grid.info.id))
							{
								templateId=PropsDyManager.instance.getPropsInfo(grid.info.id).templateId;
								actualPos=grid.info.pos-_offset;//从0-139；
								if(actualPos >= openStart && actualPos < openEnd)
								{
									pos=actualPos%PAGE_NUM;//为了排位置，再把位置转化为0-35
									grid.x=(pos%7)*WIDTH;
									grid.y=int(pos/7)*WIDTH;
									_gridsContainer.addChild(grid);
								}
							}	
							
						}
						break;
					case BagSource.TAB_CONSUME://药品、驯养道具、喂养道具等常用消耗品
						if(grid.info.type == TypeProps.ITEM_TYPE_PROPS)
						{
							templateId=PropsDyManager.instance.getPropsInfo(grid.info.id).templateId;
							var propsBasicVo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(templateId);
							if(propsBasicVo.type == TypeProps.PROPS_TYPE_HP_DRUG ||
								propsBasicVo.type == TypeProps.PROPS_TYPE_PET_COMFORT ||
								propsBasicVo.type == TypeProps.PROPS_TYPE_PET_FEED ||
								propsBasicVo.type == TypeProps.PROPS_TYPE_MP_DRUG)
							{
								tmpArr.push(grid);
							}	
						}
						break;
					case BagSource.TAB_EQUIPMENT:
						if(grid.info.type == TypeProps.ITEM_TYPE_EQUIP)
						{
							tmpArr.push(grid);
						}
						break;
					case BagSource.TAB_MATERIAL://装备强化材料、宝石、宠物强化材料、领悟材料、技能书、洗练材料等材料
						if(grid.info.type == TypeProps.ITEM_TYPE_PROPS)
						{
							templateId=PropsDyManager.instance.getPropsInfo(grid.info.id).templateId;
//							var propsResetId:int=ConstMapBasicManager.Instance.getConstMapBasicVo(TypeProps.CONST_ID_PET_RESET).tmpl_id;
							if(PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_ENHANCE ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_GEM ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_ENHANCE ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_COMPRE ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_SKILLBOOK ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_SOPHI)
							{
								tmpArr.push(grid);
							}	
						}
						break;
					case BagSource.TAB_MISSION:
						if(grid.info.type == TypeProps.ITEM_TYPE_PROPS)
						{
							templateId=PropsDyManager.instance.getPropsInfo(grid.info.id).templateId;
							if(PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_TASK)
							{
								tmpArr.push(grid);
							}
						}
						break; 
				}
				
			}
			
			if(tmpArr.length > 0)
			{
				for(var i:int=pageIndex * PAGE_NUM;i<(pageIndex+1) * PAGE_NUM;i++)
				{
					if(tmpArr[i])
					{
						pos=i%PAGE_NUM;
						tmpArr[i].x=(pos%7)*WIDTH;
						tmpArr[i].y=int(pos/7)*WIDTH;
						_gridsContainer.addChild(tmpArr[i]);
					}
				}
			}
			
		}
		
		/**
		 * 创建最多35个关闭的格子
		 * @param openNum 开启了多少个格子
		 * @param pageIndex
		 * 
		 */		
		private function displayCloseGrid(openNum:int,pageIndex:int):void
		{
			var start:int=PAGE_NUM-((pageIndex+1)*PAGE_NUM-openNum);//当页格子数（35）-（总格子数-开启格子数）=要从第几个开启 
			if(openNum <= (pageIndex+1)*PAGE_NUM && start >= 0)//半关或全关有文字
			{
				hideAllCloseContent();
				for(var i:int = start ; i < PAGE_NUM ; i++)
				{
					_closeGridsContainer.addChild(_closeGrids[i]);				
				}
				
				clearTxt();
				displayTxt(start);
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= 30)//策划说30级才开始
				{
					clearCloseGridCd();
					playCloseGridCd(start);
				}
			}
			else//全关没文字
			{
				hideAllCloseContent();
				clearTxt();
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= 30)//策划说30级才开始
				{
					clearCloseGridCd();
				}
				for(i = 0 ; i < PAGE_NUM ; i++)
				{
					_closeGridsContainer.addChild(_closeGrids[i]);			
				}
			}
		}
		
		/**
		 * 显示关闭格子上的文字 ,并增加开启cd
		 * @param start 
		 * 
		 */		
		private function displayTxt(start:int):void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= 30)
				_closeGrids[start].setExtendGridTxt('正在开启');
//			else
//			{
//				var j:int=0;
//				for(var i:int = start;i < start+7 ;i++)
//				{
//					if(isPack)
//					{
//						var a:String=BagSource.EXTEND_PACK_GRID_TXT.charAt(i);
//						_closeGrids[i].setExtendGridTxt(BagSource.EXTEND_PACK_GRID_TXT.charAt(j));
//					}
//					else
//					{
//						_closeGrids[i].setExtendGridTxt(BagSource.EXTEND_DEPOT_GRID_TXT.charAt(j));
//					}
//					j++;
//				}
//			}			
		}
		
		/////////////////////////////////////////////隐藏方法
		/**
		 * 隐藏开启（有内容，在舞台上显示）的格子 
		 * 
		 */		
		private function hideAllContent():void
		{
			while(_gridsContainer.numChildren > 0)
			{
				_gridsContainer.removeChildAt(0);
			}
		}
		
		/**
		 * 隐藏掉所有的关闭格子 ,同时关闭格子
		 * 
		 */		
		private function hideAllCloseContent():void
		{
			UI.removeAllChilds(_closeGridsContainer);
		}
		
		//////////////////////////三个清除方法：滤镜，关闭的格子，开启的
//		private function clearAllFilter():void
//		{	
//			var arr:Array=_moveGrids.values();
//			for each(var grid:MoveGrid in arr)
//			{
//				if(grid.selected)
//				{
//					grid.selected=false;
//				}
//			}
//
//		}
		
		/**
		 * 清除并释放指定对象的内存
		 * 
		 */		
		private function clearAllContent():void
		{
			var arr:Array=_moveGrids.values();
			for each(var grid:MoveGrid in arr)
			{
				_moveGrids.remove(grid.info.pos);
				grid.dispose();	
			}			
		}
		
		/**
		 * 清除关闭格子上的文字 
		 */		
		private function clearTxt():void
		{
			for(var i:int=0;i<_closeGrids.length;i++)
			{
				_closeGrids[i].clearTxt();
			}
		}
		
		/**
		 * 移动格子 
		 * @param toGrid
		 * 
		 */		
		private function moveItem(fromData:DragData,toGrid:IMoveGrid,toGridKey:int):void
		{
			var movDirect:int=0;
			var fromPos:int;
			var toPos:int;
			
			//背包移到背包，背包移到仓库\装备
			fromPos=fromData.fromID;
			if(fromData.type == DragData.FROM_BAG)//从背包里
			{
				if(toGrid.boxType == TypeProps.STORAGE_TYPE_PACK && toGridKey <= BagStoreManager.instantce.getPackNum())
				{
					toPos=toGridKey+BagSource.BAG_OFFSET;
					//在寄售和交易状态下，锁定的格子不能交换
					var tradeItem:ItemDyVo=BagStoreManager.instantce.getPackInfoByPos(toPos);
					if(TradeDyManager.isTrading && TradeDyManager.Instance.isLockItem(tradeItem.id,tradeItem.type))
						return;
					if(MarketSource.ConsignmentStatus && MarketSource.curLockPos == toPos)
						return;
					movDirect=TypeProps.MOV_DIRECT_PACK_TO_PACK;
				}
				else if(toGrid.boxType == TypeProps.STORAGE_TYPE_DEPOT && toGridKey <= BagStoreManager.instantce.getDepotNum())
				{
					if(BagStoreManager.instantce.getAllDepotArray().length == BagStoreManager.instantce.getDepotNum())
					{
						NoticeManager.setNotice(NoticeType.Notice_id_328);
						return;
					}
					if(fromData.data.type == TypeProps.ITEM_TYPE_PROPS)//任务道具不能拖到仓库
					{
						var dyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(fromData.data.id);
						var vo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(dyVo.templateId);
						if(vo.type == TypeProps.PROPS_TYPE_TASK)
						{
							NoticeManager.setNotice(NoticeType.Notice_id_334);
							return;
						}
					}
					toPos=toGridKey+BagSource.STORE_OFFSET;				
					movDirect=TypeProps.MOV_DIRECT_PACK_TO_DEPOT;
				}	
				else//移到身上
				{
					toPos=toGrid.boxKey;
					movDirect=TypeProps.MOV_DIRECT_PACK_TO_BODY;
					dispatchOnEquipEvent(fromPos,toPos);
					return;
				}
				
			}
			else if(fromData.type == DragData.FROM_DEPOT)//从仓库里
			{
				if(toGrid.boxType == TypeProps.STORAGE_TYPE_PACK && toGridKey <= BagStoreManager.instantce.getPackNum())
				{
					if(BagStoreManager.instantce.getAllPackArray().length == BagStoreManager.instantce.getPackNum())
					{
						NoticeManager.setNotice(NoticeType.Notice_id_302);
						return;
					}
					toPos=toGridKey+BagSource.BAG_OFFSET;							
					movDirect=TypeProps.MOV_DIRECT_DEPOT_TO_PACK;
				}
				else if(toGrid.boxType == TypeProps.STORAGE_TYPE_DEPOT && toGridKey <= BagStoreManager.instantce.getDepotNum())
				{
					toPos=toGridKey+BagSource.STORE_OFFSET;
					movDirect=TypeProps.MOV_DIRECT_DEPOT_TO_DEPOT;
				}
				
			}
			else if(fromData.type == DragData.FROM_CHARACTER)//人物面板
			{
				if(toGrid.boxType == TypeProps.STORAGE_TYPE_PACK && toGridKey <= BagStoreManager.instantce.getPackNum())
				{
					toPos=toGridKey+BagSource.BAG_OFFSET;							
					movDirect=TypeProps.MOV_DIRECT_BODY_TO_PACK;
				}
			}
			else if(fromData.type == DragData.FROM_TRADE)//从交易移动到背包，解锁相应的格子
			{
				if(isPack)
				{
					(_moveGrids.get(fromData.fromID) as MoveGrid).setLockGrid();
					YFEventCenter.Instance.dispatchEventWith(BagEvent.MOVE_TO_BAG_SUCC,fromData.fromID);
					return;
				}
			}
			else if(fromData.type == DragData.FROM_CONSIGNMENT)//寄售，解锁
			{
				if(isPack)
				{
					(_moveGrids.get(fromData.fromID) as MoveGrid).unLockGrid();
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.clearConsignPanel);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
					return;
				}
			}
			else//其他的东西都不能拖背包
				return;
			if(fromPos != toPos)
			{
				var msg:CMoveItemReq=new CMoveItemReq();
				var item:Unit=new Unit();
				item.id=fromData.data.id;
				item.type=fromData.data.type;
				msg.movDirect=movDirect;
				msg.sourcePos=fromPos;
				msg.targetPos=toPos;
				msg.item=item;
				YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CMoveItemReq,msg);
			}
			
		}
		
		private function dispatchOnEquipEvent(sourcePos:int,toPos:int):void
		{
			var msg:CPutToBodyReq=new CPutToBodyReq();
			msg.sourcePos=sourcePos;
			msg.targetPos=toPos;
			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CPutToBodyReq,msg);
		}
		
		protected function warnning(fromDragVo:DragData):void
		{			
			var str:String='';
			var templateId:int=0;
			
			var buttonLabels:Array = [NoticeUtils.getStr(NoticeType.Notice_id_100005),NoticeUtils.getStr(NoticeType.Notice_id_100006)];;
			
			if(fromDragVo.data.type == TypeProps.ITEM_TYPE_PROPS)
			{
				var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(fromDragVo.data.id);
				if(propsDyVo)
				{
					templateId=PropsDyManager.instance.getPropsInfo(fromDragVo.data.id).templateId;
					if(propsDyVo.binding_type == TypeProps.BIND_TYPE_YES)
					{
						str=NoticeUtils.getStr(NoticeType.Notice_id_100007);
						str = str.replace("*",PropsBasicManager.Instance.getPropsBasicVo(templateId).name);
//						str = HTMLUtil.setFont(str,TypeProps.getQualityColor(PropsBasicManager.Instance.getPropsBasicVo(templateId).quality));
						_alter=Alert.show(str,NoticeUtils.getStr(NoticeType.Notice_id_100008),onDelAlter,buttonLabels,true,fromDragVo);
					}
					else
					{
						str=NoticeUtils.getStr(NoticeType.Notice_id_100009);
						str = str.replace("*",PropsBasicManager.Instance.getPropsBasicVo(templateId).name);
						_alter=Alert.show(str,NoticeUtils.getStr(NoticeType.Notice_id_100010),onDelAlter,buttonLabels,true,fromDragVo);
					}
				}
			}
			else if(fromDragVo.data.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(fromDragVo.data.id);
				if(equipDyVo)
				{
					templateId=EquipDyManager.instance.getEquipInfo(fromDragVo.data.id).template_id;
					if(equipDyVo.binding_type == TypeProps.BIND_TYPE_YES)
					{
						str=NoticeUtils.getStr(NoticeType.Notice_id_100007);
						str = str.replace("*",EquipBasicManager.Instance.getEquipBasicVo(templateId).name);
						_alter=Alert.show(str,NoticeUtils.getStr(NoticeType.Notice_id_100008),onDelAlter,buttonLabels,true,fromDragVo);
					}
					else
					{
						str=NoticeUtils.getStr(NoticeType.Notice_id_100009);
						str = str.replace("*",EquipBasicManager.Instance.getEquipBasicVo(templateId).name);
						_alter=Alert.show(str,NoticeUtils.getStr(NoticeType.Notice_id_100010),onDelAlter,buttonLabels,true,fromDragVo);
					}
				}	
			}
			
		}
		//======================================================================
		//        event handler
		//======================================================================
		/**
		 * 处理背包和仓库直接的拖动 
		 * @param e
		 * 
		 */		
		protected function onMouseUp(e:MouseEvent):void
		{
			_isInside = true;
			var fromData:DragData=DragManager.Instance.dragVo as DragData;
			if(fromData)
			{
				var posX:int=_mc.mouseX;
				var posY:int=_mc.mouseY;
				
				var x:int=int(posX/WIDTH);
				var y:int=int(posY/WIDTH);
				
				var toGridKey:int=_curPage*PAGE_NUM+y*BagSource.ROW_GRIDS+x;
				var toBox:IMoveGrid = ZHitTester.checkIMoveGrid(IMoveGrid);
				if(toBox)
				{
					moveItem(fromData,toBox,toGridKey);
				}						
			}
//			PackSource.startDrag=false;
		}

		private function onMouseDown(e:MouseEvent):void
		{
			_isInside = false;
			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp);
		}
		
		protected function onStageUp(e:MouseEvent):void
		{
//			DragManager.Instance.onMouseUp();
			StageProxy.Instance.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageUp);
			if(_isInside == true) return;
			else
			{
				var crtChildAry1:Array = LayerManager.WindowLayer.getObjectsUnderPoint(new Point(StageProxy.Instance.stage.mouseX, 
					StageProxy.Instance.stage.mouseY));
				
				var crtChildAry2:Array = LayerManager.UIViewRoot.getObjectsUnderPoint(new Point(StageProxy.Instance.stage.mouseX, 
					StageProxy.Instance.stage.mouseY));
				
				var fromDragVo:DragData = DragManager.Instance.dragVo as DragData;
				
				if(fromDragVo && crtChildAry1.length == 0 && crtChildAry2.length == 0)
				{
					if(fromDragVo.data.type == TypeProps.ITEM_TYPE_PROPS)
					{
						if(PropsDyManager.instance.getPropsInfo(fromDragVo.data.id))
						{
							var id:int=PropsDyManager.instance.getPropsInfo(fromDragVo.data.id).templateId;
							if(PropsBasicManager.Instance.getPropsBasicVo(id).type != TypeProps.PROPS_TYPE_TASK)
								warnning(fromDragVo);
							else
								NoticeManager.setNotice(NoticeType.Notice_id_335);
						}
					}
					else if(fromDragVo.data.type == TypeProps.ITEM_TYPE_EQUIP)
						warnning(fromDragVo);
				}
				
			}			
			
		}
		
		protected function onDelAlter(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex == BagSource.ALTER_COMFIRM)
			{
				var fromData:DragData=e.data as DragData;
				if(isPack)
				{
					var msg:CRemoveFromPackReq=new CRemoveFromPackReq();
					var item:Unit=new Unit();
					item.id=fromData.data.id;
					item.type=fromData.data.type;
					msg.item=new Unit();
					msg.item=item;
					msg.pos=fromData.fromID;
					
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CRemoveFromPackReq,msg);
				}
				else
				{
					var msg1:CRemoveFromDepotReq=new CRemoveFromDepotReq();
					var item1:Unit=new Unit();
					item1.id=fromData.data.id;
					item1.type=fromData.data.type;
					msg1.item=new Unit();
					msg1.item=item1;
					msg1.pos=fromData.fromID;
					
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CRemoveFromDepotReq,msg1);
				}
			}
		}

		protected function rollOverHandler(e:MouseEvent):void
		{
			if(_boxType == TypeProps.STORAGE_TYPE_PACK)
			{
				if(BagSource.shopSell)
				{
					MouseManager.changeMouse(MouseStyle.SELL);
				}
				else if(BagSource.shopMend)
				{
					MouseManager.changeMouse(MouseStyle.FIX);
				}
			}		
		}
		protected function rollOutHandler(e:MouseEvent):void
		{
			if(_boxType == TypeProps.STORAGE_TYPE_PACK)
			{
				MouseManager.resetToDefaultMouse();	
			}		
		}
		
		//======================================================================
		//        getter&setter
		//======================================================================	
		public function get moveGrids():HashMap
		{
			return _moveGrids;
		}

		public function get lastPos():int
		{
			return _lastPos;
		}

		
	}
} 