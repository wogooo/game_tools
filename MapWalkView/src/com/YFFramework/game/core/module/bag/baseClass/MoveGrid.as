package com.YFFramework.game.core.module.bag.baseClass
{
	import com.YFFramework.core.center.manager.dbClick.DBClickManager;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.YFFramework.game.core.module.skill.window.DragData;
	import com.dolo.ui.tools.Xtip;
	import com.msg.item.Unit;
	import com.msg.storage.CMoveItemReq;
	import com.msg.storage.CSellItemReq;
	
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2012-11-15 下午03:31:10
	 * 
	 */
	
	
	public class MoveGrid extends BagGrid implements IMoveGrid
	{
		//======================================================================
		//        const variable
		//======================================================================
		
		//======================================================================
		//        static variable
		//======================================================================
		/**
		 *基本不用动原有的东西，可以添加 
		 */		
		//======================================================================
		//        variable
		//======================================================================
		private var _isDoubleClick:Boolean;
		private var MendFactor:Number=1.0;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MoveGrid()
		{			
//			super(id);
			this.addEventListener(MouseEvent.CLICK,onMouseClick);
			DBClickManager.Instance.regDBClick(this,onMouseDoubleClick);
		}		
		
		//======================================================================
		//        function
		//======================================================================		
		override public function dispose():void
		{
			super.dispose();
			this.removeEventListener(MouseEvent.CLICK,onMouseClick);
			DBClickManager.Instance.delDBClick(this);
		}
		
		/**
		 * 处理宠物模块发来的请求使用道具 
		 * @param grid
		 * 
		 */		
		public function mouseDoubleClickHandler(grid:MoveGrid):void
		{			
			if(grid.info != null)
			{			
				dispatchEvent(new BagEvent(BagEvent.USE_ITEM,info,true));
				PackSource.popUp=false;
			}		
		}
		//======================================================================
		//        private function
		//======================================================================
		private function startDragGrid(fromBox:MoveGrid):void
		{			
			if(fromBox && fromBox.info != null )
			{
				var dragVO:DragData = new DragData();
				dragVO.data=new Object();
				dragVO.fromID = info.pos;
				if(boxType == TypeProps.STORAGE_TYPE_PACK)
				{
					dragVO.type = DragData.FROM_BAG;
				}
				else
				{
					dragVO.type = DragData.FROM_DEPOT;
				}
				dragVO.data.type = info.type;
				dragVO.data.id = info.id;
				clearFilter();
				DragManager.Instance.startDrag(this,dragVO);
				Xtip.clearTip(this);
			}
			
		}

		//======================================================================
		//        event handler
		//======================================================================
		protected function onMouseDoubleClick():void
		{
			_isDoubleClick = true;
			mouseDoubleClickHandler(this);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			if(_isDoubleClick) return;
			else
			{
				if(info)
				{
					if(PackSource.openStore)
					{
						if(info.pos !=0)
						{
							var msg:CMoveItemReq=new CMoveItemReq();
							msg.item=new Unit();
							
							if(boxType == TypeProps.STORAGE_TYPE_PACK)
							{
								msg.movDirect=TypeProps.MOV_DIRECT_PACK_TO_DEPOT;
								msg.sourcePos=info.pos;					
								
							}
							else if(boxType == TypeProps.STORAGE_TYPE_DEPOT)
							{
								msg.movDirect=TypeProps.MOV_DIRECT_DEPOT_TO_PACK;
								msg.sourcePos=info.pos;
							}				
							
							msg.targetPos=-1;
							var item:Unit=new Unit();
							item.id=info.id;
							item.type=info.type;
							msg.item=new Unit();
							msg.item=item;
							YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CMoveItemReq,msg);
						}
					}
					else
					{
						dispatchEvent(new BagEvent(BagEvent.POP_UP_SECOND_MENU,info.pos,true));
						PackSource.popUp=true;
					}		
				}
			}
		}
		
		override protected function onMouseDownHandler(e:MouseEvent):void
		{
			super.onMouseDownHandler(e);
			
			_isDoubleClick = false;
			startDragGrid(this);

			//开启格子
			if(cover.parent)		
			{
				dispatchEvent(new BagEvent(BagEvent.OPEN_GRID,null,true));
			}
			
			//出售东西
			if(PackSource.shopSell && info)
			{
				var msg:CSellItemReq=new CSellItemReq();
				msg.sourcePos=info.pos;
				YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSellItemReq,msg);
			}
			
			//修理装备
			if(PackSource.shopMend)
			{
				if(info && info.type == TypeProps.ITEM_TYPE_EQUIP)
				{
					var curDurability:int=EquipDyManager.instance.getEquipInfo(info.id).cur_durability;
					var tmpId:int=EquipDyManager.instance.getEquipInfo(info.id).template_id;
					var equip:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(tmpId);
					var allDurability:int=EquipBasicManager.Instance.getEquipBasicVo(equip.template_id).durability;
					if(curDurability < allDurability)
					{
						var needMoney:int=DataCenter.Instance.roleSelfVo.silver+DataCenter.Instance.roleSelfVo.note;
						var consumeMoney:int=equip.level*(allDurability-curDurability)*MendFactor;
						if(needMoney > consumeMoney)
						{
							YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CRepairEquipReq,info.pos);
						}
					}
				}
			}
			
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		public function get boxKey():int
		{
			return actualPos;
		}
		
	}
} 