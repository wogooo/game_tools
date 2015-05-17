package com.YFFramework.game.core.global.model
{
	/**装备动态 vo 
	 * @author yefeng
	 *2012-7-28下午10:38:30
	 */
	public class EquipDyVo extends GoodsDyVo
	{
		/**
		 * 道具唯一id 
		 * 动态 id
		 */		
		public var equip_id:int;
		
		/**
		 * 道具模板id 
		 */		
		public var template_id:int;
		/**
		 * 绑定性 
		 */		
		public var binding_attr:int;
		
		/**
		 * 当前耐久度 
		 */		
		public var cur_durability:int;
		
		/**
		 * 强化等级 
		 */			
		public var enhance_level:int;
		
		/**
		 * 镶嵌宝石1 
		 */
		public var gem_1_id:int;
		
		/**
		 * 镶嵌宝石2
		 */
		public var gem_2_id:int;
		
		/**
		 * 镶嵌宝石3
		 */
		public var gem_3_id:int;
		
		/**
		 * 镶嵌宝石4
		 */
		public var gem_4_id:int;
		
		/**
		 * 镶嵌宝石5 
		 */
		public var gem_5_id:int;
		
		/**
		 * 镶嵌宝石6 
		 */
		public var gem_6_id:int;
		
		/**
		 * 镶嵌宝石7 
		 */
		public var gem_7_id:int;
		
		/**
		 * 镶嵌宝石8
		 */
		public var gem_8_id:int;
		
		public var obtain_time:int;
		
		public function EquipDyVo()
		{
			super();
		}
	}
}