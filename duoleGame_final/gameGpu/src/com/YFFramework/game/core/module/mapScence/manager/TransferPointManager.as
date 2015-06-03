package com.YFFramework.game.core.module.mapScence.manager
{
	import flash.geom.Point;

	/**地图跳转 传送阵的位置 用于记录坐标   给副本 人物 自动寻路走到下一层使用  因为 副本传送阵是没有配 坐标的
	 * @author yefeng
	 * 2014 2014-1-10 下午3:49:28 
	 */
	public class TransferPointManager
	{
		private static var _instance:TransferPointManager;
		/**传送点坐标位置
		 */
		private var _pointArr:Array;
		
		/**玩家是否已经自动移动走向 传送阵
		 */
		public var autoMove:Boolean;
		public function TransferPointManager()
		{
		}
		public static function get Instance():TransferPointManager
		{
			if(_instance==null)
			{
				_instance=new TransferPointManager(); 
			}
			return _instance; 
		}  
		/**存放坐标
		 * 
		 */
		public  function put(x:int,y:int):void
		{
			_pointArr.push(new Point(x,y));
		}
		/**获取一个传送阵的坐标
		 */
		public  function getPoint():Point
		{
			if(_pointArr.length>0)
			{
				return _pointArr[0];
			}
			return null;
		}
		public function clear():void
		{
			_pointArr=[];
			autoMove=false;
		}
			
	}
}