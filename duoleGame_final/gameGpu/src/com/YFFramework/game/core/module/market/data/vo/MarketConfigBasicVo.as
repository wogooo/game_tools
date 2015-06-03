package com.YFFramework.game.core.module.market.data.vo
{
	public class MarketConfigBasicVo
	{

		/** 索引id，唯一id(除了排序无实际意义) */		
		public var id:int;
		/** 子类型  */		
		public var sub_classic_type:int;
		/**物品类型：装备、道具、金钱  */		
		public var item_type:int;
		/** 物品模板id */
		public var item_id:int;

		public function MarketConfigBasicVo()
		{
		}
	}
}