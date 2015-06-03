package com.YFFramework.game.core.module.forge.data
{
	import flash.utils.Dictionary;

	public class EquipDecompBasicManager
	{
		private static var _instance:EquipDecompBasicManager;
		private var _dict:Dictionary;
		public function EquipDecompBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():EquipDecompBasicManager
		{
			if(_instance==null)_instance=new EquipDecompBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var equip_decompBasicVo:EquipDecompBasicVo;
			for (var id:String in jsonData)
			{
				equip_decompBasicVo=new EquipDecompBasicVo();
				equip_decompBasicVo.mater_1_id=jsonData[id].mater_1_id;
				equip_decompBasicVo.mater_2_pr=jsonData[id].mater_2_pr;
				equip_decompBasicVo.mater_3_pr=jsonData[id].mater_3_pr;
				equip_decompBasicVo.mater_4_id=jsonData[id].mater_4_id;
				equip_decompBasicVo.equip_id=jsonData[id].equip_id;
				equip_decompBasicVo.mater_2_num=jsonData[id].mater_2_num;
				equip_decompBasicVo.mater_4_num=jsonData[id].mater_4_num;
				equip_decompBasicVo.mater_3_id=jsonData[id].mater_3_id;
				equip_decompBasicVo.mater_1_pr=jsonData[id].mater_1_pr;
				equip_decompBasicVo.mater_3_num=jsonData[id].mater_3_num;
				equip_decompBasicVo.mater_1_num=jsonData[id].mater_1_num;
				equip_decompBasicVo.mater_2_id=jsonData[id].mater_2_id;
				equip_decompBasicVo.mater_4_pr=jsonData[id].mater_4_pr;
				_dict[equip_decompBasicVo.equip_id]=equip_decompBasicVo;
			}
		}
		public function getEquipDecompBasicVo(equip_id:int):EquipDecompBasicVo
		{
			return _dict[equip_id];
		}
	}
}