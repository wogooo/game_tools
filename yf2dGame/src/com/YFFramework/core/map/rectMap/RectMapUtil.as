package com.YFFramework.core.map.rectMap
{
	import flash.geom.Point;

	/**@author yefeng
	 *2012-6-5下午12:21:44  
	 * 
	 * 
	 * 算法地址 ：   http://blog.sina.com.cn/s/blog_66471b6e010170dg.html
	 */
	public class RectMapUtil
	{
		private static var _tileX:int;
		private static var _tileY:int;
		private static var _px:int;
		private static var _py:int;
		private static var _index:int;
		private static var _column:int;
		private static var _row:int;
		
		public function RectMapUtil()
		{
		}
		
		/**得到 px py 对应的tile坐标 
		 */
		public static function getTilePosition(px:int,py:int):Point
		{
//			var xtile:int = 0;        //网格的x坐标
//			var ytile:int = 0;        //网格的y坐标
//			var cx:int, cy:int, rx:int, ry:int;
//			cx = int(px / RectMapConfig.tileW) * RectMapConfig.tileW + RectMapConfig.tileW/2;        //计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标
//			cy = int(py / RectMapConfig.tileH) * RectMapConfig.tileH + RectMapConfig.tileH/2;//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
//			rx = (px - cx) * RectMapConfig.tileH/2;
//			ry = (py - cy) * RectMapConfig.tileW/2;
//			if (Math.abs(rx)+Math.abs(ry) <= RectMapConfig.tileW * RectMapConfig.tileH/4)
//			{
//				xtile = int(px / RectMapConfig.tileW);
//				ytile = int(py / RectMapConfig.tileH) * 2;
//			}
//			else
//			{
//				px = px - RectMapConfig.tileW/2;
//				xtile = int(px / RectMapConfig.tileW) + 1;
//				py = py - RectMapConfig.tileH/2;
//				ytile = int(py / RectMapConfig.tileH) * 2 + 1;
//			}
//			return new Point(xtile - (ytile&1), ytile);
		
			
			_tileX=int(px/RectMapConfig.tileW);
			_tileY=int(py/RectMapConfig.tileH);
			return new Point(_tileX,_tileY)

		}
		/**得到tileX tileY对应的 中心tile的flash坐标
		 */
		public static function getFlashCenterPosition(tileX:int,tileY:int):Point
		{
//			var tileCenter:int = (tileX * RectMapConfig.tileW) + RectMapConfig.tileW/2;
//			var xPixel:int = tileCenter + (tileY&1) * RectMapConfig.tileW/2;
//			var yPixel:int = (tileY + 1) * RectMapConfig.tileH/2;
//			return new Point(xPixel, yPixel);
			
			
			_px=tileX*RectMapConfig.tileW+RectMapConfig.tileW*0.5;
			_py=tileY*RectMapConfig.tileH+RectMapConfig.tileH*0.5;
			return new Point(_px,_py);

		}
		
		/**获取索引
		 */
		public static function getTileIndex(tileX:int,tileY:int):int
		{
			_index=tileY*RectMapConfig.columns+tileX;
			return _index;
		}
		
		/**根据索引 获取tile坐标
		 * 
		 */
		public static function getTilePostionByIndex(index:int):Point
		{
			_row=index/RectMapConfig.columns;
			_column=index-_row*RectMapConfig.columns;
			return new Point(_column,_row);
		}
		
	}
}