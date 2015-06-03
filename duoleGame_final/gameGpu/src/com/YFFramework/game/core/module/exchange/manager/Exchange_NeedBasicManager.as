package com.YFFramework.game.core.module.exchange.manager
{
	import com.YFFramework.game.core.module.exchange.model.Exchange_NeedBasicVo;
	
	import flash.utils.Dictionary;

	public class Exchange_NeedBasicManager
	{
		private static var _instance:Exchange_NeedBasicManager;
		private var _dict:Dictionary;
		public function Exchange_NeedBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Exchange_NeedBasicManager
		{
			if(_instance==null)_instance=new Exchange_NeedBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var exchange_NeedBasicVo:Exchange_NeedBasicVo;
			for (var id:String in jsonData)
			{
				exchange_NeedBasicVo=new Exchange_NeedBasicVo();
				exchange_NeedBasicVo.item_num=jsonData[id].item_num;
				exchange_NeedBasicVo.item_id=jsonData[id].item_id;
				exchange_NeedBasicVo.group_id=jsonData[id].group_id;
				if(!_dict[exchange_NeedBasicVo.group_id])
				{
					_dict[exchange_NeedBasicVo.group_id]=new Vector.<Exchange_NeedBasicVo>;
				}
				_dict[exchange_NeedBasicVo.group_id].push(exchange_NeedBasicVo);
			}
		}
		public function getExchange_NeedBasicVo(group_id:int):Vector.<Exchange_NeedBasicVo>
		{
			return _dict[group_id];
		}
	}
}