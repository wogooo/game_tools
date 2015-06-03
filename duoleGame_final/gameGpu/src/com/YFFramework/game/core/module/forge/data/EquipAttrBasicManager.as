package com.YFFramework.game.core.module.forge.data
{
	import com.YFFramework.game.core.global.util.TypeProps;
	
	import flash.utils.Dictionary;

	public class EquipAttrBasicManager
	{
		private static var _instance:EquipAttrBasicManager;
		private var _dict:Dictionary;
		public function EquipAttrBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():EquipAttrBasicManager
		{
			if(_instance==null)_instance=new EquipAttrBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var equip_AttrBasicVo:EquipAttrBasicVo;
			for (var id:String in jsonData)
			{
				equip_AttrBasicVo=new EquipAttrBasicVo();
				equip_AttrBasicVo.career=jsonData[id].career;
				equip_AttrBasicVo.physic_atk=jsonData[id].physic_atk;
				equip_AttrBasicVo.miss=jsonData[id].miss;
				equip_AttrBasicVo.mp=jsonData[id].mp;
				equip_AttrBasicVo.hp=jsonData[id].hp;
				equip_AttrBasicVo.tough=jsonData[id].tough;
				equip_AttrBasicVo.pstirke=jsonData[id].pstirke;
				equip_AttrBasicVo.mstirke=jsonData[id].mstirke;
				equip_AttrBasicVo.magic_defence=jsonData[id].magic_defence;
				equip_AttrBasicVo.physic_defence=jsonData[id].physic_defence;
				equip_AttrBasicVo.cirt=jsonData[id].cirt;
				equip_AttrBasicVo.hit=jsonData[id].hit;
				equip_AttrBasicVo.magic_atk=jsonData[id].magic_atk;
				_dict[equip_AttrBasicVo.career]=equip_AttrBasicVo;
			}
		}
		public function getEquip_AttrBasicVo(career:int):EquipAttrBasicVo
		{
			return _dict[career];
		}
		
		/** 装备洗练取得公式里的某个参数b
		 * @param attrType
		 */		
		public function getRatioForEquipSophi(attrType:int):Number
		{
			var vo:EquipAttrBasicVo=_dict[6];
			var ratio:Number;
			if(attrType == TypeProps.EA_HEALTH_LIMIT)
				ratio = vo.hp;
			else if(attrType == TypeProps.EA_MANA_LIMIT)
				ratio = vo.mp;
			else if(attrType == TypeProps.EA_PHYSIC_ATK)
				ratio = vo.physic_atk;
			else if(attrType == TypeProps.EA_PHYSIC_DEFENSE)
				ratio = vo.physic_defence;
			else if(attrType == TypeProps.EA_MAGIC_ATK)
				ratio = vo.magic_atk;
			else if(attrType == TypeProps.EA_MAGIC_DEFENSE)
				ratio = vo.magic_defence;
			else if(attrType == TypeProps.EA_CRITRATE)
				ratio = vo.cirt;
			else if(attrType == TypeProps.EA_MISSRATE)
				ratio = vo.miss;
			else if(attrType == TypeProps.EA_HITRATE)
				ratio = vo.hit;
			else if(attrType == TypeProps.EA_TOUGHRATE)
				ratio = vo.hit;
			else if(attrType == TypeProps.EA_PSTRIKE)
				ratio = vo.pstirke;
			else
				ratio = vo.mstirke;
			return ratio;
		}
	}
}