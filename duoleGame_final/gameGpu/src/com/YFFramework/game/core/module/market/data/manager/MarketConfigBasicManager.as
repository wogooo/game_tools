package com.YFFramework.game.core.module.market.data.manager
{
	
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.market.data.vo.MarketConfigBasicVo;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	
	import flash.utils.Dictionary;

	/**
	 *  商店分类配置表：主要提供每个子类有什么模板id(就是有什么物品，装备或道具)
	 * @author jina
	 * 
	 */	
	public class MarketConfigBasicManager
	{
		private static var _instance:MarketConfigBasicManager;
		/** 没有任何分类 */
		private var _dict:Dictionary;
		/** 按子类分类 */
		private var _orderTypeDict:Dictionary;
//		private var _orderTypeAry:Array;
		
		public function MarketConfigBasicManager()
		{
			_dict=new Dictionary();
//			_orderTypeAry=[];
			_orderTypeDict=new Dictionary();
		}
		public static function get Instance():MarketConfigBasicManager
		{
			if(_instance==null)_instance=new MarketConfigBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var market_ConfigBasicVo:MarketConfigBasicVo;
			var ary:Array;
			for (var id:String in jsonData)
			{
				market_ConfigBasicVo=new MarketConfigBasicVo();
				market_ConfigBasicVo.id=jsonData[id].id;
				market_ConfigBasicVo.sub_classic_type=jsonData[id].sub_classic_type;
				market_ConfigBasicVo.item_type=jsonData[id].item_type;
				market_ConfigBasicVo.item_id=jsonData[id].item_id;
				_dict[market_ConfigBasicVo.id]=market_ConfigBasicVo;
				
				if(_orderTypeDict[market_ConfigBasicVo.sub_classic_type] == null)
					_orderTypeDict[market_ConfigBasicVo.sub_classic_type]=[];
				ary=_orderTypeDict[market_ConfigBasicVo.sub_classic_type];
				ary.push(market_ConfigBasicVo);
			}
			
		}
		/**
		 * 通过唯一索引id，返回MarketConfigBasicVo（包含大类、小类、物品信息） 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getMarketConfigBasicVo(id:int):MarketConfigBasicVo
		{
			return _dict[id];
		}
		
		/** 根据子类，返回子类下所有物品信息,是MarketConfigBasicVo的数组 */
		public function getAllClassId(class_id:int):Array
		{
			return _orderTypeDict[class_id];
		}
		
		/**
		 * 返回全部符合大类条件的item数组（类型:MarketConfigBasicVo）
		 * @param type
		 * @return 
		 * 
		 */		
//		public function getTypeAry(type:int):Vector.<MarketConfigBasicVo>
//		{
//			var tmp:Vector.<MarketConfigBasicVo>=new Vector.<MarketConfigBasicVo>();
//			
//			for each(var vo:MarketConfigBasicVo in _dict)
//			{
//				if(vo.classic_type == type)
//				{
//					tmp.push(vo);
//				}
//			}
//			return tmp;
//		}
		
		/**
		 * 返回全部符合子类条件的item数组（类型:MarketConfigBasicVo）
		 * @param subType 不能为0
		 * @param level
		 * @return 
		 * 
		 */		
		public function getSubTypeAry(subType:int,level:int=1,quality:int=0):Array
		{
			var tmp:Array=[];
			for each(var vo:MarketConfigBasicVo in _dict)
			{
				if(vo.sub_classic_type == subType)
				{
					tmp.push(vo);
				}
			}
			
			var propsBsVo:PropsBasicVo;
			var equipBsVo:EquipBasicVo;
			if(level > MarketSource.LEVEL_ALL)
			{
				
				var tmp1:Array=[];
				for each(var vo1:MarketConfigBasicVo in tmp)
				{
					if(vo1.item_type == TypeProps.ITEM_TYPE_PROPS)
					{
						propsBsVo = PropsBasicManager.Instance.getPropsBasicVo(vo1.item_id);
						switch(level)
						{
							case MarketSource.LEVEL_ONE:
								if(propsBsVo.level >= 1 && propsBsVo.level <= 29)
								{
									tmp1.push(vo1);
								}
								break;
							case MarketSource.LEVEL_TWO:
								if(propsBsVo.level >= 30 && propsBsVo.level <= 49)
								{
									tmp1.push(vo1);
								}
								break;
							case MarketSource.LEVEL_THREE:
								if(propsBsVo.level >= 50 && propsBsVo.level <= 69)
								{
									tmp1.push(vo1);
								}
								break;
						}
					}
					else
					{
						equipBsVo = EquipBasicManager.Instance.getEquipBasicVo(vo1.item_id);
						switch(level)
						{
							case MarketSource.LEVEL_ONE:
								if(equipBsVo.level >= 1 && equipBsVo.level <= 29)
								{
									tmp1.push(vo1);
								}
								break;
							case MarketSource.LEVEL_TWO:
								if(equipBsVo.level >= 30 && equipBsVo.level <= 49)
								{
									tmp1.push(vo1);
								}
								break;
							case MarketSource.LEVEL_THREE:
								if(equipBsVo.level >= 50 && equipBsVo.level <= 69)
								{
									tmp1.push(vo1);
								}
								break;
						}
					}
				}
				tmp=tmp1;
			}
			
			if(quality > MarketSource.QUALITY_ALL)
			{
				tmp1=[];
				for each(var vo2:MarketConfigBasicVo in tmp)
				{
					if(vo2.item_type == TypeProps.ITEM_TYPE_PROPS)
					{
						propsBsVo = PropsBasicManager.Instance.getPropsBasicVo(vo2.item_id);
						switch(quality)
						{
							case TypeProps.QUALITY_WHITE:
								if(propsBsVo.quality == TypeProps.QUALITY_WHITE)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_BLUE:
								if(propsBsVo.quality == TypeProps.QUALITY_BLUE)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_GREEN:
								if(propsBsVo.quality == TypeProps.QUALITY_GREEN)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_ORANGE:
								if(propsBsVo.quality == TypeProps.QUALITY_ORANGE)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_PURPLE:
								if(propsBsVo.quality == TypeProps.QUALITY_PURPLE)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_RED:
								if(propsBsVo.quality == TypeProps.QUALITY_RED)
									tmp1.push(vo2);
								break;
						}
					}
					else
					{
						equipBsVo = EquipBasicManager.Instance.getEquipBasicVo(vo2.item_id);
						switch(quality)
						{
							case TypeProps.QUALITY_WHITE:
								if(equipBsVo.quality == TypeProps.QUALITY_WHITE)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_BLUE:
								if(equipBsVo.quality == TypeProps.QUALITY_BLUE)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_GREEN:
								if(equipBsVo.quality == TypeProps.QUALITY_GREEN)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_ORANGE:
								if(equipBsVo.quality == TypeProps.QUALITY_ORANGE)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_PURPLE:
								if(equipBsVo.quality == TypeProps.QUALITY_PURPLE)
									tmp1.push(vo2);
								break;
							case TypeProps.QUALITY_RED:
								if(equipBsVo.quality == TypeProps.QUALITY_RED)
									tmp1.push(vo2);
								break;
						}
					}
				}
				tmp=tmp1;
			}
			
			return tmp;
		}
		
		/**
		 * 查找具体的数据 
		 * @param type
		 * @param id
		 * @return 
		 * 
		 */		
		public function getItemInfo(type:int,id:int):MarketConfigBasicVo
		{
			for each(var vo:MarketConfigBasicVo in _dict)
			{
				if(vo.item_type == type && vo.item_id == id)
				{
					return vo;
				}
			}
			return null;
		}
		
		/**
		 * 返回名字有所给关键字的数组 
		 * @param str
		 * @return 
		 * 
		 */		
		public function getAllItemContainsNameStr(str:String):Array
		{
			var itemAry:Array=[];
			var name:String='';
			
			for each(var vo:MarketConfigBasicVo in _dict)
			{
				if(vo.item_type == TypeProps.ITEM_TYPE_EQUIP && EquipBasicManager.Instance.getEquipBasicVo(vo.item_id))
				{
					name=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id).name;
					if(name.indexOf(str) != -1)
					{
						itemAry.push(vo);
					}		
				}
				else if(vo.item_type == TypeProps.ITEM_TYPE_PROPS && PropsBasicManager.Instance.getPropsBasicVo(vo.item_id))
				{
					name=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id).name;
					if(name.indexOf(str) != -1)
					{
						itemAry.push(vo);
					}	
				}
			}
			
			return itemAry;
		}
		
		/**
		 * 寻找配置表里的道具或装备名字与所给字符串是否匹配（关键字搜索时使用）
		 * @param str
		 * @return 
		 * 
		 */		
		public function getItemEqualName(str:String):MarketConfigBasicVo
		{
			var name:String='';
			
			for each(var vo:MarketConfigBasicVo in _dict)
			{
				if(vo.item_type == TypeProps.ITEM_TYPE_EQUIP)
				{
					name=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id).name;
					if(str == name)
					{
						return vo;
					}
				}
				else if(vo.item_type == TypeProps.ITEM_TYPE_PROPS)
				{
					name=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id).name;
					if(str == name)
					{
						return vo;
					}
				}
			}
			return null;
		}
	}
}