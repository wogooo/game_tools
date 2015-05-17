package com.YFFramework.game.core.global.model
{
	/** 缓存 Equip_Suit.json 数据   套装数据
	 */	
	public class EquipSuitBasicVo
	{
		/**自增id 
		 */
		public var id:int;
		
		/**套装id 
		 */		
		public var suit_id:int;
		
		/**  含有的个数  对应的描述
		 */		
		public var unit_num:int;

		public var app_attr_v2:int;
		public var app_attr_t2:int;
		public var suits_name:String;
		public var app_attr_v1:int;
		public var app_attr_t1:int;

		public function EquipSuitBasicVo()
		{
		}
		
		
		
	}
}