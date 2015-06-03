package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	
	import flash.utils.Dictionary;

	/**缓存 Buff.json表
	 */
	public class BuffBasicManager
	{
		private static var _instance:BuffBasicManager;
		private var _dict:Dictionary;
		public function BuffBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():BuffBasicManager
		{
			if(_instance==null)_instance=new BuffBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var buffBasicVo:BuffBasicVo;
			for (var id:String in jsonData)
			{
				buffBasicVo=new BuffBasicVo();
				buffBasicVo.attr_value2=jsonData[id].attr_value2;
				buffBasicVo.param1=jsonData[id].param1;
				buffBasicVo.attr_type1=jsonData[id].attr_type1;
				buffBasicVo.attr_type2=jsonData[id].attr_type2;
				buffBasicVo.client_show=jsonData[id].client_show;
				buffBasicVo.description=jsonData[id].description;
				buffBasicVo.icon_id=jsonData[id].icon_id;
				buffBasicVo.attr_type3=jsonData[id].attr_type3;
				buffBasicVo.keep_buff=jsonData[id].keep_buff;
				buffBasicVo.name=jsonData[id].name;
				buffBasicVo.buff_id=jsonData[id].buff_id;
				buffBasicVo.replace=jsonData[id].replace;
				buffBasicVo.attr_value3=jsonData[id].attr_value3;
				buffBasicVo.param2=jsonData[id].param2;
				buffBasicVo.attr_value1=jsonData[id].attr_value1;
				buffBasicVo.buff_state=jsonData[id].buff_state;
				buffBasicVo.effectmodeid=jsonData[id].effectmodeid;
				buffBasicVo.benefit=jsonData[id].benefit;
				buffBasicVo.buff_layer=jsonData[id].buff_layer;
				_dict[buffBasicVo.buff_id]=buffBasicVo;
			}
		}
		public function getBuffBasicVo(buff_id:int):BuffBasicVo
		{
			return _dict[buff_id];
		}
		
		public function getBuffIconURL(buffId:int):String
		{
			var buffBasicVo:BuffBasicVo=getBuffBasicVo(buffId);
			var url:String=URLTool.getBuffIcon(buffBasicVo.icon_id);
			return url;
		}
		
	}
}