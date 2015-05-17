package com.YFFramework.game.core.global.model
{

	/**  缓存技能 表 skill.json  -->找到 fightSkill.json表 --->找到特效表 FightEffect.json表
	 *  SkillBasicVo-->FightSkillBasicVo--->FightEffectBasicVo
	 * 技能vo   skillBasicVo
	 *  2012-7-4
	 *	@author yefeng
	 */
	public class SkillBasicVo 
	{
		
		/**技能 id
		 */ 
		public var skillId:int;
		
		/**战斗id 数组
		 *  内部保存的是技能不同等级下的战斗效果   
		 */ 
		public var fightSkillArr:Array;
		
		/** 该技能的描述
		 */		
		public var tips:String;
		/** 技能名称
		 */		
		public var skillName:String;
		/**该技能图标
		 */		
		public var iconId:int;
		public function SkillBasicVo()
		{
		}
		/** level是从 1 开始
		 * @param level   获取该技能不同等级的战斗id 
		 * 
		 */		
		public function getFightSkillId(level:int):int
		{
			return fightSkillArr[level-1];
		}
	}
}