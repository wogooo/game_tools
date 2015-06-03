package com.YFFramework.game.core.module.forge.data
{
	import flash.utils.Dictionary;

	public class EquipEnhanceBasicManager
	{
		private static var _instance:EquipEnhanceBasicManager;
		private var _dict:Dictionary;
		public function EquipEnhanceBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():EquipEnhanceBasicManager
		{
			if(_instance==null)_instance=new EquipEnhanceBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var equip_EnhanceBasicVo:EquipEnhanceBasicVo;
			for (var id:String in jsonData)
			{
				equip_EnhanceBasicVo=new EquipEnhanceBasicVo();
//				equip_EnhanceBasicVo.enhance_equip4=jsonData[id].enhance_equip4;
//				equip_EnhanceBasicVo.enhance_equip3=jsonData[id].enhance_equip3;
//				equip_EnhanceBasicVo.enhance_equip1=jsonData[id].enhance_equip1;
//				equip_EnhanceBasicVo.enhance_equip6=jsonData[id].enhance_equip6;
//				equip_EnhanceBasicVo.enhance_equip2=jsonData[id].enhance_equip2;
//				equip_EnhanceBasicVo.enhance_equip5=jsonData[id].enhance_equip5;
				equip_EnhanceBasicVo.level=jsonData[id].level;
				equip_EnhanceBasicVo.template_id=jsonData[id].template_id;
				equip_EnhanceBasicVo.num=jsonData[id].num;
				_dict[equip_EnhanceBasicVo.level]=equip_EnhanceBasicVo;
			}
		}
		/** 
		 * @param level 强化等级
		 * @return 
		 * 
		 */		
		public function getEquipEnhanceBasicVo(level:int):EquipEnhanceBasicVo
		{
			return _dict[level];
		}
	}
}