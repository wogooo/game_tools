package com.YFFramework.core.geom
{
	import com.YFFramework.core.utils.math.GraphicAlgorithm;
	import flash.geom.Point;

	/**
	 * author :夜枫 * 时间 ：2011-9-23 下午03:01:59
	 * 平行四边形 类似于Rectangle
	 * 
	 *  initData 和setLen方法都可以进行初始化
	 */
	public final class Parallel extends Quadrangle
	{
		public var cornerPointArr:Vector.<Point>=null;
		/**平行四边形的斜率
		 */		
		private var k1:Number; 
		private var k2:Number;
		private var point:Point;///保存的是数组中第一个点的索引
		private var oppsitePoint:Point;///保存的是数组中第三个点的索引
		private var pivotPoint:Point;//保存的是刚开始画的第一个点 也就是开始点 简称轴点
		public function Parallel()
		{
			super();
		}
		/**
		 * @param point   平行四边形中的一点
		 * @param oppsitePoint  point的对角点 
		 * @param k1 k2 平行四边形的两条边的斜率
		 */
		public function initData(pivotPoint:Point,oppsitePoint:Point,k1:Number=0.5,k2:Number=-0.5):void
		{
			this.k1=k1;
			this.k2=k2;
			this.pivotPoint=pivotPoint;
			cornerPointArr=GraphicAlgorithm.parallelPoint(pivotPoint,oppsitePoint,k1,k2);
			cornerPointArr=sortPointArr(cornerPointArr);
			this.point=cornerPointArr[0];
			this.oppsitePoint=cornerPointArr[2];
		}
		public function contains(_x:Number,_y:Number):Boolean
		{
			if(!cornerPointArr) return false;
			var pk:Number;///斜率为正 或者 为 NaN  斜率不存在
			var nk:Number;///斜率为  负或者为0
			var isContain:Boolean=false;
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
				////这里注意flash的坐标系 Y轴式向下的
				var line1:Number=_y+pk*point.x-point.y-pk*_x;///直线 1     >0
				var line4:Number=_y+nk*point.x-point.y-nk*_x;//直线4       >0
				var line3:Number=_y+pk*oppsitePoint.x-oppsitePoint.y-pk*_x;//直线3  <0
				var line2:Number=_y+nk*oppsitePoint.x-oppsitePoint.y-nk*_x;//直线2 <0
				if((line1>=0)&&(line4>=0)&&(line3<=0)&&(line2<=0)) isContain=true;
				else isContain=false;
			}
			else ////斜率不存在
			{
				////斜率不存在时为矩形  
				var difX_1:Number=_x-point.x;
				var difX_2:Number=_x-oppsitePoint.x;
				var difY_1:Number=_y-point.y;
				var difY_2:Number=_y-oppsitePoint.y;
				if((difX_1*difX_2<=0)&&(difY_1*difY_2<=0))  isContain=true;
				else isContain=false;
			}
			return isContain;
		}
		private  function sortPointArr(vect:Vector.<Point>):Vector.<Point>
		{
			var len:int=vect.length;
			var minPoint:Point=vect[0];
			for(var i:int=1;i!=len;++i)
			{
				if(vect[i].y<minPoint.y) minPoint=vect[i];
			}
			var index:int=vect.indexOf(minPoint);
			var newArr:Vector.<Point>=vect.slice(index);
			var arr:Vector.<Point>=vect.slice(0,index);
			newArr=newArr.concat(arr);  ///逆时针  ，第一个是在最顶上 
			if(newArr[1].x>newArr[3].x)
			{
				var tmpPoint:Point=newArr[1];
				newArr[1]=newArr[3];
				newArr[3]=tmpPoint;
			}
			return newArr;
		}
		public function get width():Number
		{
			if(!cornerPointArr) return NaN;
			return Math.abs(cornerPointArr[1].x-cornerPointArr[3].x);
		}
		public function get height():Number
		{
			if(!cornerPointArr) return NaN;
			return Math.abs(cornerPointArr[0].y-cornerPointArr[2].y);
		}
		public function get xLen():Number
		{
			if(!cornerPointArr) return NaN;
			var len:int=Point.distance(cornerPointArr[0],cornerPointArr[1]);
			var index:int=cornerPointArr.indexOf(pivotPoint);
			if((index==0)||(index==3)) 	return len;
			else return -len;
		}
		public function get yLen():Number
		{
			if(!cornerPointArr) return NaN;
			var len:int= Point.distance(cornerPointArr[0],cornerPointArr[3]);
			var index:int=cornerPointArr.indexOf(pivotPoint);
			if((index==0)||(index==1))return len;
			else return -len;
		}
		/**value  的正负数 表示方向  正数表示   向下拉  对角点 比 轴点的y值大
		 */		
		public function setLen(xLen:int,yLen:int,k1:Number,k2:Number,pivotPoint:Point):Point
		{
			this.pivotPoint=pivotPoint;
			this.k1=k1;
			this.k2=k2;
			var pk:Number;///斜率为正 或者 为 NaN  斜率不存在
			var nk:Number;///斜率为  负或者为0
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
			var desPoint:Point=GraphicAlgorithm.getPointByLen(nk,pivotPoint,xLen);
			var oppsite:Point=GraphicAlgorithm.getPointByLen(pk,desPoint,yLen);
			initData(pivotPoint,oppsite,k1,k2);
			return oppsite;
		}
	}
}