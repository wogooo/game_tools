package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.msg.storage.Cell;

	/**人物装备信息
	 * @author yefeng
	 * 2013 2013-3-18 下午3:32:17 
	 */
	public class CharacterDyManager
	{
		/** 公会名称
		 */		
		public var  unionName:String;
		/**pk 值  ,罪恶
		 */		
		public var pkValue:int;

		/**称号
		 */	
		public var title:String;
		/**阅历
		 */		
		public var yueli:int;
		/**活力
		 */		
		public var energy:int
		/**荣誉
		 */		
		public var honour:int;
		/**潜力 
		 */
		public var potential:int;
		
		/**战斗力
		 */		
		public var power:int;
	
		/**属性数组  ExtraAttr 类 一一对应
		 */
		public var propArr:Array;
		
		
		/**长度为 40的数组  代表 不同的数值  和协议ExtraAttr 数值对应
		 */		
		public var characterArr:Array;
		
		/**具体部位在 在  EquipType里面
		 * 存储装备
		 */		
		private var _equipDict:HashMap;
		private static var _instance:CharacterDyManager;
		
		private var _newEquips:Array;
		
		public function CharacterDyManager()
		{
			_equipDict=new HashMap();
			propArr=[];
			propArr.length=40;
		}

		
		public static function get Instance():CharacterDyManager
		{
			if(_instance==null)_instance=new CharacterDyManager();
			return _instance;
		}
		/**穿装备
		 *  以格子作为键值
		 */		
		public function addEquip(equips:Array):void
		{
			var equipDyVo:EquipDyVo;
			for each(var cell:Cell in equips)
			{
				if(cell.item.type != 0)
				{
					equipDyVo=EquipDyManager.instance.getEquipInfo(cell.item.id);
					equipDyVo.position=cell.pos;
					equipDyVo.type=cell.item.type;
					_equipDict.put(equipDyVo.position,equipDyVo);
				}
				else
				{
					_equipDict.remove(cell.pos);
				}
			}
		}
		
		public function getNewEquips():Array
		{
			return _newEquips;
		}
		
		public function setNewEquips(value:Array):void
		{
			var equipDyVo:EquipDyVo;
			_newEquips=[];
			for each(var cell:Cell in value)
			{
				equipDyVo=EquipDyManager.instance.getEquipInfo(cell.item.id);
				equipDyVo.position=cell.pos;
				equipDyVo.type=cell.item.type;
				_newEquips.push(equipDyVo);
			}
		}
		
		/**获取装备信息
		 */		
		public function getEquipDict():HashMap
		{
			return _equipDict;
		}
		
		public function getAllEquips():Array
		{
			var equips:Array=[];
			for each(var equip:EquipDyVo in _equipDict)
			{
				equips.push(equip);
			}
			return equips;
		}
		
		/**
		 * 获取单个装备id,如果没有，return -1
		 * @param gridPos
		 * @return int
		 * 
		 */			
		public function getEquipId(gridPos:int):int{
			if(_equipDict.get(gridPos))	return (_equipDict.get(gridPos) as EquipDyVo).equip_id;
			return -1;
		}
		
		/**
		 * 获取单个装备的template_id,如果没有，return -1
		 * @param gridPos
		 * @return int
		 */	
		public function getEquipTempId(gridPos:int):int{
			if(_equipDict.get(gridPos))	return (_equipDict.get(gridPos) as EquipDyVo).template_id;
			return -1;
		}
		
		public function getEquipInfo(pos:int):EquipDyVo
		{
			return _equipDict.get(pos) as EquipDyVo;
		}
	}
}