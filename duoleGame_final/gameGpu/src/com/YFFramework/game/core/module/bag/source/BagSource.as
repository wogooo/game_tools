package com.YFFramework.game.core.module.bag.source
{
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;

	/**
	 * @version 1.0.0
	 * creation time：2012-11-23 下午02:03:13
	 * 
	 */
	public class BagSource
	{
		//======================================================================
		//        const variable
		//======================================================================
		public static const BACKGROUND_WIDTH:int=387;
		public static const BACKGROUND_HEIGHT:int=520;
		
		public static const DEPOT_HEIGHT:int=350;
		
		public static const SCROLL_TARGET_WIDTH:int=306;
		public static const SCROLL_TARGET_HEIGHT:int=313;
		
		/** 背包开始格子编号，同服务端 */
		public static const BAG_OFFSET:int=101;
		/** 仓库开始格子编号，同服务端 */
		public static const STORE_OFFSET:int=301;
		
		/** 背包仓库总有格子数 */
		public static const TOTAL_GRIDS:int=140;
		
		/**初始开启的格子数 */		
		public static const PAGE_NUM:int=21;
		public static const ROW_GRIDS:int=7;
		
		public static const SORT:int=1;
		
		public static const SECOND_MENU_HEIGHT_SHORT:int=80;
		public static const SECOND_MENU_HEIGHT_LONG:int=98;
		
		public static const EXTEND_PACK_GRID_TXT:String=NoticeUtils.getStr(NoticeType.Notice_id_100025);
		public static const EXTEND_DEPOT_GRID_TXT:String=NoticeUtils.getStr(NoticeType.Notice_id_100026);
		
		public static const BACK_LIST:int=4;
		
		public static const TIP_MEND_SUCCESS:int=8;
		
		public static const MENU_USE:int=0;
		public static const MENU_SPILT:int=1;
		public static const MENU_SHOW:int=2;
		public static const MENU_ABANDON:int=3;
		/** 批量使用 */
		public static const MENU_USE_MORE:int=4;
		
		public static const TAB_ALL:int=1;
		public static const TAB_CONSUME:int=2;
		public static const TAB_EQUIPMENT:int=3;
		public static const TAB_MATERIAL:int=4;
		public static const TAB_MISSION:int=5;
		
		public static const ALTER_COMFIRM:int=1;
		public static const ALTER_CANCEL:int=2;
		
		public static const PAGE1:int=0;
		public static const PAGE2:int=1;
		public static const PAGE3:int=2;
		public static const PAGE4:int=3;
		
		public static var openStore:Boolean=false;
		
		public static var shopSell:Boolean=false;
		
		public static var popUp:Boolean=false;
		
		public static var shopMend:Boolean=false;
		
		/**********************商店相关**********************/
		
		public static var shopMode:int=0;
		
		public static const SHOP_NONE:int=0;
		public static const SHOP_BUY:int=1;
		public static const SHOP_SELL:int=2;
		public static const SHOP_FIX:int=3;
		
		/********************************************/
		/** 背包开格子道具静态id */
		public static const OPEN_BAG_GRID_PROPS:int=404290001;
		/** 仓库开格子道具静态id */
		public static const OPEN_STORE_GRID_PROPS:int=404300001;
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================

		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagSource()
		{
		}
		
		
		
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