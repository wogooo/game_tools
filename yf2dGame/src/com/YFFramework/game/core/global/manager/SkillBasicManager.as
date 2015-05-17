package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	
	import flash.utils.Dictionary;

	/** 缓存 skill.json表
	 * SkillBasicVo-->FightSkillBasicVo--->FightEffectBasicVo
	 * 
	 *   2012-7-4
	 *	@author yefeng
	 */
	public class SkillBasicManager
	{
		
		private static var _instance:SkillBasicManager;
		private var _dict:Dictionary;
		public function SkillBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():SkillBasicManager
		{
			if(_instance==null) _instance=new SkillBasicManager();
			return _instance;
		}
		
		/**缓存数据
		 */
		public function cacheData(jsonData:Object):void
		{
			var skillBasicVo:SkillBasicVo;
			for (var skillId:String in jsonData)
			{
				skillBasicVo=new SkillBasicVo();
				skillBasicVo.skillId=int(skillId);
				skillBasicVo.fightSkillArr=jsonData[skillId].fightSkillArr;
				skillBasicVo.iconId=jsonData[skillId].iconId;
				skillBasicVo.tips=jsonData[skillId].tips;
				skillBasicVo.skillName=jsonData[skillId].skillName;
				_dict[skillBasicVo.skillId]=skillBasicVo;
			}
		}
		
		/** 获取
		 */
		public function getSkillBasicVo(skillId:int):SkillBasicVo
		{
			return _dict[skillId];
		}
		
	}
}