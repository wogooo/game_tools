package com.YFFramework.game.core.module.pet.model
{
	import com.YFFramework.game.core.global.manager.ConfigDataManager;

	/***
	 *宠物相关的常量配置(ConfigData表里配置的)
	 *@author ludingchang 时间：2014-1-6 上午10:14:09
	 */
	public class PetConfig
	{
		public function PetConfig()
		{
		}
		/**宠物默认技能ID*/
		public static var pet_default_skill:int;
		/**宠物继承花费（游戏币）*/
		public static var pet_inherit_cost:int;
		/**宠物洗练花费（游戏币）*/
		public static var pet_sophi_cost:int;
		/**扩展宠物技能栏花费(魔钻）*/
		public static var pet_skill_slot_cost:int;
	}
}