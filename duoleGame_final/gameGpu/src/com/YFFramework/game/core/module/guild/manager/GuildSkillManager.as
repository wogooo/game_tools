package com.YFFramework.game.core.module.guild.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	
	import flash.utils.Dictionary;

	/***
	 *公会技能管理类
	 *@author ludingchang 时间：2013-11-4 下午6:00:44
	 */
	public class GuildSkillManager
	{
		private static var _inst:GuildSkillManager;
		public static function get Instence():GuildSkillManager
		{
			return _inst||=new GuildSkillManager;
		}
		public function GuildSkillManager()
		{
		}
		/**公会技能树*/
		private var _guildSkills:Array;
		private var _is_init:Boolean=false;
		public function init():void
		{
			if(_is_init)
				return;
			var skills:Array=SkillBasicManager.Instance.getSkillByBigCategory(TypeSkill.BigCategory_union);
			_guildSkills=new Array;
			var i:int,len:int=skills.length;
			for(i=0;i<len;i++)
			{
				var map:HashMap=skills[i];
				_guildSkills[(map.get(1) as SkillBasicVo).list_pos]=map;
			}
			_is_init=true;
		}
		/**
		 *取技能VO 
		 * @param pos：位置，公会技能UI上的位置
		 * @param level：技能等级
		 * @return 技能VO
		 * 
		 */		
		public function getSkill(pos:int,level:int):SkillBasicVo
		{
			return (_guildSkills[pos] as HashMap).get(level);
		}
		/**
		 *技能的最大等级 
		 * @param pos：技能位置
		 * @return 
		 * 
		 */		
		public function maxSkillLevel(pos:int):int
		{
			return (_guildSkills[pos] as HashMap).size();
		}
		/**
		 *  根据ID取已经学习过的技能，如果没有学过就返回null 
		 * @param skill_id 技能ID
		 * @return 
		 * 
		 */		
		public function getLearnedSkill(skill_id:int):SkillBasicVo
		{
			var sk:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skill_id);
			if(sk)
			{
				var skill:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(sk.skillId,sk.skillLevel);
				return skill;
			}
			return null;
		}
		/**当前选中的技能*/
		public var selectedSkill:int=1;
	}
}