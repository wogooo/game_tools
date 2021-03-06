package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	
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
				skillBasicVo.skill_bigCategory=jsonData[id].skill_bigCategory;
				skillBasicVo.range_param=jsonData[id].range_param;
				skillBasicVo.buff_hitrate=jsonData[id].buff_hitrate;
				skillBasicVo.effect_id=jsonData[id].effect_id;
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
				skillBasicVo.fix_damage=jsonData[id].fix_damage;
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
				skillBasicVo.extra_effect=jsonData[id].extra_effect;
				skillBasicVo.fix_damage_type=jsonData[id].fix_damage_type;
				skillBasicVo.character_level=jsonData[id].character_level;
				skillBasicVo.extra_hitrate=jsonData[id].extra_hitrate;
				skillBasicVo.affect_group=jsonData[id].affect_group;
				skillBasicVo.extra_value1=jsonData[id].extra_value1;
				skillBasicVo.consume_value=jsonData[id].consume_value;
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
		}
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
		
	}
}