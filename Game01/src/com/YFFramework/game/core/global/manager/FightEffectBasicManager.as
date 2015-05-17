package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	
	import flash.utils.Dictionary;

	/**
	 *   缓存 特效 表  fightEffect.json
	 * 2012-9-3 下午5:02:28
	 *@author yefeng
	 */
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
			
		
		/**缓存数据  fightEffect.json
		 * 
		 */		
		public function cacheData(jsonData:Object):void
		{
			var effectBasicVo:FightEffectBasicVo;
			for (var id:String in jsonData)
			{
				effectBasicVo=new FightEffectBasicVo();
				effectBasicVo.id=int(id);
				effectBasicVo.atkTimeArr=jsonData[id].atkTimeArr;
				effectBasicVo.atkTotalTimes=jsonData[id].atkTotalTimes;
				effectBasicVo.atkFrontId =jsonData[id].atkFrontId;
				effectBasicVo.atkFrontDirection=jsonData[id].atkFrontDirection;

				effectBasicVo.atkFrontTimeArr=jsonData[id].atkFrontTimeArr;
		//		effectBasicVo.atkFrontTotalTimes =jsonData[id].atkFrontTotalTimes;
				effectBasicVo.atkBackId =jsonData[id].atkBackId;
				effectBasicVo.atkBackTimeArr=jsonData[id].atkBackTimeArr;
		//		effectBasicVo.atkBackTotalTimes =jsonData[id].atkBackTotalTimes;
				effectBasicVo.uAtkFrontId =jsonData[id].uAtkFrontId;
				effectBasicVo.uAtkTimeArr=jsonData[id].uAtkTimeArr;
				effectBasicVo.uAtkFrontTimeArr=jsonData[id].uAtkFrontTimeArr;
		//		effectBasicVo.uAtkFrontTotalTimes =jsonData[id].uAtkFrontTotalTimes;
				effectBasicVo.uAtkBackId  =jsonData[id].uAtkBackId;
				effectBasicVo.uAtkBackTimeArr=jsonData[id].uAtkBackTimeArr;
		//		effectBasicVo.uAtkBackTotalTimes =jsonData[id].uAtkBackTotalTimes;
				effectBasicVo.skyId  =jsonData[id].skyId;
				effectBasicVo.skyTimeArr=jsonData[id].skyTimeArr;
		//		effectBasicVo.skyTotalTimes =jsonData[id].skyTotalTimes;
				effectBasicVo.skyPositionType=jsonData[id].skyPositionType;
				effectBasicVo.skyOffset=jsonData[id].skyOffset;
				effectBasicVo.floorId  =jsonData[id].floorId;
				effectBasicVo.floorTimeArr=jsonData[id].floorTimeArr;
		//		effectBasicVo.floorTotalTimes =jsonData[id].floorTotalTimes;
				effectBasicVo.floorPositionType=jsonData[id].floorPositionType;
				effectBasicVo.floorOffset=jsonData[id].floorOffset;
				_dict[effectBasicVo.id]=effectBasicVo;
			}
		}
		
		public function  getEffectBasicVo(fightEffectId:int):FightEffectBasicVo
		{
			return _dict[fightEffectId];
		}
	}
}