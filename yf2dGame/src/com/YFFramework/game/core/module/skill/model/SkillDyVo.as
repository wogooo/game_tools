package com.YFFramework.game.core.module.skill.model
{
	/** 技能动态vo 
	 * 2012-8-6 下午3:25:25
	 *@author yefeng
	 */
	public class SkillDyVo
	{
		/**技能id 
		 */		
		public var skillId:int;
		/**技能等级    获取 FightSkillBasicVo
		 */
		public var skillLevel:int;
		
		/**技能所在的格子位置   客户端 快捷键 上的位置   没有的话则为0 
		 */		
		public var grid:int;
		
		public function SkillDyVo()
		{
		}
	}
}