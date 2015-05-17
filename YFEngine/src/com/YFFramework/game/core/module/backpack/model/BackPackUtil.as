package com.YFFramework.game.core.module.backpack.model
{
	import flash.geom.Point;

	/**@author yefeng
	 *2012-8-11下午10:46:22
	 */
	public class BackPackUtil
	{
		/**背包 的格子大小
		 */		
		public static const GridWidth:int=38;
		
		public static const GridHeight:int=38;
		/** 两个格子 之间的距离  水平 和垂直都是  一样
		 */		
		public static const GridSpace:int=0;	
		/**格子横向个数
		 */		
		public static const HorizontalNum:int=7;
		/**格子垂直个数
		 */
		public static const VerticalNum:int=6;
		
		
		/**最大页数 
		 */
		public static const MaxPage:int=4;
		
		/**每页的总格子数 
		 */
		public static const PageGridsNum:int=HorizontalNum*VerticalNum;
		
		
		
		////用于 BackpackMenuListView
		/**使用
		 */		
		public static const Use:int=1;
		/**展示
		 */		
		public static const Show:int=2;
		/**丢弃
		 */		
		public static const Drop:int=3;
		
		
		public function BackPackUtil()
		{
		}
		
		
		/**  根据坐标得到格子数   格子数 是从 1 开始
		 * @param px    所标在 窗口 内容中的位置  backpackContentView中的位置
		 * @param py
		 * @return 
		 */		
		public static  function  getGridNum(px:int,py:int):int
		{
			var currentColumn:int=px/(GridWidth+GridSpace);
			var currentRow:int=py/(GridHeight+GridSpace);
			var gridIndex:int=currentRow*HorizontalNum+currentColumn+1;///将 格子索引变成从 1 开始
			return gridIndex;
		}
		/**得到格子的左上角的坐标     gridNum  格子数是 从  1  开始的
		 */		 
		public static function getGridPosition(gridNum:int):Point
		{
			var column:int=(gridNum-1)%HorizontalNum;
			var row:int=int((gridNum-1)/HorizontalNum);
			var x:int=column*(GridWidth+GridSpace);
			var y:int=row*(GridHeight+GridSpace);
			return new Point(x,y);
		}
		
		/**得到所在页数
		 */		
		public static function getPage(gridNum:int):int
		{
			return int((gridNum-1)/PageGridsNum)+1;	
		}
		
		
	}
}