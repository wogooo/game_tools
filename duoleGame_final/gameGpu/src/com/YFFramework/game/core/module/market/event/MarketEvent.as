package com.YFFramework.game.core.module.market.event
{
	/**
	 * @version 1.0.0
	 * creation time：2013-5-27 下午3:42:53
	 * 
	 */
	
	
	public class MarketEvent
	{
		//======================================================================
		//       public property
		//======================================================================
		public var data:Object;
		
		//删除寄售、求购物品面板的物品
		public static const CLEAR_CONSIGNMENT_ITEM:String="clearItem";
		
		//删除求购面板的物品
		public static const CLEAR_PERCHASE_ITEM:String="clearPerchaseItem";
		
		/**此事件专用于从求购拖到筛选，用以清除求购面板 
		 */		
		public static const RESET_PURCHASE_PANEL:String='resetPurchasePanel';
		//移动到寄售物品面板
		public static const MOVE_TO_CONSIGN_ITEM:String="moveToConsignItem";
		
		//移动到求购面板
		public static const MOVE_TO_PURCHASE_ITEM:String='moveToPurchaseItem';
		
		/** 寄售面板任何寄售搜索都用这条，包括翻页什么的 
		 */		
		public static const CSearchSaleList:String='CSearchSaleList';
		
		/** 求购面板任何寄售搜索都用这条，包括翻页什么的 
		 */
		public static const CSearchWantList:String='CSearchWantList';
		
		/** 请求寄售
		 */		
		public static const CUpSale:String='CUpSale';
		/** 我的寄售记录 
		 */		
		public static const CMySaleList:String='CMySaleList';
		
		/**物品下架（我的寄售和我的求购都用这一条） 
		 */		
		public static const CDownSale:String='CDownSale';
		
		/** 请求我的求购列表
		 */		
		public static const CMyWantList:String='CMyWantList';
		
		/** 请求我的交易记录列表
		 */		
		public static const CMyDealList:String='CMyDealList';
		
		/** 取回物品请求 
		 */		
		public static const CGetBackItem:String='CGetBackItem';
		
		/**请求求购 
		 */		
		public static const CUpWant:String='CUpWant';
		
		/** 求购物品下架 
		 */		
		public static const CDownWant:String='CDownWant';
		
		/** 请求我的寄售列表数量
		 */		
		public static const CMySaleListNumber:String='CMySaleListNumber';
		
		/** 请求我的求购列表数量
		 */		
		public static const CMyWantListNumber:String='CMyWantListNumber';
		//======================================================================
		//       private property
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================

		
		//======================================================================
		//        public function
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