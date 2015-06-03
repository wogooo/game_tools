package com.YFFramework.game.core.module.exchange.manager
{
	import com.YFFramework.game.core.module.exchange.model.Exchange_MapBasicVo;
	
	import flash.utils.Dictionary;

	public class Exchange_MapBasicManager
	{
		private static var _instance:Exchange_MapBasicManager;
		private var _dict:Dictionary;
		private var _arr:Vector.<Exchange_MapBasicVo>;
		public function Exchange_MapBasicManager()
		{
			_dict=new Dictionary();
			_arr=new Vector.<Exchange_MapBasicVo>;
		}
		public static function get Instance():Exchange_MapBasicManager
		{
			if(_instance==null)_instance=new Exchange_MapBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var exchange_MapBasicVo:Exchange_MapBasicVo;
			for (var id:String in jsonData)
			{
				exchange_MapBasicVo=new Exchange_MapBasicVo();
				exchange_MapBasicVo.get_id=jsonData[id].get_id;
				exchange_MapBasicVo.map_id=jsonData[id].map_id;
				exchange_MapBasicVo.need_id=jsonData[id].need_id;
				_dict[exchange_MapBasicVo.map_id]=exchange_MapBasicVo;
				_arr.push(exchange_MapBasicVo);
			}
		}
		public function getExchange_MapBasicVo(map_id:int):Exchange_MapBasicVo
		{
			return _dict[map_id];
		}
		public function getAllExchangeMapBasicVo():Vector.<Exchange_MapBasicVo>
		{
			return _arr;
		}
	}
}