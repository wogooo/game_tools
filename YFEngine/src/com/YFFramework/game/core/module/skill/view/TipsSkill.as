package com.YFFramework.game.core.module.skill.view
{
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;

	/**技能 tips 
	 * @author yefeng
	 *2012-11-7下午10:22:08
	 */
	public class TipsSkill
	{
		public function TipsSkill()
		{
		}
		/**
		 * 
		 */		
		public function initSKillId(skillDyVo:SkillDyVo):void
		{
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId);
			
			
		}
		
		
	}
}