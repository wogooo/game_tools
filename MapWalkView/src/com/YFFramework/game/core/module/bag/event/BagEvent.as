package com.YFFramework.game.core.module.bag.event
{
	/**
	 * @version 1.0.0
	 * creation time：2012-11-26 下午12:03:30
	 * 
	 */
	import com.YFFramework.core.event.YFEvent;
	
	import flash.events.Event;
	
	public class BagEvent extends Event
	{
		//======================================================================
		//        const variable
		//======================================================================
		public static const path:String="com.YFFramework.game.core.module.bag.event";
		
		public static const USE_ITEM:String=path+"使用东西";
		
		public static const POP_UP_SECOND_MENU:String=path+"弹出二级菜单";
		
		public static const OPEN_GRID:String=path+"开启格子";
		
		public static const HIGH_LIGHT:String=path+"发光";
		
		public static const OPEN_PET_PANEL:String=path+"打开对应面板";
		
		public static const ABANDON_ITEM:String=path+"丢弃物品";
		
		public static const OPEN_CHARACTER:String=path+"打开人物属性面板";
		
		public static const BAG_UI_CExpandStorageReq:String=path+"扩展包裹：请求";
		public static const BAG_UI_CPutToBodyReq:String=path+"给角色身上装备物品：请求";
		public static const BAG_UI_CRemoveFromPackReq:String=path+"从背包指定位置移除一个物品：请求";
		public static const BAG_UI_CRemoveFromDepotReq:String=path+"从仓库指定位置移除一个物品：请求";
		public static const BAG_UI_CMoveItemReq:String=path+"移动物品：请求";
		public static const BAG_UI_CSellItemReq:String=path+"出售物品：请求";
		public static const BAG_UI_CRepairEquipReq:String=path+"修理装备：请求";
		public static const BAG_UI_CSplitItemReq:String=path+"拆分物品：请求";
		public static const BAG_UI_CSortPackReq:String=path+"背包整理：请求";
		public static const BAG_UI_CSortDepotReq:String=path+"仓库整理：请求";
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