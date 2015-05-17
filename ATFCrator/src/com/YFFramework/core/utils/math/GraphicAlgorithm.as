/*
 * 平面几何算法 ！主要是涉及到直线方程 求点的坐标
 * 正放的矩形  也就是两边分别与X轴和Y轴偏平行的矩形  
 * 工具类 主要是用来求点的
 * 用法  ：
 * import com.kboy.math.*
var pointA:Point= new Point(0,400)
var pointB:Point= new Point(400,400)
var pointC:Point= new Point(200,300)
var pointD:Point= new Point(500,400)
var pointE:Point= new Point(600,500)

var p1:Point=GraphicAlgorithm.intersectPoint(pointA,pointB,pointC,pointD,pointE);

var p2:Point=GraphicAlgorithm.symmetricPoint(pointE,pointD,pointC)

var p3:Point=GraphicAlgorithm.linesInterset(pointE,pointB,pointC,pointD);
trace(p1+"\n");
trace(p2+"\n");
trace(p3+"\n");
 * 
 * */
package com.YFFramework.core.utils.math
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class GraphicAlgorithm
	{
		/* 求交点   ： GB 是矩形边，A是B的对称点，C是AB的垂直平分线与GB直线的交点  HE也是矩形边 ，F是E的对称点  ，D 是AB的
		 *   垂直平分线与矩形边HE的交点
		
		 HE 是垂直平分线CD缩相交的直线
		 当 GB 直线和HE直线式同一条时 则是C点 否则为D点
		 
		 为C点  即:   G==H   B==E
		 
		*/
		// 求点C  或者点D
		public static function intersectPoint(G:Point, B:Point, A:Point,H:Point,E:Point):Point
		{
			//HE直线方程
			var k0:Number = (H.y - E.y) / (H.x - E.x);
			//AB的垂直平分线CD的直线方程     
			var dif:Number = A.y - B.y;
			var k:Number;
			//AB中点
			var center:Point  = new Point((A.x+B.x)*0.5,(A.y+B.y)*0.5);
			var intersectX:Number;
			var intersectY:Number;
			if (dif != 0)
			{
				//斜率
				k = -(A.x - B.x) / dif;
				intersectX=(center.y-k*center.x+k0*H.x-H.y)/(k0-k);
				intersectY=(k0*k*(center.x-H.x)+(k*H.y-k0*center.y))/(k-k0);
			}
			else
			{
				intersectX=center.x;
				intersectY=k0*(center.x-E.x)+E.y;
			}
			return new Point(intersectX,intersectY);
		}
		//求对称点  已知AB垂直平分线CD 和另外一点E  则E关于CD的对称点F为:
		public static function symmetricPoint(C:Point, D:Point, E:Point):Point
		{
			///  C.y!=D.y 在书中这种情况不存在
			var difX:Number = C.x - D.x;//
			var difY:Number = C.y - D.y;// difY!=0 恒成立
			var k:Number;
			var k0:Number;
			var symmetricX:Number;
			var symmetricY:Number;
			if ((difX!=0)&&(difY!=0))
			{
				//  CD 斜率
				k = difY / difX;
				k0 = -1 / k;
				symmetricX=2*((D.y-k*D.x+k0*E.x-E.y)/(k0-k))-E.x;
				symmetricY = 2 * (D.y - k * D.x + k * (D.y - k * D.x + k0 * E.x - E.y) / (k0 - k)) - E.y;
			}
				//CD 直线斜率不存在的情况
			else if ((difX==0)&&(difY!=0))
			{
				symmetricX = 2*D.x-E.x;
				symmetricY = E.y;
			}
			return new Point(symmetricX,symmetricY);
		}
		//两个直线的交点 直线AB 与直线CD的交点
		public static function linesInterset(A:Point,B:Point,C:Point,D:Point):Point
		{
			var k0:Number;
			var k:Number;
			var intersectX:Number;
			var intersectY:Number;
			var difX0:Number = A.x - B.x;
			var difX:Number = C.x - D.x;
			//斜率都不为0的情况
			if ((difX0!=0)&&(difX!=0))
			{
				k0= (A.y - B.y) / difX0;
	
				k = (C.y - D.y) / difX;
				intersectX= (D.y - k * D.x + k0 * B.x - B.y) / (k0 - k);
				intersectY = D.y - k * D.x + k * (D.y - k * D.x + k0 * B.x - B.y) / (k0 - k);
			}
				// CD斜率不存在    ---------------------------书中用到
			else if ((difX0 != 0)&&(difX == 0))
			{
				k0= (A.y - B.y) / difX0;
				intersectX = C.x;
				intersectY=k0*(C.x-A.x)+A.y;
			}
				//AB斜率不存在
			 else if ((difX0==0)&&(difX!=0))
			{
				k = (C.y - D.y) / difX;
				intersectX = A.x;
				intersectY=k*(A.x-C.x)+C.y;
			}
			//两个的斜率 都不存在   -----------------------------书中用到
			 else if ((difX0==0)&&(difX==0))
			{
			intersectX = NaN;
			intersectY =NaN;
			}//不存在的情况
			return new Point(intersectX,intersectY);
		}
		/** 得到平行四边形的四个点
		 * 已知平行四边形的两对角点point oppsitePoint  以及该平行四边形的斜率  k1 k2 <k1 k2的顺序可以随便写 >求 另外两点  
		 * 最终返回的是 该四点的数组   顺序是  以point为0索引 ，以逆时针方向来保存的点的数组
		 *  最终得到的两个求得的点在索引 在 1,3 位置
		 */
		public static function parallelPoint(point:Point,oppsitePoint:Point,k1:Number,k2:Number):Vector.<Point>
		{
		//	intPoint(point);
		//	intPoint(oppsitePoint);
			var pk:Number;///斜率为正 或者 为 NaN  斜率不存在
			var nk:Number;///斜率为  负或者为0
			var point2:Point=new Point();
			var point4:Point=new Point();
			if((k1>0)||(k1.toString()=="NaN"))
			{
				pk=k1;
				nk=k2;
			}
			else if(k1<=0)
			{
				pk=k2;
				nk=k1;
			}
			if(pk)
			{
				point2.x=(pk*point.x-nk*oppsitePoint.x+oppsitePoint.y-point.y)/(pk-nk);
				point2.y=(pk*nk*(point.x-oppsitePoint.x)+pk*oppsitePoint.y-nk*point.y)/(pk-nk);
				point4.x=(pk*oppsitePoint.x-nk*point.x+point.y-oppsitePoint.y)/(pk-nk);
				point4.y=(pk*nk*(oppsitePoint.x-point.x)+pk*point.y-nk*oppsitePoint.y)/(pk-nk);
			}
			else ////斜率不存在
			{
				point2.x=point.x;
				point2.y=oppsitePoint.y;
				point4.x=oppsitePoint.x;
				point4.y=point.y;
			}
		//	intPoint(point2);
		//	intPoint(point4);
			var vect:Vector.<Point>=new Vector.<Point>();
			vect.push(point,point2,oppsitePoint,point4);
			return vect;
		}
		
		/**  已知直线方程 和该直线上的一点A   求距离A长度为len的点 B   ,  len 的值 可以为正 也可以为负   len= B.y-A.y 目标点的y坐标- A点的y坐标
		 * k==0  时  len 为   len==B.x-A.x  ,,len的值可以为正  也可以为负
		 * k== NaN 表示斜率不存在
		 */		
		public static function getPointByLen(k:Number,A:Point,len:Number):Point
		{
		//	intPoint(A);
			var B:Point=new Point();
			if((k.toString()!=="NaN")&&(k!=0))
			{
			 	var sign:int=getSign(k);
				var sin:Number=Math.abs(k/Math.sqrt(Math.pow(k,2)+1));
				var cos:Number=1/Math.sqrt(Math.pow(k,2)+1);
				var disW:Number=len*cos;
				var disH:Number=len*sin;
				B.x=A.x+len*cos*sign;
				B.y=A.y+len*sin;
			}
			else if(k==0)
			{
				B.x=A.x+len;
				B.y=A.y;
			}
			else 
			{
				B.x=A.x;
				B.y=A.y+len;
			}
		//	intPoint(B);
			return B;
		}
		
		public static function  getSign(value:Number):int
		{
			return value/Math.abs(value);  
		}
		/** 将point的值转化为整数
		 */		
		public static function intPoint(pt:Point):void
		{
			pt.x=int(pt.x);
			pt.y=int(pt.y);
		}
	}
}
