package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.EquipSuitBasicVo;
	
	import flash.utils.Dictionary;

	/**缓存套装数据 Equip_Suit.json
	 */	
	public class EquipSuitBasicManager
	{
		private static var _instance:EquipSuitBasicManager;
		private var _dict:Dictionary;
		public function EquipSuitBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():EquipSuitBasicManager
		{
			if(_instance==null)_instance=new EquipSuitBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var equip_SuitBasicVo:EquipSuitBasicVo;
			var itemDict:Dictionary;
			for (var id:String in jsonData)
			{
				equip_SuitBasicVo=new EquipSuitBasicVo();
				equip_SuitBasicVo.id=jsonData[id].id;
				equip_SuitBasicVo.suit_id=jsonData[id].suit_id;
				equip_SuitBasicVo.app_attr_v2=jsonData[id].app_attr_v2;
				equip_SuitBasicVo.app_attr_t2=jsonData[id].app_attr_t2;
				equip_SuitBasicVo.unit_num=jsonData[id].unit_num;
				equip_SuitBasicVo.suits_name=jsonData[id].suits_name;
				equip_SuitBasicVo.app_attr_v1=jsonData[id].app_attr_v1;
				equip_SuitBasicVo.app_attr_t1=jsonData[id].app_attr_t1;
				
				if(!_dict[equip_SuitBasicVo.suit_id])
				{
					itemDict=new Dictionary();
					_dict[equip_SuitBasicVo.suit_id]=itemDict;
				}
				itemDict=_dict[equip_SuitBasicVo.suit_id];
				itemDict[equip_SuitBasicVo.unit_num]=equip_SuitBasicVo;
			}
		} 
		/**
		 * @param suit_id 套装id 
		 * @param num  当前个数
		 * @return 
		 * 
		 */		
		public function getEquipSuitBasicVo(suit_id:int,num:int):EquipSuitBasicVo
		{
			var suitBasicVo:EquipSuitBasicVo=_dict[suit_id][num];
			return suitBasicVo;
		}
		
		/**
		 * 返回排序号的数组 
		 * @param suit_id
		 * @return 
		 * 
		 */		
		public function getEquipSuitArray(suit_id:int):Array
		{
			var itemDict:Dictionary=_dict[suit_id];
			var arr:Array=[];
			for each(var suit:EquipSuitBasicVo in itemDict)
			{
				arr.push(suit);
			}
			arr.sortOn("unit_num");
			return arr;
		}

		
		
	}
}