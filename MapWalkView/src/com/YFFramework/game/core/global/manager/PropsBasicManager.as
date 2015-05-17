package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	
	import flash.utils.Dictionary;

	public class PropsBasicManager
	{
		private static var _instance:PropsBasicManager;
		private var _dict:Dictionary;
		public function PropsBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():PropsBasicManager
		{
			if(_instance==null)_instance=new PropsBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var propsBasicVo:PropsBasicVo;
			for (var id:String in jsonData)
			{
				propsBasicVo=new PropsBasicVo();
				propsBasicVo.effect_desc=jsonData[id].effect_desc;
				propsBasicVo.describe=jsonData[id].describe;
				propsBasicVo.skill_level=jsonData[id].skill_level;
				propsBasicVo.cd_type=jsonData[id].cd_type;
				propsBasicVo.composite_id=jsonData[id].composite_id;
				propsBasicVo.icon_id=jsonData[id].icon_id;
				propsBasicVo.dialog_id=jsonData[id].dialog_id;
				propsBasicVo.use_effect=jsonData[id].use_effect;
				propsBasicVo.pet_id=jsonData[id].pet_id;
				propsBasicVo.deadline=jsonData[id].deadline;
				propsBasicVo.attr_value=jsonData[id].attr_value;
				propsBasicVo.type=jsonData[id].type;
				propsBasicVo.use_skill_id=jsonData[id].use_skill_id;
				propsBasicVo.name=jsonData[id].name;
				propsBasicVo.use_desc=jsonData[id].use_desc;
				propsBasicVo.quality=jsonData[id].quality;
				propsBasicVo.binding_type=jsonData[id].binding_type;
				propsBasicVo.remain_time=jsonData[id].remain_time;
				propsBasicVo.use_condition=jsonData[id].use_condition;
				propsBasicVo.level=jsonData[id].level;
				propsBasicVo.skill_id=jsonData[id].skill_id;
				propsBasicVo.cd_time=jsonData[id].cd_time;
				propsBasicVo.attr_type=jsonData[id].attr_type;
				propsBasicVo.template_id=jsonData[id].template_id;
				propsBasicVo.sell_price=jsonData[id].sell_price;
				propsBasicVo.show_type=jsonData[id].show_type;
				propsBasicVo.ass_id=jsonData[id].ass_id;
				propsBasicVo.stack_limit=jsonData[id].stack_limit;
				_dict[propsBasicVo.template_id]=propsBasicVo;
			}
		}
		
		public function getPropsBasicVo(template_id:int):PropsBasicVo
		{
			return _dict[template_id];
		}
		
		public function getURL(template_id:int):String
		{
			var propsBasicVo:PropsBasicVo=_dict[template_id];
			return URLTool.getGoodsIcon(propsBasicVo.icon_id);
		}
		
		/**
		 * 取得本地所有道具静态数据 
		 * @return 
		 * 
		 */		
		public function getAllPropsBasicVo():Array
		{
			var all:Array=[];
			for each(var obj:Object in _dict)
			{
				all.push(obj);
			}
			return all;
		}
		
		/**获得某一类型的物品的全部非绑定templateId 
		 * @param type	物品类型
		 * @return Array of templateId
		 */		
		public function getAllBasicVoByType(type:int):Array{
			var all:Array= new Array();
			for each(var obj:Object in _dict){
				if(obj.type==type && obj.binding_type==TypeProps.BIND_TYPE_NO)	all.push(obj);
			}
			return all;
		}
		
		public static function getAttrName(attr:int):String
		{
			switch(attr)
			{
				case TypeProps.BA_STRENGTH:
					return "力量";
				case TypeProps.BA_AGILE:
					return "敏捷";
				case TypeProps.BA_INTELLIGENCE:
					return "智力";
				case TypeProps.BA_PHYSIQUE:
					return "体质";
				case TypeProps.BA_SPIRIT:
					return "精神";
				case TypeProps.BA_STRENGTH_APT:
					return "力量资质";
				case TypeProps.BA_AGILE_APT:
					return "敏捷资质";
				case TypeProps.BA_INTELLIGENCE_APT:
					return "智力资质";
				case TypeProps.BA_PHYSIQUE_APT:
					return "体质资质";
				case TypeProps.BA_SPIRIT_APT:
					return "精神资质";
				case TypeProps.BA_GROW:
					return "成长值";
				case TypeProps.EA_HEALTH:
					return "生命";
				case TypeProps.EA_MANA:
					return "魔法";
				case TypeProps.EA_HEALTH_LIMIT:
					return "生命上限";
				case TypeProps.EA_MANA_LIMIT:
					return "魔法上限";
				case TypeProps.EA_PHYSIC_ATK:
					return "物理攻击";
				case TypeProps.EA_MAGIC_ATK:
					return "魔法攻击";
				case TypeProps.EA_PHYSIC_DEFENSE:
					return "物理防御";
				case TypeProps.EA_MAGIC_DEFENSE:
					return "魔法防御";					
				case TypeProps.EA_HITRATE:
					return "命中率";
				case TypeProps.EA_MISSRATE:
					return "闪避";
				case TypeProps.EA_CRITRATE:
					return "暴击";
				case TypeProps.EA_TOUGHRATE:
					return "坚韧";					
				case TypeProps.EA_PREDUCE:
					return "物理减伤";
				case TypeProps.EA_MREDUCE:
					return "魔法减伤";
				case TypeProps.EA_BLOODRESIST:
					return "流血抗性";
				case TypeProps.EA_TOUGHRATE:
					return "中毒抗性";					
				case TypeProps.EA_SWIMRESIST:
					return "晕眩抗性";
				case TypeProps.EA_FROZENRESIST:
					return "冰冻抗性";
				case TypeProps.EA_MOVESPEED:
					return "移动速度";
				default:
					return "";
			}
		}
		
		
	}
}