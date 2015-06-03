package com.YFFramework.game.core.module.shop.data
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	
	import flash.utils.Dictionary;

	public class ShopBasicManager
	{
		private static var _instance:ShopBasicManager;
		public static const MallId:int=100;
		
		/** 为了读取信息方便而将商店id作为索引存储 */		
		private var _shopDict:Dictionary;
		/** 用type+id做索引，shop_id为300的商店用于快速购买 */		
		private var _invisibleDict:Dictionary;
		/** 用type+id做索引，shop_id不为300的商店用于快速购买 */
		private var _visibleDict:Dictionary;
		
		private var _equipNames:Dictionary;
		private var _propsNames:Dictionary;
		
		private var _keys:Array = [];
		
		public function ShopBasicManager()
		{
			_shopDict = new Dictionary();
			_invisibleDict = new Dictionary();
			_visibleDict = new Dictionary();
			
//			_equipNames=new Dictionary();
//			_propsNames=new Dictionary();
		}

		public function get keys():Array
		{
			return _keys;
		}

		public static function get Instance():ShopBasicManager
		{
			if(_instance == null){
				_instance = new ShopBasicManager();
			}
			return _instance;
		}
		
		public function cacheData(jsonData:Object):void
		{
			var shopBasicVo:ShopBasicVo;
			var tabAry:Dictionary;
			var singleTabAry:Vector.<ShopBasicVo>;
			
			for (var id:String in jsonData){
				shopBasicVo=new ShopBasicVo();
				shopBasicVo.item_type=jsonData[id].item_type;
				shopBasicVo.price=jsonData[id].price;
				shopBasicVo.pos=jsonData[id].pos;
				shopBasicVo.shop_id=jsonData[id].shop_id;
				shopBasicVo.item_id=jsonData[id].item_id;
				shopBasicVo.sale_limit=jsonData[id].sale_limit;
				shopBasicVo.money_type=jsonData[id].money_type;
				shopBasicVo.tab_id=jsonData[id].tab_id;
				shopBasicVo.key_id=jsonData[id].key_id;
				shopBasicVo.tab_label = jsonData[id].tab_label;
				shopBasicVo.org_price = jsonData[id].org_price;
				shopBasicVo.binding_type = jsonData[id].binding_type;
//				_dict[shopBasicVo.key_id]=shopBasicVo;
				if(shopBasicVo.shop_id == 300)
					_invisibleDict[shopBasicVo.item_type.toString()+shopBasicVo.item_id.toString()]=shopBasicVo;
				else
					_visibleDict[shopBasicVo.item_type.toString()+shopBasicVo.item_id.toString()]=shopBasicVo;
				
				//每个shopId都有个tab
				if(_shopDict[shopBasicVo.shop_id] == null)
					_shopDict[shopBasicVo.shop_id]=new Dictionary();
				
				tabAry=_shopDict[shopBasicVo.shop_id];
				
				if(tabAry[shopBasicVo.tab_id] == null)
					tabAry[shopBasicVo.tab_id]=new Vector.<ShopBasicVo>() ;
				
				singleTabAry=tabAry[shopBasicVo.tab_id];
				
				singleTabAry.push(shopBasicVo);
				
			}
			
		}
		
		/** 取得某商店的所有数据
		 * @param shopID
		 * @return 
		 */		
		public function getShopInfoByShopId(shopID:int):Array
		{
			var dict:Dictionary=_shopDict[shopID];
			var tabAry:Array=[];
			for(var i:String in dict)
			{
				tabAry.push(i);
			}
			tabAry.sort(Array.NUMERIC);
			return tabAry;
		}
		
		/**
		 * 取得某个shopID和tabId下的所有商店数据
		 * @param shopID
		 * @param tabIndex
		 * @return 
		 */		
		public function getDataByIDAndTab(shopID:uint,tabIndex:int):Vector.<ShopBasicVo>
		{
			var dict:Dictionary=_shopDict[shopID];
			var tmp:Vector.<ShopBasicVo>=dict[tabIndex];
			var singleTabAry:Vector.<ShopBasicVo>=new Vector.<ShopBasicVo>();
			var ebsVo:EquipBasicVo;
			for each(var vo:ShopBasicVo in tmp)
			{
				if(vo.item_type == TypeProps.ITEM_TYPE_EQUIP)
				{
					ebsVo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
					if(ebsVo.type == TypeProps.EQUIP_TYPE_FASHION_BODY)//只有该装备和人物职业一样才可以显示
					{
						if(ebsVo.career == DataCenter.Instance.roleSelfVo.roleDyVo.career)
							singleTabAry.push(vo);
					}
					else
						singleTabAry.push(vo);
				}
				else
					singleTabAry.push(vo);
			}
			singleTabAry.sort(shopItemSort);
			return singleTabAry;
		}
		
		private function shopItemSort(a:ShopBasicVo,b:ShopBasicVo):Number
		{
			if(a.pos < b.pos) return -1;
			if(a.pos == b.pos) return 0;
			return 1;
		}
		
		/** 取得某商店都tab的名称
		 * @param shopID
		 * @param tabIndex
		 * @return 
		 * 
		 */		
		public function getTabLabelByIDAndTab(shopID:uint,tabIndex:int):String
		{
			var tabAry:Dictionary=_shopDict[shopID];
			var singleTabAry:Vector.<ShopBasicVo>=tabAry[tabIndex];
			var shopVo:ShopBasicVo=singleTabAry[singleTabAry.length-1];
			return shopVo.tab_label;
		}
		
		/**
		 * 根据 type+id来找信息,type是item type；道具or装备,专为shop_id==300的商店设计!!!
		 * @param itemType 只有两个选择：道具还是装备
		 * @param itemID 静态id
		 * @return 
		 */		
		public function getShopBasicVoDirect(itemType:int,itemID:int):ShopBasicVo
		{
			var vo:ShopBasicVo=_invisibleDict[itemType.toString()+itemID.toString()];
			return vo;
		}
		
		/** 查找除了shop_id==300的商店数据 */
		public function getShopBasicVo(itemType:int,itemID:int):ShopBasicVo
		{
			return _visibleDict[itemType.toString()+itemID.toString()];
		}
		
		/** 
		 * 保存名字和静态Id的索引，为商城搜索做准备
		 */		
//		public function getMallItemsName():void
//		{
//			for each(var shopBasicVo:ShopBasicVo in _invisibleDict)
//			{
//				if(shopBasicVo.shop_id == MallId)
//				{
//					if(shopBasicVo.item_type == TypeProps.ITEM_TYPE_EQUIP)
//						_equipNames[EquipBasicManager.Instance.getEquipBasicVo(shopBasicVo.item_id).name] = shopBasicVo.key_id;
//					else
//						_propsNames[PropsBasicManager.Instance.getPropsBasicVo(shopBasicVo.item_id).name] = shopBasicVo.key_id;
//				}
//			}
//			
//		}
		
		/**
		 * 返回货币类型名称 
		 * @param moneyType
		 * @return 
		 * 
		 */		
		public function getMoneyString(moneyType:int):String
		{
			var str:String='';
			switch(moneyType){
				case TypeProps.MONEY_DIAMOND:
					str='魔钻';
					break;
				case TypeProps.MONEY_COUPON:
					str='礼券';
					break;
//				case TypeProps.MONEY_SILVER:
//					str='银币';
//					break;
				case TypeProps.MONEY_NOTE:
					str='银锭';
					break;
			}
			return str;
		}
		
		/**
		 * 动态显示搜索下拉框里的结果 
		 * @param keyWord
		 * @return 返回名字的数组
		 * 
		 */				
//		public function getDynamicSearch(keyWord:String):Array
//		{
//			var nameAry:Array=[];
//			if(keyWord.length >0)
//			{
//				for(var equipName:String in _equipNames)
//				{
//					
//					if(equipName.indexOf(keyWord) != -1)
//					{
//						nameAry.push(equipName);
//					}
//				}
//				for(var propsName:String in _propsNames)
//				{
//					if(propsName.indexOf(keyWord) != -1)
//					{
//						nameAry.push(propsName);
//					}
//				}
//			}
//			return nameAry;
//		}
		
		/**
		 * 按下搜索按钮后 要在搜索结果里显示的信息
		 * @param searchWord
		 * @return 
		 * 
		 */				
//		public function getSearchResult(searchWord:String):Vector.<ShopBasicVo>
//		{
//			var shopInfos:Vector.<ShopBasicVo>=new Vector.<ShopBasicVo>();
//			for(var equipName:String in _equipNames)
//			{
//				if(equipName.indexOf(searchWord) != -1)
//				{
//					var equipKey:int=_equipNames[equipName];
//					shopInfos.push(_shopDict[equipKey]);
//				}
//			}
//			for(var propsName:String in _propsNames)
//			{
//				if(propsName.indexOf(searchWord) != -1)
//				{
//					var propsKey:int=_propsNames[propsName];
//					shopInfos.push(_shopDict[propsKey]);
//				}
//			}
//			return shopInfos;
//		}
		
	}
}