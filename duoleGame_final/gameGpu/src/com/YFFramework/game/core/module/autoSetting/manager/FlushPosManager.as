package com.YFFramework.game.core.module.autoSetting.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.module.autoSetting.model.FlushPosVo;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-20 下午2:20:10
	 */
	public class FlushPosManager{
		
		private static var instance:FlushPosManager;
		private var _hashMap:HashMap = new HashMap();
		
		public function FlushPosManager(){
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			for(var id:String  in jsonData){
				var vo:FlushPosVo = new FlushPosVo();
				vo.flushId = jsonData[id].flush_id;
				vo.flushX = jsonData[id].flush_x;
				vo.flushY = jsonData[id].flush_y;
				vo.id = jsonData[id].id;
				vo.sceneId = jsonData[id].scene_id;
				vo.sceneType = jsonData[id].scene_type;
				
				_hashMap.put(vo.id,vo);
			}
		}
		
		/**通过地图id和地图类型获取一系列Flush的东西
		 * @param sceneId
		 * @param sceneType
		 * @return  
		 */		
		public function getFlushIds(sceneId:int,sceneType:int):Dictionary{
			var retDict:Dictionary = new Dictionary();
			var arr:Array = _hashMap.values();
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				if(arr[i].sceneId==sceneId && arr[i].sceneType==sceneType){
					retDict[arr[i].flushId] = arr[i].flushId;
				}
			}
			return retDict;
		}
		
		public static function get Instance():FlushPosManager{
			return instance ||= new FlushPosManager();
		}
	}
} 