package com.YFFramework.game.core.module.bag.event
{
	/**
	 * @version 1.0.0
	 * creation time：2012-11-26 下午12:03:30
	 * 
	 */
	import flash.events.Event;
	
	public class BagEvent extends Event
	{
		//======================================================================
		//        const variable
		//======================================================================
		public static const path:String="com.YFFramework.game.core.module.bag.event.";
		
		/**使用东西
		 */		
		public static const USE_ITEM:String=path+"USE_ITEM";
		/**弹出二级菜单
		 */		
		public static const POP_UP_SECOND_MENU:String=path+"POP_UP_SECOND_MENU";
		/** 开启背包格子
		 */		
		public static const OPEN_BAG_GRID:String=path+"OPEN_BAG_GRID";
		/** 开启仓库格子
		 */		
		public static const OPEN_STORE_GRID:String=path+"OPEN_STORE_GRID";
		/**丢弃物品
		 */		
		public static const ABANDON_ITEM:String=path+"ABANDON_ITEM";
		/**打开人物属性面板
		 */		
		public static const OPEN_CHARACTER:String=path+"OPEN_CHARACTER";
		/**弹出菜单的序号
		 */		
		public static const POP_UP_INDEX:String=path+"POP_UP_INDEX";
		/**移动到交易面板
		 */		
		public static const MOVE_TO_TRADE:String=path+"MOVE_TO_TRADE";
		/**移动到寄售物品面板
		 */		
		public static const MOVE_TO_CONSIGHITEM:String=path+"MOVE_TO_CONSIGHITEM";
		/**成功从交易移动到背包（解锁）
		 */		
		public static const MOVE_TO_BAG_SUCC:String=path+"MOVE_TO_BAG_SUCC";
		/**扩展包裹：请求
		 */		
//		public static const BAG_UI_CExpandStorageReq:String=path+"BAG_UI_CExpandStorageReq";
		/**给角色身上装备物品：请求
		 */		
		public static const BAG_UI_CPutToBodyReq:String=path+"BAG_UI_CPutToBodyReq";
		/**从背包指定位置移除一个物品：请求
		 */		
		public static const BAG_UI_CRemoveFromPackReq:String=path+"BAG_UI_CRemoveFromPackReq";
		/**从仓库指定位置移除一个物品：请求
		 */		
		public static const BAG_UI_CRemoveFromDepotReq:String=path+"BAG_UI_CRemoveFromDepotReq";
		/**移动物品：请求
		 */		
		public static const BAG_UI_CMoveItemReq:String=path+"BAG_UI_CMoveItemReq";
		/**出售物品：请求
		 */		
		public static const BAG_UI_CSellItemReq:String=path+"BAG_UI_CSellItemReq";
		/**修理装备：请求
		 */		
		public static const BAG_UI_CRepairEquipReq:String=path+"BAG_UI_CRepairEquipReq";
		/**拆分物品：请求
		 */		
		public static const BAG_UI_CSplitItemReq:String=path+"BAG_UI_CSplitItemReq";
		/**背包整理：请求
		 */		
		public static const BAG_UI_CSortPackReq:String=path+"BAG_UI_CSortPackReq";
		/**仓库整理：请求
		 */		
		public static const BAG_UI_CSortDepotReq:String=path+"BAG_UI_CSortDepotReq";
		/**选中Item
		 */		
		public static const ITEM_SELECT:String=path+"ITEM_SELECT";
		/** 时效性物品到时间后删除：请求
		 */		
		public static const BAG_CDelItemReq:String=path+"BAG_CDelPropsReq";
		//======================================================================
		//        static variable
		//======================================================================
		public var data:Object;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data=data;
			super(type, bubbles, cancelable);
			
		}
		//======================================================================
		//        variable
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================

		
		
		
		//======================================================================
		//        function
		//======================================================================
		
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