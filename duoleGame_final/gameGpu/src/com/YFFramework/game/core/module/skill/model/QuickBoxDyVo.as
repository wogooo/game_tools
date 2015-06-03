package com.YFFramework.game.core.module.skill.model
{
	/**快捷栏动态数据 vo 
	 * @author yefeng
	 * 2013 2013-7-25 上午10:48:30 
	 */
	public class QuickBoxDyVo
	{
		/**类型 是道具还是  技能  值在 SkillModuleType_
		 */		
		public var type:int;
		
		/** 技能 id 或者道具静态id 
		 */		
		public var id:int;
		
		/**格子的位置    格子位置 起始索引为 1 
		 */		
		public var key_id:int;
		public function QuickBoxDyVo()
		{
		}
	}
}