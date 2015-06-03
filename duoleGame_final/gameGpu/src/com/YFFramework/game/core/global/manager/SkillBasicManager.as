package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.guild.manager.GuildSkillManager;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.utils.Dictionary;

	public class SkillBasicManager
	{
		private static var _instance:SkillBasicManager;
		private var _dict:Dictionary;
		
		private var _careerDict:Dictionary;
		
		public function SkillBasicManager()
		{
			_dict=new Dictionary();
			_careerDict=new Dictionary();
		}
		public static function get Instance():SkillBasicManager
		{
			if(_instance==null)_instance=new SkillBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var skillBasicVo:SkillBasicVo;
			var childDict:HashMap;
			
			var career:int;
			var careerChildDict:HashMap;
			for (var id:String in jsonData)
			{
				skillBasicVo=new SkillBasicVo();
				skillBasicVo.trap_id=jsonData[id].trap_id;
				skillBasicVo.icon_id=jsonData[id].icon_id;
				skillBasicVo.skill_big_category=jsonData[id].skill_big_category;
				skillBasicVo.range_param=jsonData[id].range_param;
				skillBasicVo.buff_hitrate=jsonData[id].buff_hitrate;
				skillBasicVo.man_effect_id=jsonData[id].man_effect_id;  //男性普攻特效
				skillBasicVo.man_effect_atk1_id=jsonData[id].man_effect_atk1_id;  //男性特殊攻击1 
				skillBasicVo.woman_effect_id=jsonData[id].woman_effect_id;  //女性普攻特效
				skillBasicVo.woman_effect_atk1_id=jsonData[id].woman_effect_atk1_id;  //女性特殊攻击1 
				skillBasicVo.effect_type=jsonData[id].effect_type;
				skillBasicVo.use_type=jsonData[id].use_type;
				skillBasicVo.consume_type=jsonData[id].consume_type;
				skillBasicVo.exclude_skill=jsonData[id].exclude_skill;
				skillBasicVo.extra_damage=jsonData[id].extra_damage;
				skillBasicVo.description=jsonData[id].description;
				skillBasicVo.name=jsonData[id].name;
				skillBasicVo.range_shape=jsonData[id].range_shape;
				skillBasicVo.buff_time=jsonData[id].buff_time;
				skillBasicVo.list_pos=jsonData[id].list_pos;
				skillBasicVo.buff_id=jsonData[id].buff_id;
				skillBasicVo.before_skill=jsonData[id].before_skill;
//				skillBasicVo.fix_damage=jsonData[id].fix_damage;
				skillBasicVo.affect_number=jsonData[id].affect_number;
				skillBasicVo.profession=jsonData[id].profession;
				skillBasicVo.effect_range=jsonData[id].effect_range;
				skillBasicVo.use_distance=jsonData[id].use_distance;
				skillBasicVo.trap_time=jsonData[id].trap_time;
				skillBasicVo.damage_factor=jsonData[id].damage_factor; 
				skillBasicVo.id=jsonData[id].id;
				skillBasicVo.extra_type2=jsonData[id].extra_type2;
				skillBasicVo.effect_desc=jsonData[id].effect_desc;
				skillBasicVo.trap_type=jsonData[id].trap_type;
				skillBasicVo.note_consume=jsonData[id].note_consume;
				skillBasicVo.see_consume=jsonData[id].see_consume;
				skillBasicVo.extra_type1=jsonData[id].extra_type1;
				skillBasicVo.other_consume=jsonData[id].other_consume;
				skillBasicVo.skill_level=jsonData[id].skill_level;
				skillBasicVo.extra_value2=jsonData[id].extra_value2;
				skillBasicVo.skill_id=jsonData[id].skill_id;
				skillBasicVo.cooldown_time=jsonData[id].cooldown_time;
				skillBasicVo.special_effect=jsonData[id].special_effect;
				skillBasicVo.special_param=jsonData[id].special_param;
//				initSpecial_effect(skillBasicVo,jsonData[id].special_effect);
//				skillBasicVo.fix_damage_type=jsonData[id].fix_damage_type;
				skillBasicVo.character_level=jsonData[id].character_level;
				skillBasicVo.extra_hitrate=jsonData[id].extra_hitrate;
				skillBasicVo.affect_group=jsonData[id].affect_group;
				skillBasicVo.extra_value1=jsonData[id].extra_value1;
				skillBasicVo.consume_value=jsonData[id].consume_value;
				skillBasicVo.use_limit=jsonData[id].use_limit;
				skillBasicVo.quality = jsonData[id].quality;
				if(_dict[skillBasicVo.skill_id]==null)
				{
					childDict=new HashMap();
					_dict[skillBasicVo.skill_id]=childDict;
				}
				
				childDict=_dict[skillBasicVo.skill_id];
				childDict.put(skillBasicVo.skill_level,skillBasicVo);
				
				if(_careerDict[skillBasicVo.profession]==null)
				{
					careerChildDict=new HashMap();
					_careerDict[skillBasicVo.profession]=careerChildDict;
				}
				careerChildDict=_careerDict[skillBasicVo.profession];
				careerChildDict.put(skillBasicVo.id,skillBasicVo);
			}
			GuildSkillManager.Instence.init();
		}
		
		/**解析 special_effect字段
		 */		
//		private function initSpecial_effect(skillBasicVo:SkillBasicVo,special_effect:String):void
//		{
//			var arr:Array=special_effect.split("_");
//			skillBasicVo.special_effectType=arr[0];
//			skillBasicVo.special_effectValue1=arr[0];
//			skillBasicVo.special_effectValue2=arr[0];
//		}
		/**获取技能id
		 * @param skill_id
		 * @param level
		 * @return 
		 * 
		 */		
		public function getSkillBasicVo(skill_id:int,level:int):SkillBasicVo
		{
			var map:HashMap=_dict[skill_id];
			return map.get(level);
		}
		/**获取技能的最大等级
		 */		
//		public function getMaxLevel(skill_id:int):int
//		{
//			var map:HashMap=_dict[skill_id];
//			var arr:Array=map.values();
//			arr.sortOn("skill_level",Array.NUMERIC|Array.DESCENDING); //从大到小
//			var skillBasicVo:SkillBasicVo=arr[0];
//			return skillBasicVo.skill_level;
//		}
		
		/**技能等级数量*/
		public function getSkillLen(skill_id:int):int
		{
			var map:HashMap=_dict[skill_id];
			return map.size();
		}
		
		public function getURL(skill_id:int,level:int):String
		{
			var skillBasicVo:SkillBasicVo=getSkillBasicVo(skill_id,level);
			var url:String=URLTool.getSkillIcon(skillBasicVo.icon_id);
			return url;
		}
		/**  某个职业的技能列表
		 * @param career
		 * @return 
		 */		
		public function getSkillList(career:int):HashMap
		{
			return _careerDict[career];
		}
		
		/**
		 *取某个职业的指定技能 
		 * @param career 职业
		 * @param skillIndex 技能位置
		 * @param skillLevel 技能等级
		 * @return 
		 */		
		public function getSkill(career:int,skillIndex:int,skillLevel:int=1):SkillBasicVo
		{
			var map:HashMap=_careerDict[career];
			var dic:Dictionary=map.getDict();
			for each(var vo:SkillBasicVo in dic)
			{
				if(vo.list_pos==skillIndex&&vo.skill_level==skillLevel&&vo.skill_big_category==TypeSkill.BigCategory_Career)
					return vo;
			}
			return null;//找不到数据
		}
		
		
		/**获取普通的战斗特效数据
		 */		
		public function getNormalFightEffectBasicVo(sex:int,skillId:int,skillLevel:int):FightEffectBasicVo
		{
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillLevel);
			var fightEffectBasicVo:FightEffectBasicVo;
			switch(sex)
			{
				case TypeRole.Sex_Man:
					fightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(skillBasicVo.man_effect_id);
					break;
				case TypeRole.Sex_Woman:
					fightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(skillBasicVo.woman_effect_id);
					break;
			}
			return fightEffectBasicVo;
		}
		/**获取特殊的战斗特效数据
		 */	
		public function getAtk_1FightEffectBasicVo(sex:int,skillId:int,skillLevel:int):FightEffectBasicVo
		{
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillLevel);
			var fightEffectBasicVo:FightEffectBasicVo;
			switch(sex)
			{
				case TypeRole.Sex_Man:
					fightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(skillBasicVo.man_effect_id);
					break;
				case TypeRole.Sex_Woman:
					fightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(skillBasicVo.woman_effect_id);
					break;
			}
			return fightEffectBasicVo;
		}
		
		/**
		 *更具技能大类取得对应的技能 
		 * @param skillBigCategory：技能大类
		 * @return 技能数组(数组存的是HashMap,HashMap里存的是同一技能id不同技能等级的所有技能)
		 * 
		 */		
		public function getSkillByBigCategory(skillBigCategory:int):Array
		{
			var result:Array=new Array;
			for each(var map:HashMap in _dict)
			{
				var skill:SkillBasicVo=map.get(1);
				if(skill.skill_big_category==skillBigCategory)
					result.push(map);
			}
			return result;
		}
		
		
		
	}
}