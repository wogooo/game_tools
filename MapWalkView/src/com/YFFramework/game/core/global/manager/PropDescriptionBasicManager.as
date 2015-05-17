package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.PropDescriptionBasicVo;
	
	import flash.utils.Dictionary;

	/**缓存装备属性 名称表述表 propDescription.json
	 */	
	public class PropDescriptionBasicManager
	{
		private static var _instance:PropDescriptionBasicManager;
		private var _dict:Dictionary;
		public function PropDescriptionBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():PropDescriptionBasicManager
		{
			if(_instance==null)_instance=new PropDescriptionBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var propDescriptionBasicVo:PropDescriptionBasicVo;
			for (var id:String in jsonData)
			{
				propDescriptionBasicVo=new PropDescriptionBasicVo();
				propDescriptionBasicVo.attrId=jsonData[id].attrId;
				propDescriptionBasicVo.description=jsonData[id].description;
				_dict[propDescriptionBasicVo.attrId]=propDescriptionBasicVo;
			}
		}
		public function getPropDescriptionBasicVo(attrId:int):PropDescriptionBasicVo
		{
			return _dict[attrId];
		}
		
		
	}
}