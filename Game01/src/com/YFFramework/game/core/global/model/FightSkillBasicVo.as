package com.YFFramework.game.core.global.model
{
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	
	import flash.utils.getTimer;

	/**fightSkill 表的数据结构
	 * 战斗技能
	 * 2012-9-4 上午9:54:12
	 *@author yefeng
	 */
	public class FightSkillBasicVo
	{
		/** 技能战斗id 
		 */
		public var fightSkillId:int;
		
		/**战斗特效id 来自于FightEffect表  用来获取FightEffectBasicVo 
		 */ 
		public var fightEffectId:int;
		/** cd 的时间
		 */		
		public var CDTime:Number;
		
		/**技能攻击类型   是单一攻击 还是群攻   类型 是 TypeSkill的静态量 Atk_
		 */ 
		public var atkType:int;
		
		/**技能可以攻击的范围
		 */ 
		public var range:int;
		
		/**技能的移动速度
		 */ 
		public var speed:int;
		
		/**效果 类型 该技能是拉取技能还是 推离 还是没有效果     值为 TypeSkill Effect_Pull   Effect_push   Effect_None
		 */ 
		public var effectType:int; 
		
		/** 拉取或者推开时推和拉的距离
		 */		
		public var effectLen:int;
		
		/**上一次播放技能的时间
		 */		
		private var _preFireTime:Number;
		
		
		public function FightSkillBasicVo()
		{
			_preFireTime=0;
		}

		/** 是否能进行该特效的播放
		 */		
		public function canfire():Boolean
		{
			if(getTimer()-_preFireTime>=CDTime) 
			{
				_preFireTime=getTimer();
				return true;
			}
			return false;
		}
		
	}
}