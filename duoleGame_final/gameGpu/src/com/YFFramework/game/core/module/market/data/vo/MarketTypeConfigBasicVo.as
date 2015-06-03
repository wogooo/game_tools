package com.YFFramework.game.core.module.market.data.vo
{
	public class MarketTypeConfigBasicVo
	{
		/**子类 (唯一索引) */		
		public var sub_classic_type:int;
		/**子类名称  */		
		public var subClass_name:String;	
		/**大类  */		
		public var classic_type:int;
		/**大类名称  */		
		public var classic_name:String;
		
		/**热销排序号  */
		public var hot_sale_order:int;
		
		public function MarketTypeConfigBasicVo()
		{
		}
	}
}