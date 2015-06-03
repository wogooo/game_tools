package com.YFFramework.game.core.module.bag.data
{
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.ObjectAmount;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.baseClass.MoveGrid;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-14 下午12:02:31
	 * 
	 */
	public class BagStoreManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var packNum:int;
		private var depotNum:int;
		
		/**
		 * 数据结构是ItemDyVo 
		 */		
		private var _packList:HashMap;
		private var _depotList:HashMap;
		
		private var _newPackCells:Array;
		private var _newDepotCells:Array;
		
		private static var _instance:BagStoreManager;
		
		private var _cdList:Dictionary;
		
		/**
		 * 一个仓库和背包的总位置的哈希表 ,希望不要删之前的两个哈希表，害怕删了之后会出
		 */		
		private var _list:HashMap;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagStoreManager()
		{
			_packList=new HashMap();
			_depotList=new HashMap();
			
			_list=new HashMap();
			
			_newPackCells=[];
			_newDepotCells=[];
			
			_cdList=new Dictionary();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public static function get instantce():BagStoreManager
		{
			if(_instance == null)
				_instance=new BagStoreManager();
			return _instance;
		}
		
		public function setPackNum(num:int):void
		{
			packNum=num;
		}
		
		public function setDepotNum(num:int):void
		{
			depotNum=num;
		}
		
		/**
		 * 整个背包list更新 
		 * @param cells
		 * @param clearAll
		 * 
		 */		
		public function setPackList(cells:Array,clearAll:Boolean=false):void
		{
			if(clearAll)
			{
				var arr:Array=_packList.values();
				var len1:int=arr.length;
				for(var j:int=0;j<len1;j++)
				{
					_packList.remove(arr[j].pos);
					_list.remove(arr[j].pos);
				}
				_packList.clear();
			}
			
			var len2:int=cells.length;
			for(var i:int=0;i<len2;i++)
			{
				if(cells[i].item.type != 0)
				{
					var item:ItemDyVo=new ItemDyVo(cells[i].pos,cells[i].item.type,cells[i].item.id);
					_packList.put(item.pos,item);
					_list.put(item.pos,item);
				}
				else
				{
					_packList.remove(cells[i].pos);
					_list.remove(cells[i].pos);
				}			
			}
			
		}
		
		public function delPackList(pos:int):void
		{
			_packList.remove(pos);
		}
		
		public function setDepotList(cells:Array,clearAll:Boolean=false):void
		{
			if(clearAll)
			{
				var arr:Array=_depotList.values();
				var len1:int=arr.length;
				for(var j:int=0;j<len1;j++)
				{
					_depotList.remove(arr[j].pos);
					_list.remove(arr[j].pos);
				}
			}
			
			var len2:int=cells.length;
			for(var i:int=0;i<len2;i++)
			{
				if(cells[i].item.type != 0)
				{
					var item:ItemDyVo=new ItemDyVo(cells[i].pos,cells[i].item.type,cells[i].item.id);
					_depotList.put(item.pos,item);
					_list.put(item.pos,item);
				}
				else
				{
					_depotList.remove(cells[i].pos);
					_list.remove(cells[i].pos);
				}
			}

		}
		
		public function delDepotList(pos:int):void
		{
			_depotList.remove(pos);
		}
		
		/**
		 * 根据位置返回背包信息 
		 * @param pos
		 * @return 
		 * 
		 */		
		public function getPackInfoByPos(pos:int):ItemDyVo
		{
			return _packList.get(pos);
		}
		
		/**
		 * 根据位置返回仓库信息 
		 * @param pos
		 * @return 
		 * 
		 */		
		public function getDepotInfo(pos:int):ItemDyVo
		{
			return _depotList.get(pos);
		}
		
		/** 背包已开格子数 */
		public function getPackNum():int
		{
			return packNum;
		}
		
		/** 仓库已开格子数 */
		public function getDepotNum():int
		{
			return depotNum;
		}
		
		/**
		 * 
		 * @return 数组里的结构为ItemDyVo
		 * 
		 */		
		public function getAllPackArray():Array
		{
			var arr:Array=_packList.values();
			arr.sortOn("pos",Array.NUMERIC);
			return arr;
		}
		
		public function getAllDepotArray():Array
		{
			var arr:Array=_depotList.values();
			arr.sortOn("pos",Array.NUMERIC);
			return arr;
		}
		
		/**
		 * 返回的数组里的数据是ItemDyVo 
		 * @return 
		 * 
		 */		
		public function get newPackCells():Array
		{
			return _newPackCells;
		}
		
		public function set newPackCells(value:Array):void
		{
			_newPackCells = value;
		}
		
		public function setNewPackCells(cells:Array):void
		{
			_newPackCells=[];
			var len:int=cells.length;
			for(var i:int=0;i<len;i++)
			{
				var item:ItemDyVo=new ItemDyVo(cells[i].pos,cells[i].item.type,cells[i].item.id);
				_newPackCells.push(item);
			}
		}
		
		public function get newDepotCells():Array
		{
			return _newDepotCells;
		}
		
		public function setNewDepotCells(cells:Array):void
		{
			_newDepotCells=[];
			for(var i:int=0;i<cells.length;i++)
			{
				var item:ItemDyVo=new ItemDyVo(cells[i].pos,cells[i].item.type,cells[i].item.id);
				_newDepotCells.push(item);
			}
		}
		
		/**
		 * 返回的是在背包的位置 
		 * @param cdType
		 * @return 
		 * 
		 */		
		public function findAllSameCdType(cdType:int):Array
		{
			var packArr:Array=getAllPackArray();
			var tmpArr:Array=[];
			
			var len:int=packArr.length;
			for(var i:int=0;i<len;i++)
			{
				var item:ItemDyVo=packArr[i] as ItemDyVo;
				if(item.type == TypeProps.ITEM_TYPE_PROPS && PropsDyManager.instance.getPropsInfo(item.id))
				{
					var templateId:int=PropsDyManager.instance.getPropsInfo(item.id).templateId;
					var template:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(templateId);
					if(template)
					{		
						if(template.cd_type == cdType)
						{
							tmpArr.push(item.pos);
						}
					}
				}
			}
			return tmpArr;
		}
		
		/**
		 * 在指定的范围内找第一个同类型cd的信息（因为在整个背包位置变换时会有新旧范围之分） 
		 * @param cdType
		 * @param objHashMap 指定的moveGrids，里面都是MoveGrid类
		 * @return 
		 * 
		 */		
		public function findFirstCdItem(cdType:int,objHashMap:HashMap=null):ItemDyVo
		{	
			if(objHashMap == null)
			{
				var packArr:Array=_packList.values();
				for each(var item:ItemDyVo in packArr)
				{
					if(item.type == TypeProps.ITEM_TYPE_PROPS)
					{
						var templateId1:int=PropsDyManager.instance.getPropsInfo(item.id).templateId;
						var template1:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(templateId1);		
						if(template1.cd_type == cdType)
						{
							return item;
						}
					}
				}
			}
			else
			{
				var grids:Array=objHashMap.values();
				for each(var grid:MoveGrid in grids)
				{
					if(grid.info.type == TypeProps.ITEM_TYPE_PROPS)
					{
						var templateId2:int=PropsDyManager.instance.getPropsInfo(grid.info.id).templateId;
						var template2:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(templateId2);		
						if(template2.cd_type == cdType)
						{
							var newItem:ItemDyVo=new ItemDyVo(grid.info.pos,grid.info.type,grid.info.id);
							return newItem;
						}
					}
				}
			}		
			
			return null;
		}
		
		/**
		 * 在整个背包仓库里找同类型cdType
		 * @param cdType
		 * @return 
		 * 
		 */		
		public function findFirstCdItemInAll(cdType:int):ItemDyVo
		{
			var packArr:Array=_list.values();
			for each(var item:ItemDyVo in packArr)
			{
				if(item.type == TypeProps.ITEM_TYPE_PROPS)
				{
					var templateId1:int=PropsDyManager.instance.getPropsInfo(item.id).templateId;
					var template1:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(templateId1);		
					if(template1.cd_type == cdType)
					{
						return item;
					}
				}
			}
			return null;
		}
		
		
		/**在背包中查找新手礼包 level新手礼包的等级
		 * level新手礼包等级 
		 */
		public function findFirstLibaoItem(level:int):ItemDyVo
		{
			var packArr:Array=_list.values();
			for each(var item:ItemDyVo in packArr)
			{
				if(item.type == TypeProps.ITEM_TYPE_PROPS)
				{
					var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(item.id);
					if(propsDyVo)
					{
						var prosBasicVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(propsDyVo.templateId);
						if(prosBasicVo.type==TypeProps.PROPS_TYPE_GIFTPACKS&&prosBasicVo.level==level)
						{
							return item;
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * 返回背包所有装备
		 * @return 返回的数组是EquipDyVo
		 * 
		 */		
		public function getAllEquipsFromBag():Array
		{
			var arr:Array=_packList.values();
			var equips:Array=[];
			for each(var item:ItemDyVo in arr)
			{
				if(item.type == TypeProps.ITEM_TYPE_EQUIP)
					equips.push(item);
			}
			
			var equipsInfo:Array=[];
			for each(var equip:ItemDyVo in equips)
			{
				equipsInfo.push(EquipDyManager.instance.getEquipInfo(equip.id));
			}
			return equipsInfo;
		}
		
		/**
		 * 返回背包所有道具
		 * @return 返回的数组是PropsDyVo
		 * 
		 */		
		public function getAllPropsFromBag():Array
		{
			var arr:Array=_packList.values();
			var props:Array=[];
			for each(var item:ItemDyVo in arr)
			{
				if(item.type == TypeProps.ITEM_TYPE_PROPS)
					props.push(item);
			}
			
			var propssInfo:Array=[];
			for each(var prop:ItemDyVo in props)
			{
				propssInfo.push(PropsDyManager.instance.getPropsInfo(prop.id));
			}
			return propssInfo;
		}
		
		/** 是否能把掉落放到背包  true 为能放 false为不能 false
		 * 判断传入的数据是否在背包，在背包的话是否到达堆叠上限，不在背包的话是否有足够的格子 
		 * @param type
		 * @param templateId
		 * @return 
		 * 
		 */		
//		public function checkCanPlaceInBag(type:int,templateId:int):Boolean
		public function checkCanPlaceInBag():Boolean
		{
//			var bags:Array=_packList.values();
//			if(type == TypeProps.ITEM_TYPE_EQUIP)
//			{
//				if(_packList.size()< packNum)
//					return true;
//				else
//					return false;
//			}
//			else
//			{
//				if(_packList.size() < packNum)
//					return true;
//				else
//					return false;
//			}
			if(_packList.size()< packNum)
			{
				return true;
			}
			
			return false;
		}
		
		

		/**
		 * 传入道具或装备的数量，判断格子够不够 （如果只是判断简单的用这个方法就够了）
		 * @param templateId 
		 * @param num 判断的数量
		 * @param type 背包还是道具
		 * @return 
		 * 
		 */		
		public function checkBagHasEnoughGrids(templateId:int,num:int,type:int):Boolean
		{
			var remainGridNum:int=packNum-_packList.values().length;//还剩多少格子
			var needGridNum:Number=0;
			
			if(type == TypeProps.ITEM_TYPE_PROPS)
			{
				var propsTmp:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(templateId);
				needGridNum=num/propsTmp.stack_limit;//需要多少格子
			}
			else
			{
				var equipTmp:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(templateId);
				needGridNum=num;//装备叠加上限都是1
			}
			
			if(remainGridNum >= needGridNum)
				return true;
			else
				return false;
		}

		/**
		 * 背包里是不是有这个cdType 
		 * @param cdType
		 * @return 
		 * 
		 */		
		public function hasCdType(cdType:int):Boolean
		{
			if(_cdList[cdType])
				return true;
			else
				return false;
		}
		
		/**
		 * @param cdType
		 * @param cd 克隆一份该CD
		 */
		public function addCd(cdType:int,cd:YFCD):void
		{
			if(_cdList[cdType]==null)
			{
				_cdList[cdType]=cd.clone(completePlayCD,cdType);
			}
		}
		
		private function completePlayCD(cdType:int):void
		{
			removeCdType(cdType);
		}
		
		private function removeCdType(cdType:int):void
		{
			var cd:YFCD=_cdList[cdType];
			if(cd)
			{
				if(cd.parent) cd.parent.removeChild(cd);
				cd.dispose();
			}
			_cdList[cdType]=null;	
			delete _cdList[cdType];
			
		}
		
		public function getCd(cdType:int):YFCD
		{
			if(_cdList[cdType])
				return (_cdList[cdType] as YFCD).clone();
			
			return null;
		}
		
		/**
		 * 背包剩余格子数 
		 * @return 
		 * 
		 */		
		public function remainBagNum():int
		{
			return packNum-_packList.size();
		}
		
		/**
		 * 仓库剩余格子数 
		 * @return 
		 * 
		 */		
		public function remainDepotNum():int
		{
			return depotNum-_depotList.size();
		}
		
		/**
		 * 李深写的最复杂的
		 * 查看背包是否有足够的空间存指定的道具和装备
		 * @param equipArr	需要放到背包装备Array
		 * @param propArr	需要放到背包的道具Array
		 * @return Boolean
		 */
		public function containsEnoughSpace(equipArr:Vector.<ObjectAmount>,propArr:Vector.<ObjectAmount>):Boolean{
			var leftSpace:int=packNum-_packList.size();
			if(equipArr.length>leftSpace)	return false;
			else
			{
				leftSpace-=equipArr.length;
				var len:int=propArr.length;
				
				var stackLimit:int;
				var quantity:int;
				
				for(var i:int=0;i<len;i++)
				{
					stackLimit=PropsBasicManager.Instance.getPropsBasicVo(propArr[i].id).stack_limit;
					quantity=PropsDyManager.instance.getPropsQuantity(propArr[i].id);
					//下面等式右边算出的是背包已有道具可叠加的格子数；
					//下面等式右边算出的是背包已有道具可叠加的道具数量（分绑定和不绑定）；
					if(quantity>0)	propArr[i].amount -= stackLimit-quantity%stackLimit;
					//下面等式左边：用这个道具所需的数量-（背包已有道具）可叠加道具数量=剩余道具数量（用来算需要多少格子）
					if(propArr[i].amount>0)	leftSpace -= Math.ceil(propArr[i].amount/stackLimit);
					if(leftSpace<0)	return false;
				}
			}
			return true;
		}
		
		/**
		 * 返回背包所有非绑定指定物品的数量
		 * @param type
		 * @param templateId 给出的id已经是非绑定的id
		 * @return 
		 * 
		 */		
		public function getAllNonBoundItems(type:int,templateId:int):int
		{
			var num:int=0;
			var packAry:Array=_packList.values();
			for each(var item:ItemDyVo in packAry)
			{
				if(item.type == type)
				{
					if(type == TypeProps.ITEM_TYPE_EQUIP)
					{
						var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(item.id);
						if(templateId == equipDyVo.template_id && equipDyVo.binding_type != TypeProps.BIND_TYPE_YES)
						{
							num += 1;
						}
					}
					else
					{
						var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(item.id);
//						var propsBsVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(propsDyVo.templateId);
						if(templateId == propsDyVo.templateId && propsDyVo.binding_type == TypeProps.BIND_TYPE_NO)
						{
							num += propsDyVo.quantity;
						}
					}
				}
			}
			
			return num;
		}
		
		public function checkCanShowNewGuide(info:ItemDyVo):Boolean
		{
			var canUse:Boolean=false;
			if(info.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(info.id);
				var equipBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
				if(equipBsVo.career == DataCenter.Instance.roleSelfVo.roleDyVo.career && 
					equipBsVo.level <= DataCenter.Instance.roleSelfVo.roleDyVo.level)//职业相符、等级相符
				{
					//如果身上已经有装备
					var holeEquipDyVo:EquipDyVo=CharacterDyManager.Instance.getEquipInfoByPos(equipBsVo.type);
					if(holeEquipDyVo)
					{
						var holeEquipBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(holeEquipDyVo.template_id);
						if(equipBsVo.level > holeEquipBsVo.level)//即将穿上的装备等级大于身上的装备
							canUse=true;
						else
							canUse=false;
					}
					else//这个部位没有装备，可以穿上
						canUse=true;
				}
				else
					canUse=false;
			}
			else if(info.type == TypeProps.ITEM_TYPE_PROPS)
			{
				var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(info.id);
				var propsBsVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(propsDyVo.templateId);
				if(propsBsVo.type == TypeProps.PROPS_TYPE_PET_EGG||propsBsVo.type==TypeProps.PROPS_TYPE_MOUNT_EGG)
					canUse=true;
				else
					canUse=false;
			}
			return canUse;
		}



		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		

		
	}
} 