package com.YFFramework.game.core.module.forge.data
{
	import flash.utils.Dictionary;

	public class EquipLevelUpBasicManager
	{
		private static var _instance:EquipLevelUpBasicManager;
		private var _dict:Dictionary;
		public function EquipLevelUpBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():EquipLevelUpBasicManager
		{
			if(_instance==null)_instance=new EquipLevelUpBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var equip_LevelupBasicVo:EquipLevelupBasicVo;
			for (var id:String in jsonData)
			{
				equip_LevelupBasicVo=new EquipLevelupBasicVo();
				equip_LevelupBasicVo.before_level=jsonData[id].before_level;
				equip_LevelupBasicVo.props_id=jsonData[id].props_id;
				equip_LevelupBasicVo.after_level=jsonData[id].after_level;
				equip_LevelupBasicVo.props_num=jsonData[id].props_num;
				equip_LevelupBasicVo.after_quality=jsonData[id].after_quality;
				equip_LevelupBasicVo.money=jsonData[id].money;
				_dict[equip_LevelupBasicVo.before_level]=equip_LevelupBasicVo;
			}
		}
		
		/** 给出当前等级，查询属于哪条记录范围内
		 * @param level
		 * @return 
		 * 
		 */		
		public function getEquipLevelupBasicVo(level:int):EquipLevelupBasicVo
		{
			for each(var vo:EquipLevelupBasicVo in _dict)
			{
				if(level >= vo.before_level && level <= (vo.before_level+9))
					return _dict[vo.before_level];
			}
			return null;
		}
		
	}
}