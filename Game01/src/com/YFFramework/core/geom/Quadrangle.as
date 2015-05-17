package com.YFFramework.core.geom
{
	import flash.geom.Point;

	/**
	 * author :夜枫 * 时间 ：2011-9-24 下午12:51:20
	 * 
	 * 四边形
	 */
	public class Quadrangle extends Object
	{
		public function Quadrangle()
		{
			super();
		}
		
		
		/**vect数组必须是以轴点为数组第一个元素，逆时针旋转四边形的点 来进行保存 的数组  轴点所相关的两条边是四边形的上面两条边<这个是判断是否为轴点的关键>
		 *   该方法用于深度排序  用于人物和建筑物之间的遮挡
		 * _x _y   是要测试的点的 x y 坐标
		 * 返回的是方向值 QuadrangleSide
		 */
		public static  function contain(vect:Vector.<Point>,_x:Number,_y:Number):int
		{
			var A:Point=vect[0];
			var B:Point=vect[1];
			var C:Point=vect[2];
			var D:Point=vect[3];
			var side:int;
			////创建四条直线 
			var line1:Number=_y+(A.x-_x)*(A.y-B.y)/(A.x-B.x)-A.y;
			var line4:Number=_y+(A.x-_x)*(A.y-D.y)/(A.x-D.x)-A.y;
			var line2:Number=_y+(C.x-_x)*(C.y-B.y)/(C.x-B.x)-C.y;
			var line3:Number=_y+(C.x-_x)*(C.y-D.y)/(C.x-D.x)-C.y;
			if((line1>=0)&&(line4>=0)&&(line3<=0)&&(line2<=0)) side=QuadrangleSide.Inner;
			else if((line1<=0)&&(line3<=0)) side=QuadrangleSide.LeftTop;   ///   line1<0 line3<0      LT 方向
			else if((line2<=0)&&(line4<=0)) side=QuadrangleSide.RightTop;   ///line2<0 line4<0 		  RT方向
			else if((line2>=0)&&(line4>=0)) side=QuadrangleSide.LeftBottom;  //line2>0 line4>0 	  LB方向
			else if((line1>=0)&&(line3>=0)) side=QuadrangleSide.RightBottom;  ///line1>0 line3>0	  RB方向
			else throw new Error("算法有bug");
			return side;
		}
	}
}