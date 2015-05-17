package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	
	import flash.utils.Dictionary;

	public class FightEffectBasicManager
	{
		private static var _instance:FightEffectBasicManager;
		private var _dict:Dictionary;
		public function FightEffectBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():FightEffectBasicManager
		{
			if(_instance==null)_instance=new FightEffectBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var fightEffectBasicVo:FightEffectBasicVo;
			for (var id:String in jsonData)
			{
				fightEffectBasicVo=new FightEffectBasicVo();
				fightEffectBasicVo.atkFrontDirection=jsonData[id].atkFrontDirection;
				fightEffectBasicVo.uAtkBackTimeArr=jsonData[id].uAtkBackTimeArr;         
				fightEffectBasicVo.uAtkSkyId=jsonData[id].uAtkSkyId;
				fightEffectBasicVo.uAtkFloorId=jsonData[id].uAtkFloorId;
				fightEffectBasicVo.uAtkTimeArr=jsonData[id].uAtkTimeArr;
				fightEffectBasicVo.uAtkFrontTimeArr=jsonData[id].uAtkFrontTimeArr;
				fightEffectBasicVo.atkFloorId=jsonData[id].atkFloorId;
				fightEffectBasicVo.speed=jsonData[id].speed;
				fightEffectBasicVo.uAtkFrontId=jsonData[id].uAtkFrontId;
				fightEffectBasicVo.atkTimeArr=jsonData[id].atkTimeArr;
				fightEffectBasicVo.atkFrontTimeArr=jsonData[id].atkFrontTimeArr;
				fightEffectBasicVo.uAtkFloorTimeArr=jsonData[id].uAtkFloorTimeArr;
				fightEffectBasicVo.uAtkSkyTimeArr=jsonData[id].uAtkSkyTimeArr;
				fightEffectBasicVo.effect_id=jsonData[id].effect_id;
				fightEffectBasicVo.uAtkBackId=jsonData[id].uAtkBackId;
				fightEffectBasicVo.atkSkyOffsetY=jsonData[id].atkSkyOffsetY;
				fightEffectBasicVo.effect_type=jsonData[id].effect_type;
				fightEffectBasicVo.atkSkyRotate=jsonData[id].atkSkyRotate;
				fightEffectBasicVo.atkSkyTimeArr=jsonData[id].atkSkyTimeArr;
				fightEffectBasicVo.atkFloorTimeArr=jsonData[id].atkFloorTimeArr;
				fightEffectBasicVo.atkBackId=jsonData[id].atkBackId;
				fightEffectBasicVo.atkBackTimeArr=jsonData[id].atkBackTimeArr;
				fightEffectBasicVo.atkSkyId=jsonData[id].atkSkyId;
				fightEffectBasicVo.atkTotalTimes=jsonData[id].atkTotalTimes;
				fightEffectBasicVo.atkFrontId=jsonData[id].atkFrontId;
				_dict[fightEffectBasicVo.effect_id]=fightEffectBasicVo;
			}
		}
		public function getFightEffectBasicVo(effect_id:int):FightEffectBasicVo
		{
			return _dict[effect_id];
		}
	}
}