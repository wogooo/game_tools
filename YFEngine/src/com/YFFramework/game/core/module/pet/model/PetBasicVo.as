package com.YFFramework.game.core.module.pet.model
{
	/**
	 * 缓存petProp表
	 * 2012-9-18 下午3:18:54
	 *@author yefeng
	 */
	public class PetBasicVo
	{
		/**宠物静态id 
		 */ 
		public var basicId:int;
		
		/**移动速度
		 */ 
		public var speed:int;
		/**宠物品质
		 */		
		public var quality:int;
		
		/**默认技能
		 */		
		public var defaultSkill:int;
		
		/** 资源id 
		 */		
		public var resId:int;
		/**名称
		 */		
		public var name:String;
		
		public function PetBasicVo()
		{
		}
	}
}