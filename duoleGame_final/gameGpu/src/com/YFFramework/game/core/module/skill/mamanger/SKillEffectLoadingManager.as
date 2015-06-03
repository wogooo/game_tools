package com.YFFramework.game.core.module.skill.mamanger
{
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.FightEffectBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.gameConfig.URLTool;

	/**预加载 技能特效
	 * @author yefeng
	 * 2013 2013-9-5 上午10:53:57 
	 */
	public class SKillEffectLoadingManager
	{
		public function SKillEffectLoadingManager()
		{
		}
		
		
		public static function loadSkill(skillDyVo:SkillDyVo):void
		{
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
			loadAllEffect(skillBasicVo.man_effect_id);
			loadAllEffect(skillBasicVo.woman_effect_id);
//			loadAllEffect(skillBasicVo.man_effect_atk1_id);
//			loadAllEffect(skillBasicVo.woman_effect_atk1_id);
		}
		
		/**加载所有的特效资源
		 */
		private static function loadAllEffect(effectId:int):void
		{
			var fightEffectBasicVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(effectId);
			var url:String;
			/// 攻击者 
			// 攻击者上层
			if(fightEffectBasicVo.atkFrontId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.atkFrontId);
				SourceCache.Instance.loadRes(url);
			}
			//攻击者下层
			if(fightEffectBasicVo.atkBackId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.atkBackId);
				SourceCache.Instance.loadRes(url);
			}
			//攻击者天空层
			if(fightEffectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.atkSkyId);
				SourceCache.Instance.loadRes(url);
			}
			//攻击者地面层
			if(fightEffectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.atkFloorId);
				SourceCache.Instance.loadRes(url);
			}
			///受击者上层
			if(fightEffectBasicVo.uAtkFrontId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.uAtkFrontId);
				SourceCache.Instance.loadRes(url);
			}
			// 受击者下层
			if(fightEffectBasicVo.uAtkBackId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.uAtkBackId);
				SourceCache.Instance.loadRes(url);
			}
			//受击者天空层
			if(fightEffectBasicVo.uAtkSkyId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.uAtkSkyId);
				SourceCache.Instance.loadRes(url);
			}
			//受击者下层
			if(fightEffectBasicVo.uAtkFloorId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.uAtkFloorId);
				SourceCache.Instance.loadRes(url);
			}
			if(fightEffectBasicVo.bgFloorId>0)
			{
				url=URLTool.getSkill(fightEffectBasicVo.bgFloorId);
				SourceCache.Instance.loadRes(url);
			}
			
		}
		
	}
}