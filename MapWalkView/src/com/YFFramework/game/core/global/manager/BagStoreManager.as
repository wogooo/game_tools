package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;

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
		
		private var _packList:HashMap;
		private var _depotList:HashMap;
		
		private var _newPackCells:Array;
		private var _newDepotCells:Array;
		
		private static var _instance:BagStoreManager;
		
		private var _curCdType:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagStoreManager()
		{
			_packList=new HashMap();
			_depotList=new HashMap();
			
			_newPackCells=[];
			_newDepotCells=[];
			
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
				for(var j:int=0;j<arr.length;j++)
				{
					_packList.remove(arr[j].pos);
				}
			}
			
			for(var i:int=0;i<cells.length;i++)
			{
				if(cells[i].item.type != 0)
				{
					var item:ItemDyVo=new ItemDyVo(cells[i].pos,cells[i].item.type,cells[i].item.id);
					_packList.put(item.pos,item);
				}
				else
				{
					_packList.remove(cells[i].pos);
				}			
			}
			
		}
		
		public function setDepotList(cells:Array,clearAll:Boolean=false):void
		{
			if(clearAll)
			{
				var arr:Array=_depotList.values();
				for(var j:int=0;j<arr.length;j++)
				{
					_depotList.remove(arr[j].pos);
				}
			}
			
			for(var i:int=0;i<cells.length;i++)
			{
				if(cells[i].item.type != 0)
				{
					var item:ItemDyVo=new ItemDyVo(cells[i].pos,cells[i].item.type,cells[i].item.id);
					_depotList.put(item.pos,item);
				}
				else
				{
					_depotList.remove(cells[i].pos);
				}
			}

		}
		
		/**
		 * 根据位置返回背包信息 
		 * @param pos
		 * @return 
		 * 
		 */		
		public function getPackInfo(pos:int):ItemDyVo
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
		public function getPackNum():int
		{
			return packNum;
		}
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
		
		public function setNewPackCells(cells:Array):void
		{
			_newPackCells=[];
			for(var i:int=0;i<cells.length;i++)
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
		
		public function findAllSameCdType(cdType:int):Array
		{
			var packArr:Array=getAllPackArray();
			var tmpArr:Array=[];
			
			_curCdType=cdType;
			
			for(var i:int=0;i<packArr.length;i++)
			{
				var item:ItemDyVo=packArr[i] as ItemDyVo;
				if(item.type == TypeProps.ITEM_TYPE_PROPS)
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
		 *  
		 * @return 返回的数组是EquipDyVo
		 * 
		 */		
		public function getAllEquips():Array
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
		 *  
		 * @return 返回的数组是PropsDyVo
		 * 
		 */		
		public function getAllProps():Array
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
		
		/**
		 * 判断传入的数据是否在背包，在背包的话是否到达堆叠上限，不在背包的话是否有足够的格子 
		 * @param type
		 * @param templateId
		 * @return 
		 * 
		 */		
		public function checkInBag(type:int,templateId:int):Boolean
		{
			var bags:Array=_packList.values();
			if(type == TypeProps.ITEM_TYPE_EQUIP)
			{
				if(_packList.values().length < packNum)
					return true;
				else
					return false;
			}
			else
			{
				for each(var item2:ItemDyVo in bags)
				{
					if(item2.type == TypeProps.ITEM_TYPE_PROPS)
					{
						var props:PropsDyVo=PropsDyManager.instance.getPropsInfo(item2.id);
						if(props.templateId == templateId)
						{
							var template:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(props.templateId);
							if(props.quantity < template.stack_limit)
							{
								return true;
							}
							else
							{
								return false;
							}
						}
					}
				}
				
				if(_packList.values().length < packNum)
					return true;
				else
					return false;
			}
			
		}

		public function get curCdType():int
		{
			return _curCdType;
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