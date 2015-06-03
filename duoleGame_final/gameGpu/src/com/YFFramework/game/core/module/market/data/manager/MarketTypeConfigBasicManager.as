package com.YFFramework.game.core.module.market.data.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.module.market.data.vo.MarketTypeConfigBasicVo;
	
	import flash.utils.Dictionary;
	
	/**
	 * 市场类型表，有大类、大类名、小类、小类名、热卖排行
	 * @author jina
	 * 
	 */
	public class MarketTypeConfigBasicManager
	{
		private static var _instance:MarketTypeConfigBasicManager;
		/** 没有分类存储所有信息 */
		private var _dict:Dictionary;
		/** 按照大类id索引，值是个小类的数组，数组里面存储的是MarketTypeConfigBasicVo信息 */
		private var _orderSubClassDict:Dictionary;
		/** 存储大类id的数组 */
		private var _orderTypeAry:Array;
		/** 热卖排行信息数组 */
		private var _hotTypeAry:Array;
		
		public function MarketTypeConfigBasicManager()
		{
			_dict=new Dictionary();
			_orderTypeAry=[];
			_orderSubClassDict=new Dictionary();
		}
		public static function get Instance():MarketTypeConfigBasicManager
		{
			if(_instance==null)_instance=new MarketTypeConfigBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var marketTypeConfigBasicVo:MarketTypeConfigBasicVo;
			var ary:Array;
			for (var id:String in jsonData)
			{
				marketTypeConfigBasicVo=new MarketTypeConfigBasicVo();
				marketTypeConfigBasicVo.sub_classic_type=jsonData[id].sub_classic_type;
				marketTypeConfigBasicVo.hot_sale_order=jsonData[id].hot_sale_order;
				marketTypeConfigBasicVo.subClass_name=jsonData[id].subClass_name;
				marketTypeConfigBasicVo.classic_type=jsonData[id].classic_type;
				marketTypeConfigBasicVo.classic_name=jsonData[id].classic_name;
				_dict[marketTypeConfigBasicVo.sub_classic_type]=marketTypeConfigBasicVo;
				
				if(_orderSubClassDict[marketTypeConfigBasicVo.classic_type] == null)
					_orderSubClassDict[marketTypeConfigBasicVo.classic_type]=[];
				ary=_orderSubClassDict[marketTypeConfigBasicVo.classic_type];
				ary.push(marketTypeConfigBasicVo);
			}	
			
			for(id in _orderSubClassDict)
			{
				_orderTypeAry.push(int(id));//将大类的id都放入数组，方便初始化
				ary=_orderSubClassDict[id];
				ary.sortOn("sub_classic_type",Array.NUMERIC);
			}
			
			_orderTypeAry.sortOn("classic_type",Array.NUMERIC);
		}
		/**
		 * 通过唯一的索引:小类id，返回 MarketTypeConfigBasicVo（包含大类id，大类名称，小类id，小类名称，热销排序号）
		 * @param id
		 * @return 
		 * 
		 */		
		public function getMarketTypeConfigBasicVo(class_id:int):MarketTypeConfigBasicVo
		{
			return _dict[class_id];
		}
		
		/** 通过classic_type(大类id)，返回这个大类下的所有子类 */
		public function getMarketTypeInfo(classic_type:int):Array
		{
			return _orderSubClassDict[classic_type];
		}
		
		/** 返回所有大类id的数组 */
		public function getAllClassicType():Array
		{
			return _orderTypeAry;
		}
//		/**
//		 * 返回市场有多少个大类 ，数组的键值是type，值是名称
//		 * 注意！索引0的位置为空
//		 * @return 
//		 * 
//		 */		
//		public function getTypeArray():Array
//		{
//			var oldType:int=0;
//			var typeArray:Array=[];
//			
//			for each(var bVo:MarketTypeConfigBasicVo in _orderTypeAry)
//			{
//				if(oldType != bVo.classic_type)
//				{
//					typeArray[bVo.classic_type]=bVo.classic_name;
//				}
//				oldType=bVo.classic_type;
//			}
//			return typeArray;
//		}
//		
//		/**
//		 * 查询某个大类的所有子类,返回时object的数组
//		 * @param type
//		 * @return 
//		 * 
//		 */		
//		public function getSubTypeArray(type:int):Array
//		{
//			var subType:Array=new Array();
//			var obj:Object;
//			
//			for each(var vo:MarketTypeConfigBasicVo in _orderTypeAry)
//			{
//				if(type == vo.classic_type)
//				{
//					obj=new Object();
//					obj.subType=vo.subClassic_type;
//					obj.subTypeName=vo.subClass_name;
//					subType.push(obj);
//				}
//			}
//			return subType;
//		}

		/**
		 * 通过热销index返回包含MarketTypeConfigBasicVo的数组
		 * @return 注意返回的数组第0个元素是空
		 * 
		 */		
		public function getHotSaleAry():Array
		{
			if(_hotTypeAry != null) return _hotTypeAry;
			else
			{
				_hotTypeAry=[];
				for each(var vo:MarketTypeConfigBasicVo in _dict)
				{
					if(vo.hot_sale_order > 0)
						_hotTypeAry[vo.hot_sale_order]=vo;
				}				
				return _hotTypeAry;
			}
			return null;
		}
		
		/**
		 * 通过子类id返回MarketTypeConfigBasicVo
		 * @param index
		 * @return 
		 * 
		 */		
//		public function getInfoBySubType(subType:int):MarketTypeConfigBasicVo
//		{	
//			for each(var vo:MarketTypeConfigBasicVo in _orderTypeAry)
//			{
//				if(vo.hot_sale_order == subType)
//				{
//					return vo;
//				}
//			}
//			return null;
//		}
	}
}