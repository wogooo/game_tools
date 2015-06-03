package com.YFFramework.core.geom
{
	/**
	 * author :夜枫 * 时间 ：2011-9-24 下午12:59:14
	 * 
	 * 四边形 <平行四边形 正方形  棱形 >  的应用常量  
	 */
	public final class QuadrangleSide
	{
		
		////以 地图编辑器的棱形单元块为基准进行参考  点的顺序是以轴的顺序 即最上面的那个点为轴点,逆时针保存四边形的点
		public static const Inner:int=0;///表示点在 四边形的内部
		public static const LeftBottom:int=2;//表示点在四边形的左下方
		public static const RightBottom:int=3;//表示在四边形的右下方
		public static const LeftTop:int=1;// 表示在四边形的左上方
		public static const RightTop:int=4;//表示在四边形的右上方
		public function QuadrangleSide()
		{
		}
	}
}