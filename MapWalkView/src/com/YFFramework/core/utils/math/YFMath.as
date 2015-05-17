package com.YFFramework.core.utils.math
{
	import flash.geom.Point;

	/**@author yefeng
	 *2012-8-25下午10:39:52
	 */
	public class YFMath
	{
		public function YFMath()
		{
		}
		
		/**四舍五入保留一位小数
		 */		
		public static  function OneDot(value:Number):Number
		{
			return Number(int((value+0.05)*10)/10);
		}

				/**四舍五入保留两位小数
		 */		
		public static  function TwoDot(value:Number):Number
		{
			return Number(int((value+0.05)*100)/100);
		}

		public static function Round(value:Number):int
		{
			return int(value+0.5);
		}
		
		public static function radToDegree(rad:Number):Number
		{
			return rad*180/Math.PI;	
		}
		public static function degreeToRad(degree:Number):Number
		{
			return degree*Math.PI/180;
		}
		
		public static function distance(startX:Number,startY:Number,endX:Number,endY:Number):Number
		{
			return Math.sqrt(Math.pow(startX-endX,2)+Math.pow(startY-endY,2));
		}
		
		/** 根据两点  startPoint  endPoint 来 获得  线上距离 endPoint长度为lenToEnd 的点 注意 该点在 starPoint 和endPoint中间
		 * @param startX  starY 开始点
		 * @param endX endY  结束点 
		 * @param lenToEnd
		 * @return 
		 * 
		 */		
		public static function getLinePoint(startX:Number,startY:Number,endX:Number,endY:Number,lenToEnd:int):Point
		{
			////使用  定比分点公式 
			var distance:Number=YFMath.distance(startX,startY,endX,endY);
			var  lama:Number=(distance-lenToEnd)/lenToEnd;  ////定比分点参数
			var pt:Point=new Point();
			pt.x=(startX+lama*endX)/(1+lama);
			pt.y=(startY+lama*endY)/(1+lama);
			return pt;
		}
		/** 根据两点  startPoint  endPoint 来 获得  线上距离 startPoint长度为lenToStart 的点 注意 该点在 starPoint 和endPoint中间
		 * @param startX  starY 开始点
		 * @param endX endY  结束点 
		 * @param lenToEnd
		 * @return 
		 */		
		public static function getLinePoint2(startX:Number,startY:Number,endX:Number,endY:Number,lenToStart:int):Point
		{
			////使用  定比分点公式 
			var distance:Number=YFMath.distance(startX,startY,endX,endY);
			var  lama:Number=lenToStart/(distance-lenToStart);  ////定比分点参数
			var pt:Point=new Point();
			pt.x=(startX+lama*endX)/(1+lama);
			pt.y=(startY+lama*endY)/(1+lama);
			return pt;
		}
		
		/**
		 * @param pivotX   射线起点
		 * @param pivotY  射线起点
		 * @param len	  长度
		 * @param degree	直线的角度    flash 坐标下的角度
		 * @return 距离pivotX pivotY 长度 len 在直线 degree上的点  得到的是反方向上的点  宠物位置算法
		 * 
		 */		
		public static function getLinePoint3(pivotX:Number,pivotY:Number,len:int,degree:int):Point
		{
			var rad:Number=degreeToRad(degree+180);
			var x:int=pivotX+len*Math.cos(rad);
			var y:int=pivotY+len*Math.sin(rad);
			return new Point(x,y);
		}
		
		/**
		 * @param pivotX   射线起点
		 * @param pivotY  射线起点
		 * @param len	  长度
		 * @param degree	直线的角度    flash 坐标下的角度
		 * @return 距离pivotX pivotY 长度 len 在直线 degree上的点  
		 */		

		public static function getLinePoint4(pivotX:Number,pivotY:Number,len:int,degree:int):Point
		{
			var rad:Number=degreeToRad(degree);
			var x:int=pivotX+len*Math.cos(rad);
			var y:int=pivotY+len*Math.sin(rad);
			return new Point(x,y);
		}
		/**得到角度  flash 的角度    flash角度 rotation     注意 起始点方向要和 X轴 正方向一致 要是反方向的话需要加上 180
		 * @param startX
		 * @param startY
		 * @param endX
		 * @param endY
		 * @return 
		 */		
		public static function getDegree(startX:int,startY:int,endX:int,endY:int):Number
		{
			var k:Number=(endY-startY+0.0001)/(endX-startX+0.0001)
			var rad:Number=Math.atan(k);
			if (startX>endX)
			{
				rad +=  Math.PI;
			}
			var myRotate:Number=radToDegree(rad);
			return myRotate;
		}
		
		
		
		
		
		
	}
}