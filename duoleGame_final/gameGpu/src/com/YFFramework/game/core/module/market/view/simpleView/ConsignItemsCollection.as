package com.YFFramework.game.core.module.market.view.simpleView
{
	/**
	 * 寄售、求购、筛选面板，用这个来统一处理
	 * 构造函数：mc-> 要把items显示的容器；classNmae->要填充的类名
	 * @version 1.0.0
	 * creation time：2013-6-3 下午1:55:59
	 * 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.market.data.manager.MarketConfigBasicManager;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.dolo.common.ObjectPool;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Align;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class ConsignItemsCollection extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:Sprite;
		
		private var _items:Array;
		
		private var _itemsPool:ObjectPool;

		//======================================================================
		//        constructor
		//======================================================================
		
		public function ConsignItemsCollection(mc:Sprite,className:Class)
		{
			_mc=mc;
			
			_itemsPool=new ObjectPool(className);
	
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 专为筛选面板提供的方法
		 * 1.如果subType>=0(subType==0时，代表在全部范围内筛选)，itemType、itemId肯定是0；curLevel、curQuality肯定有数据
		 * 2.subType<0(没有子类插叙，只有单个查询)，itemType、itemId肯定有后两项;curLevel、curQuality肯定是-1
		 * 3.subType\itemType\itemId分别为-1,、0、0，说明不查任何数据
		 * @param subType 是-1的时候，不做任何查询，不管是子类还是某个信息
		 * @param itemType
		 * @param itemId
		 * @param curLevel
		 * @param curQuality
		 * 
		 */			
		public function initIconsData(subType:int=0,itemType:int=0,itemId:int=0,
									  curLevel:int=MarketSource.LEVEL_ALL,curQuality:int=MarketSource.QUALITY_ALL):void
		{
			var dataLength:int;
			var data:Array=[];
			_items=[];
			
			_mc.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			if(subType >= 0 && itemType == 0 && itemId == 0)//和后面两个curLevel、curQuality条件一起做子类筛选查询
			{
				data = MarketConfigBasicManager.Instance.getSubTypeAry(subType,curLevel,curQuality);
				dataLength=data.length;
			}
			else if(subType < 0 && itemType > 0 && itemId > 0)//单个物品查询
			{
				data = [MarketConfigBasicManager.Instance.getItemInfo(itemType,itemId)];
				dataLength=data.length;
			}
			else if(subType < 0 && itemType == 0 && itemId == 0)//不做任何查询
			{
				return;
			}		
			
			for(var i:int=0;i<dataLength;i++)
			{
				var item:ItemIcon=_itemsPool.getObject();
				item.setIconType(MarketSource.SIFT);
				item.setTemplateIcon(data[i].item_type,data[i].item_id);
				_items.push(item);
			}

		}
		
		/**
		 * 从什么序号开始：page(从0开始)*MarketSource.PAGE_NUM
		 * @param start
		 * 
		 */		
		public function flushIconsPage(start:int,end:int):void
		{
			var len:int;
			if(end > _items.length)
			{
				len=_items.length;
			}
			else
			{
				len = end;
			}
			
			UI.removeAllChilds(_mc);
			
			for(var i:int=start; i<len ;i++)
			{
				if(_items[i])
				{
					_items[i].x = ( (i % MarketSource.PAGE_NUM) % MarketSource.ROW_NUM) * MarketSource.ICON_WIDTH;
					_items[i].y = int( (i % MarketSource.PAGE_NUM) / MarketSource.ROW_NUM) * MarketSource.ICON_WIDTH;
					_mc.addChild(_items[i]);
				}
			}
		}
		
		/** 
		 * 清除数据，并且把对象放回对象池
		 */		
		public function disposeIcons():void
		{
			UI.removeAllChilds(_mc);
			_mc.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			for each(var icon:ItemIcon in _items)
			{
				icon.disposeContent();
				icon.removeListener();
				_itemsPool.returnObject(icon);
			}
		}
		
		/***************************************************************************************************************/
		
		public function initConsignPurchaseData(type:int):void
		{
			var data:Array=[];
			_items=[];
			
			if(type == MarketSource.CONSIGH)
				data=MarketDyManager.instance.getCurPageConsignList();
			else
				data= MarketDyManager.instance.getCurPagePurchaseList();
			
			var len:int=data.length;
			for(var i:int=0;i<len;i++)
			{
				var item:ConsignPurchaseItem = _itemsPool.getObject();
				item.setContent(type,data[i]);
				item.y = i * MarketSource.RECORD_HEIGHT;
				_items.push(item);
				_mc.addChild(item);
			}
//			Align.gridAllChild(_mc,0,MarketSource.RECORD_HEIGHT,1);
		}

		public function disposeConsignPurchase():void
		{
			UI.removeAllChilds(_mc);
			
			for each(var item:ConsignPurchaseItem in _items)
			{
				item.dispose();
				_itemsPool.returnObject(item);
			}			
		}
		
		/***********************************************************************************************************/
		
		public function initLogData():void
		{
			var data:Array = MarketDyManager.instance.getCurPageMyLogList();
			_items=[];
			
			var len:int=data.length;
			for(var i:int=0;i<len;i++)
			{
				var item:MarketLogItem = _itemsPool.getObject();
				item.setContent(data[i]);
				item.y = i * MarketSource.MY_RECORD_HEIGHT;
				_items.push(item);
				_mc.addChild(item);
			}
			
		}
		
		public function disposeLogData():void
		{
			UI.removeAllChilds(_mc);
			
			for each(var item:MarketLogItem in _items)
			{
				item.dispose();
				_itemsPool.returnObject(item);
			}			
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onMouseUp(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(MarketEvent.RESET_PURCHASE_PANEL);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 