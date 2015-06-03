package com.YFFramework.game.core.module.blackShop.data
{
	import flash.utils.Dictionary;

	public class BlackShopBasicManager
	{
		private static var _instance:BlackShopBasicManager;
		private var _dict:Dictionary;
		public function BlackShopBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():BlackShopBasicManager
		{
			if(_instance==null)_instance=new BlackShopBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var black_ShopBasicVo:BlackShopBasicVo;
			for (var id:String in jsonData)
			{
				black_ShopBasicVo=new BlackShopBasicVo();
				black_ShopBasicVo.id=jsonData[id].id;
				black_ShopBasicVo.money_type=jsonData[id].money_type;
				black_ShopBasicVo.template_id=jsonData[id].template_id;
				black_ShopBasicVo.money=jsonData[id].money;
				_dict[black_ShopBasicVo.template_id]=black_ShopBasicVo;
			}
		}
		public function getBlackShopBasicVo(template_id:int):BlackShopBasicVo
		{
			return _dict[template_id];
		}
	}
}