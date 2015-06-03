package com.YFFramework.game.core.global
{
	import com.YFFramework.game.core.global.model.RoleSelfVo;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	import com.YFFramework.game.core.module.mapScence.world.model.MapSceneBasicVo;

	/** 当前角色的数据中心数据中心 
	 * 
	 * @author yefeng
	 *2012-4-21上午12:05:05
	 */
	public class DataCenter
	{
		/**   地图最小高度
		 */		
		public static const SmallMapMinHeight:int=360;
		
		
		/**  当前角色玩家的信息
		 */
		public var roleSelfVo:RoleSelfVo;
		
		/**当前地图信息
		 */
		public var mapSceneBasicVo:MapSceneBasicVo;
		 
		/**前一场景的信息    副本切换 新手引导需要
		 */
		public var preMapSceneBasicVo:MapSceneBasicVo;
		
		/** 玩家登录口令  用于 聊天服务器
		 */		
		public var passPort:int;//
		
		/**刚刚登录
		 */
		public var nowLogin:Boolean=false;
		
		/**是否为新手
		 */
		public var isFresh:Boolean;
		
		private static var _instance:DataCenter;
		public function DataCenter()
		{
			roleSelfVo=new RoleSelfVo();
			isFresh=false;
		}
		public static function get Instance():DataCenter
		{
			if(!_instance) _instance=new DataCenter();
			return _instance;
		}
		
		/**获取地图id 
		 */		
		public function getMapId():int
		{
			if(mapSceneBasicVo) return mapSceneBasicVo.mapId;
			return -1;
		}
		/**  获取  地图尺寸
		 */		
		public function getSmallMapWidth(mapId:int):int
		{
			var mapBasicVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(mapId);
			var smallMapMinHeight:Number=getSmallMapMinHeight(mapId);
			var w:int=smallMapMinHeight*mapBasicVo.width/mapBasicVo.height;
			return w;
		}
		
		public static function getSmallMapMinHeight(mapId:int):Number
		{
			var mapBasicVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(mapId);
			var myHeight:Number=mapBasicVo.height*0.1;
			if(myHeight>SmallMapMinHeight)myHeight=SmallMapMinHeight;
			return myHeight
		}
		
		public function getMapScaleRatio(mapId:int):Number
		{
			var myHeight:int= getSmallMapMinHeight(mapId);
			return myHeight
		}
		
		
	}
}