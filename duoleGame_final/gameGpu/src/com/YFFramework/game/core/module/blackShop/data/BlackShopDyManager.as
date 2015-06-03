package com.YFFramework.game.core.module.blackShop.data
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.msg.black_shop.BlackShopItemInfo;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-9-25 上午11:39:38
	 */
	public class BlackShopDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		public static const NEED_DIAMOND:int=5;
		public static const MAX:int=9;
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:BlackShopDyManager;
		
		private var _itemsInfo:Vector.<BlackShopDyVo>;
		private var _refresh:int;
		private var _canRefresh:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BlackShopDyManager()
		{
			var info:BlackShopDyVo;
			_itemsInfo=new Vector.<BlackShopDyVo>();
			
			for(var i:int=0;i<MAX;i++)
			{
				info=new BlackShopDyVo();
				_itemsInfo.push(info);
			}
			
			canRefresh=2;
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function updateItemsInfo(info:Array):void
		{
			for(var i:int=0;i<MAX;i++)
			{
				_itemsInfo[i].buy_info=1-BlackShopItemInfo(info[i]).buyInfo;
				_itemsInfo[i].props_id=BlackShopItemInfo(info[i]).tmpId;
			}
		}
		
		public function updateOneInfo(index:int):void
		{
			_itemsInfo[index].buy_info=0;
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================	
		public static function get instance():BlackShopDyManager
		{
			if(_instance == null) _instance=new BlackShopDyManager();
			return _instance;
		}

		/** 
		 * 这里仅统计免费刷新次数
		 */		
		public function set refresh(value:int):void
		{
			_refresh = value;
		}
		
		public function get refresh():int
		{
			return _refresh;
		}
		
		public function set canRefresh(value:int):void
		{
			_canRefresh = value;
		}
		
		public function get canRefresh():int
		{
			return _canRefresh;
		}

		public function get itemsInfo():Vector.<BlackShopDyVo>
		{
			return _itemsInfo;
		}
		


	}
} 