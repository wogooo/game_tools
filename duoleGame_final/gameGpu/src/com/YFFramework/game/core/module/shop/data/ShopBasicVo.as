package com.YFFramework.game.core.module.shop.data
{
	public class ShopBasicVo
	{
		/**商店的唯一标示，一个shop_id,会有很多的key_id 
		 */		
		public var shop_id:int;
		/**物品在商店中的位置 
		 */		
		public var pos:int;
		/**物品类别，道具还是装备 
		 */		
		public var item_type:int;
		/**物品静态id 
		 */		
		public var item_id:int;
		/** 绑定类型
		 */		
		public var binding_type:int;
		/**货币类型 
		 */		
		public var money_type:int;
		/**物品单价 
		 */		
		public var price:int;
		/**物品原价 
		 */		
		public var org_price:int;
		/**限售类型 
		 */		
		public var sale_limit:int;
		/**排序id 
		 */		
		public var key_id:int;
		/** 起始值必须为1 
		 */		
		public var tab_id:int;
		/**tab标签 
		 */
		public var tab_label:String;

		public function ShopBasicVo()
		{
		}
	}
}