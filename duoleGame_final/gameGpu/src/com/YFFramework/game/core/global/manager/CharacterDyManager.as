package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
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
		
		/**每一帧的速度
		 */		
		public var speed:Number;
		/**翅膀星运星数
		 */		
		public var wingStarNum:int;
		/**翅膀星运数
		 */		
		public var wingLuckNum:int;
		/**坐骑星运星数
		 */		
		public var mountStarNum:int;
		/**坐骑星运数
		 */		
		public var mountLuckNum:int;
		/**魔元
		 */		
		public var magicSoul:int;
		
		
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
			var len:int=propArr.length;
			for(var i:int=0;i!=len;++i)
			{
				propArr[i]=0;
			}
			speed=-1;
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
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
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
		
		/**
		 * 返回身上的装备信息，是EquipDyVo的数组 
		 * @return 
		 * 
		 */		
		public function getAllEquips():Array
		{
			return _equipDict.values();
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
		
		public function getEquipInfoByPos(pos:int):EquipDyVo
		{
			return _equipDict.get(pos) as EquipDyVo;
		}
		
		/**是否有武器
		 * 主角是否有武器
		 */		
		public function hasWeapon():Boolean
		{
			var weapon:EquipDyVo=getEquipInfoByPos(TypeProps.EQUIP_TYPE_WEAPON);
			if(weapon) return true;
			return false;
		}

		public function set newEquips(value:Array):void
		{
			_newEquips = value;
		}

		/**获取 衣服的   静态id  没有则返回-1
		 */		
//		public  function getClothBasicId():int
//		{
//			var equipDyVo:EquipDyVo=getEquipInfoByPos(TypeProps.EQUIP_TYPE_FASHION_BODY);//时装部位
//			if(!equipDyVo)
//			{
//				equipDyVo=getEquipInfoByPos(TypeProps.EQUIP_TYPE_CLOTHES);  //衣服部位
//			}
//			if(equipDyVo)
//			{
//				return equipDyVo.template_id;
//			}
//			return -1
//		}
//		public function getWeaponBasicId():int
//		{
//			var equipDyVo:EquipDyVo=getEquipInfoByPos(TypeProps.EQUIP_TYPE_WEAPON);
//			if(equipDyVo)
//			{
//				return equipDyVo.template_id;
//			}
//			return -1
//		}
//		/**翅膀
//		 */		
//		public function getWingBasicId():int
//		{
//			var equipDyVo:EquipDyVo=getEquipInfoByPos(TypeProps.EQUIP_TYPE_WINGS);
//			if(equipDyVo)
//			{
//				return equipDyVo.template_id;
//			}
//			return -1
//		}
		
	}
}