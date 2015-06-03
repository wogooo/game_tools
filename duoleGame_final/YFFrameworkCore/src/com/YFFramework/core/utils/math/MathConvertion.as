package com.YFFramework.core.utils.math
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author dreamnight
	 * 
	 * 
	 * 用于角度转化
	 * 
	 * 
	 * 			import com.kboy.math.MathConvertion

				var a:Number=MathConvertion.radianToDegree(Math.PI/3)
				var b:Number=MathConvertion.degreeToRadian(30)
 
				trace("degree:"+a);
				trace("radian:"+b)
	 * 
	 * 
	 * 
	 */
	public class MathConvertion
	{
		
	
		
		
		public static function degreeToRadian(degree:Number):Number
		{
			return Math.PI * degree / 180;
		}
		
		
			
			
			
		public static function radianToDegree(radian:Number):Number
		{
					return  radian * 180 / Math.PI;
		}
			
			
		public static function distance(p1:Point,p2:Point):Number 
		{
			return Math.sqrt(Math.pow((p1.x-p2.x),2)+Math.pow((p1.y-p2.y),2));
		}
				
		public static function ease(target:Number,current:Number,speed:Number):Number
		{
			var dis:Number=target-current;
			current+=dis*speed;
			return  current;
		}
		public static function scale(display:DisplayObject,_w:Number,_h:Number):void 
		{
			display.scaleX = _w / display.width ;
			display.scaleY = _h/display.height ;
		}
					
		
					
					/*
					
					
					用法  ：
					import utils.math.MathConvertion

var obj:Object;
var arr:Array=[];

for(var i:int=0;i<4;++i){
	obj=new Object();
obj.index=i;
obj.name=String(i);
arr.push(obj);
}
//
var max:Object=MathConvertion.Max(arr,"index");

var min:Object=MathConvertion.Min(arr,"index");

trace(arr[3]["index"]);

trace("max:"+max.name);


trace("min:"+min.name);
					
					
					
					
					*/
					
					//比对 property 属性的大小
		public static function Max(arr:Array,_property:Object):Object
		{
				//var len:int = arr.length;
				//var target:Object = arr[0];
			//这里使用数组的内置排序 降序
			arr.sortOn(_property, Array.DESCENDING | Array.NUMERIC);
			var max:Object = arr[0];
			return max;
		}
		public static function Min(arr:Array,_property:Object):Object 
		{
			//这里使用数组的内置排序 升序
			arr.sortOn(_property,Array.NUMERIC);
			var min:Object = arr[0];
			return min;
		}
		/**
		 * 得到小数的上限值 比如 4.3 的上限为5   -3.3的上限为-3
		 */
		public static function  uppper(key:Number):int 
		{
			var key_int:int = Math.floor(key);
			var decimal:Number = key - key_int;
			///var value:int;
			/**
			 * 当key为小数   则+！
			 */
			if (key > key_int) 
			{
				key_int = key_int + 1;
			}
			return key_int;
		}
				
				
				
		
		/**
		 * 将三维坐标点 映射成该位置的二维坐标点   XY平面
		 *   同一坐标系啊 三维坐标 映射成二维坐标  联想到  scaleX=width/(width+1)的转化算法
		 * 
		 * 计算公式:
		 * 
		 * 
		 * 已知一个点(x，y，z)，利用三角形相似的原理，可以得出下列结论：

	d/(d+z)=y1/y，推出：y1=d*y/(d+z)，可在二维平面上来表现空间上的点的位置。进一步把它简化。提出因子d/(d+z)，用ratio(比率)表示，这个公式就变为

	ratio=d/(d+z);

	y1=ratio*y;同理可推出   ///这里的  d  指的是相对应的 3维量  比如 算2维 x时  d就是 3维的x
	

		x1=ratio*x;

		
		公式：
		
		 x_2D=(X_3D/(X_3D+Z))*X_3D;
		 y_2D=(Y_3D/(Y_3D+z))*y_3D
		 width_2D=(width/width+z)*width   /// width  geight 指的是3维的
		 height_2D=(height/height+z)*height

		 *  
		 * 
		 * @param	vec
		 * @return
		 */
			public static function $3DTo2D(vec:Vector3D,vanishPoint:Point):Point
			{
				
				var nowX:Number=vanishPoint.x
				var _x:Number = Math.round(vec.x * vec.x / (vec.x + vec.z));
				var _y:Number = Math.round(vec.y * vec.y / (vec.y + vec.z));
				return new Point(_x,_y);
			}	
			/**
			 * 将三维下的长度  映射成二维先的长度  XY平面
			 * @param	len
			 * @param	_z  指的是该显示对象的注册点的 Z坐标
			 */
			public static function $3DLenTo2D(len:Number, _z:Number):Number
			{
				var myLen:Number = len * len / (len + _z);
				return myLen;
			}
			/**
			 * 得到旋转后的点的坐标
			 * 
			 * pt 是要旋转的点 
			 * rotation 保存了  rotation X  Y Z的值   也就是 要旋转的角度   值是  角度
			 * 
			 * 返回的是 旋转后 的坐标
			 * 
			 * 
			 * 公式  ：  A是旋转点 也就是注册点      C是 绕这点旋转的点     W  是他们间的宽(W=Cx-Ax)   H是他们间的高(Cy-Ay)
			 * 
			 * rotationx X:
			 * Cy=Ay+H*cosrotationX    Cz=Az+H*sinrotationX
			 * 
			 * rotationY 
			 * Cx=Ax+W*cosrotationY  Cz=Az-W*sinrotationY
			 * 
			 * rotationZ:
			 * Cx=Ax+W*cosZ-H*sinZ
			 * Cy=Ay+H*cosZ+W*sinZ
			 * 
			 * 总公式
			 *  rotationX   rotationY  rotationZ   --- X  Y  z  
			 * 
			 * Cx=Ay+W*cosZ-H*sinZ+W*cosY
			 * Cy=Ay+HcosZ+W*sinZ+H*cosX
			 * Cz=Az+H*sinX-W*sinY
			 * 
			 * 
			 * 
			 * pivotPoint是 旋转点 一般就是注册点   pt是绕该点旋转的点   rotation是旋转角度 保存  X Y Z的旋转    单位是 角度
			 * 
			 */
			
			public static  function getRotatedPoint(pivotPoint:Vector3D,pt:Vector3D,rotation:Vector3D):Vector3D 
			{
				/**
				 * 弧度角度形式的旋转角度
				 */
				var RX:Number = MathConvertion.degreeToRadian(rotation.x);
				var RY:Number = MathConvertion.degreeToRadian(rotation.y);
				var RZ:Number = MathConvertion.degreeToRadian(rotation.z);
				var matrix:Matrix3D = new Matrix3D();
				matrix.position = pt;
				matrix.appendRotation(rotation.x, Vector3D.X_AXIS, pivotPoint);
				matrix.appendRotation(rotation.y, Vector3D.Y_AXIS, pivotPoint);
						matrix.appendRotation(rotation.z, Vector3D.Z_AXIS, pivotPoint);
				var point:Vector3D =  matrix.position;
				var  px:int = Math.round(point.x);
				var py:int = Math.round(point.y);
				var pz:int = Math.round(point.z);
				return new Vector3D(px,py,pz);
			}
	}

}