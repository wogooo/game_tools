package com.YFFramework.game.core.module.exchange.manager
{
	import com.YFFramework.game.core.module.exchange.model.Exchange_GetBasicVo;
	
	import flash.utils.Dictionary;

	public class Exchange_GetBasicManager
	{
		private static var _instance:Exchange_GetBasicManager;
		private var _dict:Dictionary;
		public function Exchange_GetBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Exchange_GetBasicManager
		{
			if(_instance==null)_instance=new Exchange_GetBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var exchange_GetBasicVo:Exchange_GetBasicVo;
			for (var id:String in jsonData)
			{
				exchange_GetBasicVo=new Exchange_GetBasicVo();
				exchange_GetBasicVo.item_num=jsonData[id].item_num;
				exchange_GetBasicVo.item_id=jsonData[id].item_id;
				exchange_GetBasicVo.group_id=jsonData[id].group_id;
				exchange_GetBasicVo.item_type=jsonData[id].item_type;
				if(!_dict[exchange_GetBasicVo.group_id])
				{
					_dict[exchange_GetBasicVo.group_id]=new Vector.<Exchange_GetBasicVo>;
				}
				_dict[exchange_GetBasicVo.group_id].push(exchange_GetBasicVo);
			}
		}
		public function getExchange_GetBasicVo(group_id:int):Vector.<Exchange_GetBasicVo>
		{
			return _dict[group_id];
		}
	}
}