package com.YFFramework.game.core.module.mapScence.world.model
{
	/**  缓存 地图数据表  用于 BgMapView
	 * 背景地图 vo
	 * @author yefeng
	 *2012-4-25下午10:07:57
	 */
	public class MapSceneBasicVo
	{
		/**  背景地图id 
		 */
		public var mapId:int;
		/**资源id 
		 */
		public var resId:int;
		
		/** 图片宽
		 */		 
		public var width:int;
		
		/** 图片高
		 */
		public var height:int;
		/**  场景 类型 是否为安全期   TypeRole. MapScene_SafeArea   TypeRole. MapScene_Field   TypeRole.	MapScene_Raid
		 */
		public var type:int;
		
		/**保存音乐的url
		 */		
		public var soundArr:Array;
		/**地图名称
		 */		
		public var mapDes:String;
		/**世界地图描述
		 */		
		public var worldMapDescription:String;
		public function MapSceneBasicVo()
		{
		}
		
		
		
	}
}