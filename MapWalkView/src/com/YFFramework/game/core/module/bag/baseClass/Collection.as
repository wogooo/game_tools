package com.YFFramework.game.core.module.bag.baseClass
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.manager.BagStoreManager;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.ZHitTester;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.YFFramework.game.core.module.skill.window.DragData;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.msg.item.Unit;
	import com.msg.storage.CMoveItemReq;
	import com.msg.storage.CPutToBodyReq;
	import com.msg.storage.CRemoveFromDepotReq;
	import com.msg.storage.CRemoveFromPackReq;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @version 1.0.0
	 * creation time：2012-11-22 上午11:52:09
	 * 
	 */
	
	
	public class Collection extends Sprite
	{
		//======================================================================
		//        const variable
		//======================================================================
		private static const WIDTH:int=42;
		private static const PAGE_NUM:int=35;
		private static const TXT_NUM:int=7;
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================
		private var _closeGridsContainer:Sprite;
		private var _gridsContainer:Sprite;
		private var _bgContainer:Sprite;
		
		private var _moveGrids:HashMap;
		
		private var _closeGrids:Vector.<MoveGrid>;
		private var _num:int;
		
		public var _boxType:int;
		
		private var _alter:Alert;
		private var _fromDragVo:DragData;
		private var _isInside:Boolean;
		
		private var _offset:int;
		private var isPack:Boolean;
		
		private var _curPage:int;
		
		private var lastPage:int=-1;
		//======================================================================
		//        constructor
		//======================================================================
		public function Collection(boxType:int)
		{
			_closeGridsContainer=new Sprite();
			_gridsContainer=new Sprite();
			_bgContainer=new Sprite();
			
			addChild(_bgContainer);
			addChild(_gridsContainer);
			addChild(_closeGridsContainer);

			_moveGrids=new HashMap();
			_closeGrids=new Vector.<MoveGrid>(PAGE_NUM);
			
			_boxType=boxType;//判定未开启的格子是仓库还是背包
			
			if(boxType == TypeProps.STORAGE_TYPE_PACK)
			{
				_offset=PackSource.PACK_OFFSET;
				isPack=true;
			}
			else if(boxType == TypeProps.STORAGE_TYPE_DEPOT)
			{
				_offset=PackSource.DEPOT_OFFSET;
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
			
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		} 

		//======================================================================
		//        function
		//======================================================================
		public function init():void
		{
			var packArr:Array=[];
			
			if(isPack)
				packArr=BagStoreManager.instantce.getAllPackArray();
			else
				packArr=BagStoreManager.instantce.getAllDepotArray();
			
			for(var i:int=0;i<packArr.length;i++)
			{
				var item:ItemDyVo=packArr[i] as ItemDyVo;
				var grid:MoveGrid=new MoveGrid();
				grid.setContent(item);
				if(isPack)
					grid.boxType=TypeProps.STORAGE_TYPE_PACK;
				else
					grid.boxType=TypeProps.STORAGE_TYPE_DEPOT;
				_moveGrids.put(grid.info.pos,grid);
			}
			
		}
		
		public function updateAllGrid(tabIndex:int,pageIndex:int):void
		{
			_curPage=pageIndex;
			
			clearAllContent();
			
			init();
		}
		
		public function updateSomeGrid(tabIndex:int,pageIndex:int):void
		{
			_curPage=pageIndex;
			
			var newArr:Array;
			if(isPack)
				newArr=BagStoreManager.instantce.newPackCells;
			else
				newArr=BagStoreManager.instantce.newDepotCells;
			
			for each(var item:ItemDyVo in newArr)
			{
				var grid:MoveGrid=_moveGrids.get(item.pos)
				if(grid)
				{
					_moveGrids.remove(item.pos);
					grid.dispose();
					if(grid.parent)
						grid.parent.removeChild(grid);
				}
			}
			
			var updateGrids:Array=[];
			for(var i:int=0;i<newArr.length;i++)
			{
				var moveGrid:MoveGrid=new MoveGrid();
				moveGrid.setContent(newArr[i]);
				if(isPack)
					moveGrid.boxType=TypeProps.STORAGE_TYPE_PACK;
				else
					moveGrid.boxType=TypeProps.STORAGE_TYPE_DEPOT;
				_moveGrids.put(moveGrid.info.pos,moveGrid);
				updateGrids.push(moveGrid);
				
			}
			
			updateTab(tabIndex,pageIndex,updateGrids);
			
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
				if(tabIndex != PackSource.TAB_ALL)
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
				grids=_moveGrids.values();
				grids.sortOn("actualPos");
			}
			
			switch(tabIndex)
			{
				case PackSource.TAB_ALL:
					hideAllCloseContent();//否则页面切换回来都是关闭的格子
					if(((pageIndex+1)*PAGE_NUM - openNum) <= 0)//初始开了35，在第一页;或者全开
					{
						if(newGrids == null || _curPage != lastPage)
							hideAllContent();
						displayGrid(grids,pageIndex*PAGE_NUM,(pageIndex+1)*PAGE_NUM,tabIndex,pageIndex);
					}
					else if(((pageIndex+1)*PAGE_NUM - openNum) > 0)//翻到半关,或者全关有文字
					{
						displayCloseGrid(openNum,pageIndex);
						
						if(newGrids == null || _curPage != lastPage)
							hideAllContent();			
						displayGrid(grids,pageIndex*PAGE_NUM,openNum,tabIndex,pageIndex);
					}
					break;
				case PackSource.TAB_CONSUME:
				case PackSource.TAB_EQUIPMENT:
				case PackSource.TAB_MATERIAL:
				case PackSource.TAB_MISSION:
					hideAllCloseContent();
					if(newGrids == null || _curPage != lastPage)
						hideAllContent();
					displayGrid(grids,pageIndex*PAGE_NUM,openNum,tabIndex,pageIndex);
					break;
			}
			
			lastPage=_curPage;
//			trace("显示完成！共有子对象：",this.numChildren)
		}
		
		public function updateGridNum(pos:int):void
		{
			var grid:MoveGrid=_moveGrids.get(pos);
			var num:int=PropsDyManager.instance.getPropsInfo(grid.info.id).quantity;
			grid.changePropsNum(num);
		}
		
		/**
		 * 高亮某个格子 
		 * @param pos
		 * 
		 */		
		public function highLight(pos:int):void
		{
			clearAllFilter();
			var grid:MoveGrid=_moveGrids.get(pos);
			grid.highLight();
			grid.selected=true;
		}
		
		public function playCd(cdArray:Array):void
		{
			for each(var pos:int in cdArray)
			{
				var grid:MoveGrid=_moveGrids.get(pos);
				grid.playCd();
			}

		}
		
		//======================================================================
		//        private function
		//======================================================================
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
					case PackSource.TAB_ALL://除了任务道具
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
							templateId=PropsDyManager.instance.getPropsInfo(grid.info.id).templateId;
							if(PropsBasicManager.Instance.getPropsBasicVo(templateId).type != TypeProps.PROPS_TYPE_TASK)
							{
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
					case PackSource.TAB_CONSUME://药品、驯养道具、喂养道具等常用消耗品
						if(grid.info.type == TypeProps.ITEM_TYPE_PROPS)
						{
							templateId=PropsDyManager.instance.getPropsInfo(grid.info.id).templateId;
							if(PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_DRUG ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_COMFORT ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_FEED )
							{
								tmpArr.push(grid);
							}	
						}
						break;
					case PackSource.TAB_EQUIPMENT:
						if(grid.info.type == TypeProps.ITEM_TYPE_EQUIP)
						{
							tmpArr.push(grid);
						}
						break;
					case PackSource.TAB_MATERIAL://装备强化材料、宝石、宠物强化材料、领悟材料、技能书、洗练材料等材料
						if(grid.info.type == TypeProps.ITEM_TYPE_PROPS)
						{
							templateId=PropsDyManager.instance.getPropsInfo(grid.info.id).templateId;
							var propsResetId:int=ConstMapBasicManager.Instance.getConstMapBasicVo(TypeProps.CONST_ID_PET_RESET).tmpl_id;
							if(PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_ENHANCE ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_GEM ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_ENHANCE ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_COMPRE ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_SKILLBOOK ||
								PropsBasicManager.Instance.getPropsBasicVo(templateId).type == TypeProps.PROPS_TYPE_PET_SOPHI ||
								templateId == propsResetId)
							{
								tmpArr.push(grid);
							}	
						}
						break;
					case PackSource.TAB_MISSION:
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
			}
			else//全关没文字
			{
				hideAllCloseContent();
				clearTxt();
				for(i = 0 ; i < PAGE_NUM ; i++)
				{
					_closeGridsContainer.addChild(_closeGrids[i]);			
				}
			}
		}
		
		/**
		 * 显示关闭格子上的文字 
		 * @param start 从
		 * 
		 */		
		private function displayTxt(start:int):void
		{
			var j:int=0;
			for(var i:int = start;i < start+7 ;i++)
			{
				if(isPack)
				{
					var a:String=PackSource.EXTEND_PACK_GRID_TXT.charAt(i);
					_closeGrids[i].setExtendGridTxt(PackSource.EXTEND_PACK_GRID_TXT.charAt(j));
				}
				else
				{
					_closeGrids[i].setExtendGridTxt(PackSource.EXTEND_DEPOT_GRID_TXT.charAt(j));
				}
				j++;
			}
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
			while(_closeGridsContainer.numChildren > 0)
			{
				_closeGridsContainer.removeChildAt(0);
			}
			
		}
		
		//////////////////////////三个清除方法：滤镜，关闭的格子，开启的
		private function clearAllFilter():void
		{	
			var arr:Array=_moveGrids.values();
			for(var i:int=0;i<arr.length;i++)
			{
				var grid:MoveGrid=arr[i];
				if(grid.selected)
				{
					grid.clearFilter();
					grid.selected=false;
				}
			}

		}
		
		/**
		 * 清除开启的格子 ,释放并且
		 * 
		 */		
		private function clearAllContent():void
		{
			var arr:Array=_moveGrids.values();
			for each(var grid:MoveGrid in arr)
			{
				grid.dispose();	
				_moveGrids.remove(grid.actualPos);
			}
			hideAllContent();
		}
		
		/**
		 * 清除关闭格子上的文字 
		 * 
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
		private function moveItem(toGrid:IMoveGrid,toGridKey:int):void
		{
			var movDirect:int=0;
			var fromPos:int;
			var toPos:int;
			
			//背包移到背包，背包移到仓库\装备
			fromPos=_fromDragVo.fromID;
			if(_fromDragVo.type == DragData.FROM_BAG)//从背包里
			{
				if(toGrid.boxType == TypeProps.STORAGE_TYPE_PACK && toGridKey <= BagStoreManager.instantce.getPackNum())
				{
					toPos=toGridKey+PackSource.PACK_OFFSET;
					movDirect=TypeProps.MOV_DIRECT_PACK_TO_PACK;
				}
				else if(toGrid.boxType == TypeProps.STORAGE_TYPE_DEPOT && toGridKey <= BagStoreManager.instantce.getDepotNum())
				{
					toPos=toGridKey+PackSource.DEPOT_OFFSET;				
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
			else if(_fromDragVo.type == DragData.FROM_DEPOT)//从仓库里
			{
				if(toGrid.boxType == TypeProps.STORAGE_TYPE_PACK && toGridKey <= BagStoreManager.instantce.getPackNum())
				{
					toPos=toGridKey+PackSource.PACK_OFFSET;							
					movDirect=TypeProps.MOV_DIRECT_DEPOT_TO_PACK;
				}
				else if(toGrid.boxType == TypeProps.STORAGE_TYPE_DEPOT && toGridKey <= BagStoreManager.instantce.getDepotNum())
				{
					toPos=toGridKey+PackSource.DEPOT_OFFSET;
					movDirect=TypeProps.MOV_DIRECT_DEPOT_TO_DEPOT;
				}
				
			}
			else if(_fromDragVo.type == DragData.FROM_CHARACTER)
			{
				if(toGrid.boxType == TypeProps.STORAGE_TYPE_PACK && toGridKey <= BagStoreManager.instantce.getPackNum())
				{
					toPos=toGridKey+PackSource.PACK_OFFSET;							
					movDirect=TypeProps.MOV_DIRECT_BODY_TO_PACK;
				}
			}
			if(fromPos != toPos)
			{
				var msg:CMoveItemReq=new CMoveItemReq();
				var item:Unit=new Unit();
				item.id=_fromDragVo.data.id;
				item.type=_fromDragVo.data.type;
				msg.movDirect=movDirect;
				msg.sourcePos=fromPos;
				msg.targetPos=toPos;
				msg.item=item;
//				trace("发送：propsId",item.id,"pos",PropsDyManager.instance.getPropsPostion(item.id))
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
		
		protected function warnning():void
		{			
			var str:String='';
			var templateId:int=0;
			
			var buttonLabels:Array = ["确认","取消"];
			
			if(_fromDragVo.data.type == TypeProps.ITEM_TYPE_PROPS)
			{
				if(PropsDyManager.instance.getPropsInfo(_fromDragVo.data.id))
				{
					templateId=PropsDyManager.instance.getPropsInfo(_fromDragVo.data.id).templateId;
					if(PropsBasicManager.Instance.getPropsBasicVo(templateId).binding_type == TypeProps.BIND_TYPE_YES)
					{
						str="确认销毁【*】?";
						str = str.replace("*",PropsBasicManager.Instance.getPropsBasicVo(templateId).name);
						_alter=Alert.show(str,"确认删除",onDelAlter,buttonLabels);
					}
					else if(PropsBasicManager.Instance.getPropsBasicVo(templateId).binding_type == TypeProps.BIND_TYPE_NO)
					{
						str="确认丢弃【*】?";
						str = str.replace("*",PropsBasicManager.Instance.getPropsBasicVo(templateId).name);
						_alter=Alert.show(str,"确认删除",onDelAlter,buttonLabels);
					}
				}
			}
			else if(_fromDragVo.data.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				if(EquipDyManager.instance.getEquipInfo(_fromDragVo.data.id))
				{
					templateId=EquipDyManager.instance.getEquipInfo(_fromDragVo.data.id).template_id;
					if(EquipBasicManager.Instance.getEquipBasicVo(templateId).binding_type == TypeProps.BIND_TYPE_YES)
					{
						str="确认销毁【*】?";
						str = str.replace("*",PropsBasicManager.Instance.getPropsBasicVo(templateId).name);
						_alter=Alert.show(str,"确认删除",onDelAlter,buttonLabels);
					}
					else if(EquipBasicManager.Instance.getEquipBasicVo(templateId).binding_type == TypeProps.BIND_TYPE_NO)
					{
						str="确认丢弃【*】?";
						str = str.replace("*",EquipBasicManager.Instance.getEquipBasicVo(templateId).name);
						_alter=Alert.show(str,"确认删除",onDelAlter,buttonLabels);
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
			if(DragManager.Instance.dragVo )
			{
				_fromDragVo = DragManager.Instance.dragVo as DragData;
				
				var posX:int=this.mouseX;
				var posY:int=this.mouseY;
				
				var x:int=int(posX/WIDTH);
				var y:int=int(posY/WIDTH);
				
				var toGridKey:int=_curPage*PAGE_NUM+y*PackSource.ROW_GRIDS+x;
//				trace(toGridKey)
				var toBox:IMoveGrid = ZHitTester.checkIMoveGrid(IMoveGrid);
				if(toBox)
				{
					moveItem(toBox,toGridKey);
				}						
			}
				
		}

		private function onMouseDown(e:MouseEvent):void
		{
			_isInside = false;
			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp);
		}
		
		protected function onStageUp(e:MouseEvent):void
		{
			StageProxy.Instance.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageUp);
			if(_isInside == true) return;
			else
			{
				var crtChildAry1:Array = LayerManager.WindowLayer.getObjectsUnderPoint(new Point(StageProxy.Instance.stage.mouseX, 
					StageProxy.Instance.stage.mouseY));
				
				var crtChildAry2:Array = LayerManager.UIViewRoot.getObjectsUnderPoint(new Point(StageProxy.Instance.stage.mouseX, 
					StageProxy.Instance.stage.mouseY));
				
				_fromDragVo = DragManager.Instance.dragVo as DragData;
				
				if(fromDragVo && crtChildAry1.length == 0 && crtChildAry2.length == 0)
				{
					if(fromDragVo.data.type == TypeProps.ITEM_TYPE_PROPS)
					{
						if(PropsDyManager.instance.getPropsInfo(fromDragVo.data.id))
						{
							var id:int=PropsDyManager.instance.getPropsInfo(fromDragVo.data.id).templateId;
							if(PropsBasicManager.Instance.getPropsBasicVo(id).type != TypeProps.PROPS_TYPE_TASK)
								warnning();
						}
					}
					else if(fromDragVo.data.type == TypeProps.ITEM_TYPE_EQUIP)
						warnning();
				}
				
			}			
			
		}
		
		protected function onDelAlter(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex == PackSource.ALTER_COMFIRM)
			{
				if(isPack)
				{
					var msg:CRemoveFromPackReq=new CRemoveFromPackReq();
					var item:Unit=new Unit();
					item.id=_fromDragVo.data.id;
					item.type=_fromDragVo.data.type;
					msg.item=new Unit();
					msg.item=item;
					msg.pos=_fromDragVo.fromID;
					
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CRemoveFromPackReq,msg);
				}
				else
				{
					var msg1:CRemoveFromDepotReq=new CRemoveFromDepotReq();
					var item1:Unit=new Unit();
					item1.id=_fromDragVo.data.id;
					item1.type=_fromDragVo.data.type;
					msg1.item=new Unit();
					msg1.item=item1;
					msg1.pos=_fromDragVo.fromID;
					
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CRemoveFromDepotReq,msg1);
				}
			}
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		public function get fromDragVo():DragData
		{
			return _fromDragVo;
		}
		
		public function get moveGrids():HashMap
		{
			return _moveGrids;
		}
		
	}
} 