package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.MountBasicVo;
	
	import flash.utils.Dictionary;

	/**缓存坐骑表mountProp.json
	 * 2012-10-26 下午12:00:40
	 *@author yefeng
	 */
	public class MountBasicManager
	{
		private static var _instance:MountBasicManager;
		private var _dict:Dictionary;
		public function MountBasicManager()
		{
			_dict=new Dictionary();
		}
		
		public static function get Instance():MountBasicManager
		{
			if(_instance==null) _instance=new MountBasicManager();
			return _instance;
		}
		
		public function cacheData(jsonData:Object):void
		{
			var mountBasicVo:MountBasicVo;
			for(var id:String  in jsonData)
			{
				mountBasicVo=new MountBasicVo();
				mountBasicVo.basicId=int(id);
				mountBasicVo.skinId=jsonData[id].skinId;
				mountBasicVo.quality=jsonData[id].quality;
				mountBasicVo.speed=jsonData[id].speed;
				_dict[mountBasicVo.basicId]=mountBasicVo;
			}
		}
		
		public function getMountBasicVo(basicId:int):MountBasicVo
		{
			return _dict[basicId];
		}
		
		
	}
}