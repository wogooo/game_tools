package com.YFFramework.game.core.global.manager
{
	
	import flash.utils.Dictionary;

	public class SearchRoadBasicManager
	{
		private static var _instance:SearchRoadBasicManager;
		private var _obj:Object;
		public function SearchRoadBasicManager()
		{
		}
		public static function get Instance():SearchRoadBasicManager
		{
			if(_instance==null)_instance=new SearchRoadBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			_obj=jsonData;
		}
		/**返回一个数组副本
		 */		
		public function getRoadArray(fromMapId:int,endMapId:int):Array
		{
			var arr:Array=_obj[fromMapId+"_"+endMapId];
			if(arr)return arr.concat();
			return null;
		}
	}
}