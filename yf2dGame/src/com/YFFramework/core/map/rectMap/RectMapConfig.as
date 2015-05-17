package com.YFFramework.core.map.rectMap
{
	/**
	 * 存储地图的基本信息  tileWidth  tileHeight    w   h   
	 * 
	 * @author yefeng
	 *2012-6-5下午12:22:15
	 */
	public class RectMapConfig
	{
		public static var tileW:int;
		public static var tileH:int;
		/**  网格宽高 是经过处理后了的网格宽高   不一定是地图的大小
		 */		
		public static var gridW:int;
		public static var gridH:int;
		
		public static var mapW:int;
		public static var mapH:int;

		
		public static var rows:int;
		
		public static var columns:int;
		
		public function RectMapConfig()
		{
		}
		
		/**得到网格总数
		 */
		public static function  get Len():int
		{
			return rows*columns;
		}
	}
}