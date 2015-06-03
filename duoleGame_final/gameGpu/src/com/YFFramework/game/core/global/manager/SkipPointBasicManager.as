package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.SkipPointBasicVo;
	
	import flash.utils.Dictionary;
	/** 地图跳转点信息缓存
	 */
	public class SkipPointBasicManager
	{
		private static var _instance:SkipPointBasicManager;
		private var _dict:Dictionary;
		public function SkipPointBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():SkipPointBasicManager
		{
			if(_instance==null)_instance=new SkipPointBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var skipPointBasicVo:SkipPointBasicVo;
			var itemDict:Array;
			for (var id:String in jsonData)
			{
				skipPointBasicVo=new SkipPointBasicVo();
				skipPointBasicVo.id=jsonData[id].id;
				skipPointBasicVo.left=jsonData[id].left;
				skipPointBasicVo.top=jsonData[id].top;
				skipPointBasicVo.bottom=jsonData[id].bottom;
				skipPointBasicVo.otherMapX=jsonData[id].otherMapX;
				skipPointBasicVo.mapId=jsonData[id].mapId;
				skipPointBasicVo.right=jsonData[id].right;
				skipPointBasicVo.otherMapId=jsonData[id].otherMapId;
				skipPointBasicVo.otherMapY=jsonData[id].otherMapY;
				if(!_dict[skipPointBasicVo.mapId])
				{
					_dict[skipPointBasicVo.mapId]=[];
				}
				itemDict=_dict[skipPointBasicVo.mapId];
				itemDict.push(skipPointBasicVo);
			}
		}
		/** 获取地图跳转点信息
		 */		
		public function getSkipPointVo(mapId:int,otherMapId:int):SkipPointBasicVo
		{
			var itemDict:Array=_dict[mapId];
			for each(var skipPointVo:SkipPointBasicVo in itemDict )
			{
				if(skipPointVo.otherMapId==otherMapId) return skipPointVo;
			}
			return null;
		}
		
		/** 获取下一张跳转的地图 
		 */
		public function getOtherMapId(currentMapId:int,heroMapX:int,heroMapY:int):int
		{
			var mapArr:Array=_dict[currentMapId];
			for each(var skipPointBasicVo:SkipPointBasicVo in mapArr)
			{
				if(heroMapX>=skipPointBasicVo.left&&heroMapX<=skipPointBasicVo.right&&heroMapY>=skipPointBasicVo.top&&heroMapY<=skipPointBasicVo.bottom)
				{
					return skipPointBasicVo.otherMapId;
				}
			}
			return -1;
		}  
		
		
		
	
	}
	
}