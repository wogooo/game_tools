package com.YFFramework.game.core.global
{
	import com.YFFramework.core.world.model.MapSceneBasicVo;
	import com.YFFramework.game.core.global.model.RoleSelfVo;

	/** 当前角色的数据中心数据中心 
	 * 
	 * @author yefeng
	 *2012-4-21上午12:05:05
	 */
	public class DataCenter
	{
			
		/**  当前角色玩家的信息
		 */
		public var roleSelfVo:RoleSelfVo;
		
		/**当前地图信息
		 */
		public var mapSceneBasicVo:MapSceneBasicVo;
		/**地图配置信息
		 */		
	//	public var xxObj:Object;
		
		private static var _instance:DataCenter;
		public function DataCenter()
		{
			initData();
		}
		public static function get Instance():DataCenter
		{
			if(!_instance) _instance=new DataCenter();
			return _instance;
		}
		private function initData():void
		{
			roleSelfVo=new RoleSelfVo();
		}
		
		/**获取地图id 
		 */		
		public function getMapId():int
		{
			if(mapSceneBasicVo) return mapSceneBasicVo.mapId;
			return 1;
		}
		
		
		
	}
}