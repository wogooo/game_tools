package com.YFFramework.game.core.global.model
{
	/**地图跳转点 信息
	 * 2012-11-13 下午5:13:43
	 *@author yefeng
	 */
	public class SkipPointBasicVo
	{
		/**  唯一id 
		 */
		public var id:int;
		/**该跳转点的坐标X
		 */		
		public var mapX:int;
		/**该跳转点的坐标Y
		 */	
		public var mapY:int;
		/**当前地图id 
		 */
		public var mapId:int;
		/**当前地图 检测位置的左上角X坐标
		 */
		public var left:int;
		/**当前地图 检测位置的左上角Y坐标
		 */
		public var top:int;
		/**当前地图 检测位置的右下角x 坐标
		 */
		public var right:int;
		/**当前地图 检测位置的右下角y 坐标
		 */
		public var bottom:int;
		/** 要跳转到的地图id 
		 */
		public var 	otherMapId:int;
		/** 要跳转到的地图id 的坐标
		 */
		public var otherMapX:int;
		/** 要跳转到的地图id 的坐标
		 */
		public var otherMapY:int;
		public function SkipPointBasicVo()
		{
		}
	}
}