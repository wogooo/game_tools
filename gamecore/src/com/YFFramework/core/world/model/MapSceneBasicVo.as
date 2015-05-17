package com.YFFramework.core.world.model
{
	/**  缓存 地图数据表    mapScene表
	 * 用于 BgMap
	 * 背景地图 vo
	 * @author yefeng
	 *2012-4-25下午10:07:57
	 */
	public class MapSceneBasicVo
	{
		/**  背景地图id 
		 */
		public var id:int;
		/**资源id 
		 */
		public var resId:int;
		
		/** 图片宽
		 */		 
		public var width:int;
		
		/** 图片高
		 */
		public var height:int;
		public function MapSceneBasicVo()
		{
		}
	}
}