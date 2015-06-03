package com.YFFramework.core.map.rectMap
{
	import flash.geom.Point;

	/**@author yefeng
	 *2012-6-5下午12:21:44
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
			_tileX=int(px/RectMapConfig.tileW);
			_tileY=int(py/RectMapConfig.tileH);
			return new Point(_tileX,_tileY)
		}
		/**得到tileX tileY对应的 中心tile的flash坐标
		 */
		public static function getFlashCenterPosition(tileX:int,tileY:int):Point
		{
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
		
		public static function getTilePostionByIndex2(index:int):Array
		{
			_row=index/RectMapConfig.columns;
			_column=index-_row*RectMapConfig.columns;
			return [_column,_row];
		}

		
	}
}