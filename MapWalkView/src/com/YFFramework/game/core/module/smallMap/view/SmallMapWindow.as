package com.YFFramework.game.core.module.smallMap.view
{
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFScroller;
	import com.YFFramework.core.ui.yfComponent.controls.YFTreeCell;
	import com.YFFramework.game.core.module.smallMap.view.list.MonsterZoneList;
	import com.YFFramework.game.core.module.smallMap.view.list.SmallMapListCell;
	import com.YFFramework.game.core.module.smallMap.view.list.SmallMapListView;
	import com.YFFramework.game.core.module.smallMap.view.list.SmallMapNPCList;
	import com.YFFramework.game.core.module.smallMap.view.list.TransferList;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	/**小窗口
	 * 2012-11-5 下午5:13:00
	 *@author yefeng
	 */
	public class SmallMapWindow extends GameWindow
	{
		public var _smallMapView:SmallMapView;
		/// npc 列表
		private var _npcListView:SmallMapNPCList;
		/// 传送点 列表
		private var _transferList:TransferList;
		
		private var _monsterZoneList:MonsterZoneList;
		
		private var _listContainer:VContainer;
		
		private var _scroller:YFScroller;
		public function SmallMapWindow()
		{
			super(553,400);
		}
		override protected function initUI():void
		{
			super.initUI();
			_smallMapView=new SmallMapView();
			addChild(_smallMapView);
			_smallMapView.y=_bgBody.y;
			_listContainer=new VContainer(1);

			_transferList=new TransferList();
			_listContainer.addChild(_transferList);

			_npcListView=new SmallMapNPCList();
			_listContainer.addChild(_npcListView);

			_monsterZoneList=new MonsterZoneList();
			_listContainer.addChild(_monsterZoneList);
			
			_scroller=new YFScroller(_listContainer,_mHeight-_bgBody.y) //
			_scroller.addChild(_listContainer);
			addChild(_scroller);
			_scroller.x=400;
			_scroller.y=_smallMapView.y


			updateView();
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_npcListView.addEventListener(MouseEvent.CLICK,onClickEvent);
			_transferList.addEventListener(MouseEvent.CLICK,onClickEvent);
			_monsterZoneList.addEventListener(MouseEvent.CLICK,onClickEvent);
		}

		
		/**初始化配置文件的 ui
		 * xxObj是地图文件数据对象
		 */		
		public function updateConfigUI(xxObj:Object):void
		{
			/// 传送点  动画   
			
			_transferList.updateContent(xxObj);
			///npc 
			_npcListView.updateContent(_smallMapView.npcList);
			/// 怪物区域
			_monsterZoneList.updateContent(xxObj);
			updateView();
			//小地图更新配置
			_smallMapView.updateMapConfig(xxObj);
		}
		
		private function setSelect(display:DisplayObject,list:SmallMapListView):void
		{
			_transferList.setContentUnSelect();
			_npcListView.setContentUnSelect();
			_monsterZoneList.setContentUnSelect();
			list.setSelect(display);
		}
		
		
		
		private function onClickEvent(e:MouseEvent):void
		{
			if(e.target is YFButton)  ///点击的为按钮 而不是小图标
			{ 
				var target:YFButton=e.target as YFButton;
				var cell:SmallMapListCell=target.parent as SmallMapListCell;
				switch(e.currentTarget)
				{
					case _npcListView:
						var dyId:uint=cell.data.dyId; ///npc id 
						_smallMapView.closeToNPC(dyId); ///向npc靠近
						setSelect(cell,_npcListView );
						break;
					case _transferList:
						var pt:Point=cell.data as Point;
						_smallMapView.updateMoveToPt(pt);
						setSelect(cell,_transferList );
						break;
					case _monsterZoneList:
						var monsterPt:Point=cell.data as Point;
						_smallMapView.updateMoveToPt(monsterPt);
						setSelect(cell,_monsterZoneList );
						break;
				}
				
			}
			else if(e.target is YFTreeCell)
			{
				updateView();
			}
				
		}
		
		
		
		
		///优化 ： 只有当窗口弹出来时才进行逻辑响应
		
		override public function popUp():void
		{
			super.popUp();
			_smallMapView.updatePop(true);
		}

		override public function popBack():void
		{
			super.popBack();
			_smallMapView.updatePop(false);
		}

		
		private function updateView():void
		{
			_transferList.updateView();
			_npcListView.updateView();
			_monsterZoneList.updateView();
			_listContainer.updateView();
			_scroller.updateView();
		}
		
		
		
		
		
		
	}
}