package com.YFFramework.game.core.module.trade.view.collection
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.trade.events.TradeEvent;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.trade.model.LockItemDyVo;
	import com.YFFramework.game.core.module.trade.view.render.TradeGrid;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-2 下午5:06:54
	 * 交易面板格子Collection
	 */
	public class GridCollection extends Sprite{
		
		private var gridArr:Array;
		private var _actionable:Boolean;
		
		public function GridCollection(actionable:Boolean){
			gridArr = new Array();
			_actionable = actionable;
			if(_actionable)	YFEventCenter.Instance.addEventListener(GlobalEvent.UnlockItem,onUnlockItem);
		}
		
		/**初始化格子背景 
		 */		
		public function init():void{
			for(var i:int=0;i<3;i++){
				for(var j:int=0;j<6;j++){
					var grid:TradeGrid = new TradeGrid(j,i,_actionable);
					gridArr.push(grid);
					addChild(grid);
				}
			}
			if(_actionable)	this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		/**更新对方格子内容 
		 * @param index		对应的格子的index,从0开始
		 * @param itemDyVo	LockItemDyVo
		 */		
		public function loadGridContent(index:int,lockItemDyVo:LockItemDyVo):void{
			TradeGrid(gridArr[index]).loadContent(lockItemDyVo);
		}
		
		/**清除某一格子的内容 
		 * @param index		对应格子的index,从0开始
		 */		
		public function clearGridContentAt(index:int):void{
			TradeGrid(gridArr[index]).clearContent();
		}
		
		/**清除对象 
		 */		
		public function dispose():void{
			var len:int = gridArr.length;
			for(var i:int=0;i<len;i++){
				TradeGrid(gridArr[i]).dispose();
			}
			gridArr.splice(0);
			while(this.numChildren>0)	this.removeChildAt(0);
			if(_actionable){
				YFEventCenter.Instance.removeEventListener(GlobalEvent.UnlockItem,onUnlockItem);
				this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}
		}
		
		/**监听拖动事件 
		 * @param e	MouseUp
		 */		
		private function onMouseUp(e:MouseEvent):void{
			var fromData:DragData = DragManager.Instance.dragVo as DragData;
			if(fromData){
				if(fromData.type==DragData.FROM_BAG){
					if(this.getRect(this).contains(this.mouseX,this.mouseY)){
						if(TradeDyManager.Instance.getMyLockItem().length==21){
							NoticeUtil.setOperatorNotice("交易面板已满");
						}else if(TradeDyManager.isLock==true){
							NoticeUtil.setOperatorNotice("交易面板已锁定");
						}else{
							var canTrade:Boolean=true;
							if(fromData.data.type==TypeProps.ITEM_TYPE_EQUIP){
								if(EquipDyManager.instance.getEquipInfo(fromData.data.id).binding_type==TypeProps.BIND_TYPE_YES){
									canTrade = false;
								}
							}else if(fromData.data.type==TypeProps.ITEM_TYPE_PROPS){
								if(PropsDyManager.instance.getPropsInfo(fromData.data.id).binding_type==TypeProps.BIND_TYPE_YES){
									canTrade = false;
								}
							}
							if(canTrade){
								var itemDyVo:LockItemDyVo = new LockItemDyVo();
								if(fromData.data.type==TypeProps.ITEM_TYPE_EQUIP){
									itemDyVo.templateId = EquipDyManager.instance.getEquipInfo(fromData.data.id).template_id;
									itemDyVo.quantity = 1;
									itemDyVo.url=EquipBasicManager.Instance.getURL(itemDyVo.templateId);
								}else if(fromData.data.type==TypeProps.ITEM_TYPE_PROPS){
									itemDyVo.templateId = PropsDyManager.instance.getPropsInfo(fromData.data.id).templateId;
									itemDyVo.quantity = PropsDyManager.instance.getPropsInfo(fromData.data.id).quantity;
									itemDyVo.url = PropsBasicManager.Instance.getURL(itemDyVo.templateId);
								}
								itemDyVo.pos = fromData.fromID;
								itemDyVo.type = fromData.data.type;
								itemDyVo.dyId = fromData.data.id;
								TradeGrid(gridArr[TradeDyManager.Instance.getMyLockItem().length]).loadContent(itemDyVo);
								TradeDyManager.Instance.addToMyLockItem(itemDyVo);
								YFEventCenter.Instance.dispatchEventWith(GlobalEvent.LockItem,itemDyVo.pos);
								YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
							}else{
								NoticeUtil.setOperatorNotice("绑定物品不能交易");
							}
						}
					}
				}
			}
		}
		
		/**移除锁定物品 
		 * @param e
		 */		
		private function onUnlockItem(e:YFEvent):void{
			var myLockItems:Array=TradeDyManager.Instance.getMyLockItem();
			var len:int = myLockItems.length;
			for(var i:int=0;i<len;i++){
				TradeGrid(gridArr[i]).loadContent(myLockItems[i]);
			}
			TradeGrid(gridArr[len]).clearContent();
		}
	}
} 