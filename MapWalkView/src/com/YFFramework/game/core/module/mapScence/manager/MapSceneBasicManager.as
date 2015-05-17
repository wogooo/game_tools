package com.YFFramework.game.core.module.mapScence.manager
{
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.world.model.MapSceneBasicVo;
	
	import flash.utils.Dictionary;

	/**缓存游戏所有的地图数据表  mapScene表
	 * @author yefeng
	 *2012-4-27下午10:07:37
	 */
	public class MapSceneBasicManager
	{
		
		
		private var _dict:Dictionary;
		private static var _instance:MapSceneBasicManager;
		/**  缓存  静态数据   BgmapVo类型的数据
		 */		
		public function MapSceneBasicManager()
		{
			_dict=new Dictionary();
		}
		
		public static function get Instance():MapSceneBasicManager
		{
			if(_instance==null) _instance=new MapSceneBasicManager();
			return _instance;
		}
		public function cacheData(obj:Object):void
		{
			var mapSceneBasicVo:MapSceneBasicVo;
			var soundArr:Array;
			var url:String;
			for(var id:String in obj)
			{
				mapSceneBasicVo=new MapSceneBasicVo();
				mapSceneBasicVo.mapId=obj[id].mapId;
				mapSceneBasicVo.width=obj[id].width;
				mapSceneBasicVo.height=obj[id].height;
				mapSceneBasicVo.resId=obj[id].resId;
				soundArr=[];
				///缓存音乐
				for each(var soundId:int in obj[id].soundArr)
				{
					url=URLTool.getBgMusic(soundId);
					soundArr.push(url);
				}
				mapSceneBasicVo.soundArr=soundArr;
				_dict[mapSceneBasicVo.mapId]=mapSceneBasicVo;
			}
		}
		
		public function getMapSceneBasicVo(mapId:int):MapSceneBasicVo
		{
			return _dict[mapId];
		}
		
		
	}
}