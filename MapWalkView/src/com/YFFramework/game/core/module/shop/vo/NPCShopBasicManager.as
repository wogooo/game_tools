package com.YFFramework.game.core.module.shop.vo
{
	import flash.utils.Dictionary;

	public class NPCShopBasicManager
	{
		private static var _instance:NPCShopBasicManager;
		
		private var _dict:Dictionary;
		private var _all:Dictionary;
		private var _keys:Array = [];
		
		public function NPCShopBasicManager()
		{
			_dict = new Dictionary();
			_all = new Dictionary();
		}

		public function get keys():Array
		{
			return _keys;
		}

		public static function get Instance():NPCShopBasicManager
		{
			if(_instance == null){
				_instance = new NPCShopBasicManager();
			}
			return _instance;
		}
		
		public function cacheData(jsonData:Object):void
		{
			var shopBasicVo:ShopBasicVo;
			var keyID:int;
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
				_dict[shopBasicVo.key_id]=shopBasicVo;
				keyID = shopBasicVo.key_id;
				_dict[keyID] = shopBasicVo;
				_keys.push(keyID);
			}
			//整理归类缓存
			var i:int;
			var len:int = _keys.length;
			var vo:ShopBasicVo;
			var keyStr:String;
			var shopKeyStr:String;
			for(i=0;i<len;i++){
				vo = _dict[_keys[i]];
				keyStr = "s"+vo.shop_id+"_t"+vo.tab_id;
				shopKeyStr = "shop"+vo.shop_id;
				if(_all[keyStr] == null){
					_all[keyStr] = new Vector.<ShopBasicVo>();
				}
				_all[keyStr].push(vo);
				if(_all[shopKeyStr] == null){
					_all[shopKeyStr] = new Vector.<ShopBasicVo>();
				}
				_all[shopKeyStr].push(vo); 
			}
			for(var obj:Object in _all){
				var vct:Vector.<ShopBasicVo> = _all[obj];
				_all[obj] = vct.sort(shopItemSort);
			}
		}
		
		/**
		 * 获取商店物品的位置信息 
		 * @param shopID
		 * @param itemID
		 * @return 
		 * 
		 */
		public function getPositionByShopAndItemID(shopID:int,itemID:int,itemType:int):int
		{
			var pos:int;
			var shopKeyStr:String;
			var vct:Vector.<ShopBasicVo>;
			
			shopKeyStr = "shop"+shopID;
			vct = _all[shopKeyStr];
			//商店未找到
			if(vct == null) return -1;
			for(var i:Object in vct){
				var vo:ShopBasicVo = vct[i];
				if(vo.item_id == itemID && vo.item_type == itemType ){
					pos = vo.pos;
					break;
				}
			}
			return pos;
		}
		
		public function getShopTabsLength(shopID:int):int
		{
			var len:int=0;
			var shopKeyStr:String;
			shopKeyStr = "shop"+shopID;
			var vct:Vector.<ShopBasicVo> = _all[shopKeyStr];
			if(vct != null){
				for(var i:int=0;i<vct.length;i++){
					if(vct[i].tab_id>len){
						len = vct[i].tab_id;
					}
				}
			}
			return len;
		}
		
		private function shopItemSort(a:ShopBasicVo,b:ShopBasicVo):Number
		{
			if(a.pos < b.pos) return -1;
			if(a.pos == b.pos) return 0;
			return 1;
		}
		
		public function getListByIDAndTab(shopID:uint,tabIndex:int):Vector.<ShopBasicVo>
		{
			var list:Vector.<ShopBasicVo> = _all["s"+shopID+"_t"+tabIndex];
			if(list == null) list = new Vector.<ShopBasicVo>();
			return list;
		}
		
		public function getTabLabelByIDAndTab(shopID:uint,tabIndex:int):String
		{
			var list:Vector.<ShopBasicVo> = _all["s"+shopID+"_t"+tabIndex];
			if(list == null) return "";
			return list[0].tab_label;
		}
		
		public function getShopBasicVo(keyID:int):ShopBasicVo
		{
			return _dict[keyID];
		}
		
		public function getShopBasicVoByItemID(itemID:int):ShopBasicVo
		{
			var vo:ShopBasicVo;
			for(var obj:Object in _dict){
				if(ShopBasicVo(_dict[obj]).item_id == itemID){
					vo = _dict[obj];
					break;
				}
			}
			return vo;
		}
		
	}
}