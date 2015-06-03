package com.YFFramework.game.core.module.forge.data
{
	public class EquipLevelupBasicVo
	{

		/** 之前等级（如10，就是10-19级）
		 */		
		public var before_level:int;
		/** 道具静态id
		 */		
		public var props_id:int;
		/** 道具数量
		 */		
		public var props_num:int;
		/** 下一等级（如20，就是20-29级）
		 */		
		public var after_level:int;
		/** 下一品质
		 */		
		public var after_quality:int;
		/** 消耗金钱（银锭）
		 */		
		public var money:int;

		public function EquipLevelupBasicVo()
		{
		}
	}
}