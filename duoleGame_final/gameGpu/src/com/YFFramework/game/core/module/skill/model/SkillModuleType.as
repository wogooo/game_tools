package com.YFFramework.game.core.module.skill.model
{
	/**技能模块类型
	 * @author yefeng
	 * 2013 2013-7-24 下午12:00:51 
	 */
	public class SkillModuleType
	{
		/**消耗生命
		 */		
		public static const  Consume_HP:int=1;
		
		/**消耗魔法
		 */		
		public static const  Consume_MP:int=2;

		/**消耗生命百分比
		 */		
		public static const  Consume_HPPercent:int=3;

		/**消耗魔法百分比
		 */		
		public static const  Consume_MPPercent:int=4;
		
		//快捷键类型
		/**  没有类型
		 */		
		public static const QuickType_BT_NONE:int=0;
		/**技能类型
		 */		
		public static const QuickType_BT_SKILL:int=1;
		/** 道具类型    也就是 血瓶  或者蓝瓶
		 */		
		public static const QuickType_BT_ITEM:int=2;

		public function SkillModuleType()
		{
		}
	}
}