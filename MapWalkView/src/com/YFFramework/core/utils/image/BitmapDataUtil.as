package com.YFFramework.core.utils.image
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import yf2d.utils.getTwoPower;

	/**  BitmapData 工具使用集合
	 *  @author yefeng
	 *   @time:2012-3-20下午02:49:29
	 */
	public class BitmapDataUtil
	{
		private static var bmd:BitmapData=new BitmapData(1,1,true,0xFFFFFF);
		private static var matrix:Matrix=new Matrix();
		private static var alphaValue:Number ;

		public function BitmapDataUtil()
		{
		}
		
		/** 判断  sp坐标下  px ,py 处 的点是否和 sp发生碰撞  当不透明也就是发生碰撞  
		 */
		public static function getInsect(sp:DisplayObject,px:int,py:int):Boolean
		{
			matrix.identity();
			bmd.fillRect(bmd.rect,0);
			matrix.tx=-px;
			matrix.ty=-py;
			bmd.draw(sp,matrix);
			alphaValue= bmd.getPixel32(0,0) >> 24 & 0xFF;
			if (alphaValue>0) {
				return true
			}
			return false;
		}
		
		
		
		/**得到bitmapData的非透明区域  也就是alpha值不为0的区域
		 */		
		public static function getMinRect(data:BitmapData):Rectangle
		{ //  0x00  的 透明值 也就是  alpha=0 这样我们是看不见对象的    返回 0xFF0000&color!=0x0000000  区域   返回的 color也就是我们要的不透明区域     0x000000表示是透明区域的最小值  0x00的alpha是透明的 不可见的
			return data.getColorBoundsRect(0xFF000000,0x00000000,false);  
		}
		
		
		/** 将图像转变为黑色
		 */
		public static function getBlackColorArr():Array
		{
			return [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0];
		}
		
		/**  得到图像灰度数组
		 */
		public static function getGrayColorArr():Array
		{
			return [0.5,0,0,0,0,0.5,0,0,0,0,0.5,0,0,0,0,0,0,0,1,0];
		}

		/**选取 target的  在   target  x  y 坐标的颜色值 
		 */
		public static function getColor(target:DisplayObject,x:int,y:int):uint
		{
			var bitmapData:BitmapData=new BitmapData(1,1,false,0xFFFFFF);
			var mat:Matrix=new Matrix();
			mat.tx=-x;
			mat.ty=-y;
			bitmapData.draw(target,mat);
			var color:uint=bitmapData.getPixel(0,0);
			return color;
		}
		
		/**获取有效的  bitmapData  返回的是带UV 的数据  [0,0,u,v]  data:bitmapData
		 * @param bitmapData
		 * @return 
		 * 
		 */		
		public static function   getValideBitmapData(bitmapData:BitmapData):Object
		{
			var obj:Object={};
			if(isDimensionValid(bitmapData.width)&&isDimensionValid(bitmapData.height))
			{
				obj={u:1,v:1,data:bitmapData};
			}
			else 
			{
				var copy:BitmapData=new BitmapData(getTwoPower(bitmapData.width),getTwoPower(bitmapData.height),true,0xFFFFFF);
				copy.draw(bitmapData);
				obj={u:bitmapData.width/copy.width,v:bitmapData.height/copy.height,data:copy};
				bitmapData.dispose();
				
			}
			return obj;
		}
		/**2 的次幂
		 * @param d
		 * @return 
		 * 
		 */		
		public static function isDimensionValid(d : uint) : Boolean
		{
			return d >= 1 && d <= 2048 && isPowerOfTwo(d);
		}
		
		public static function isPowerOfTwo(value : int) : Boolean
		{
			return value ? ((value & -value) == value) : false;
		}
		
		
		
	}
}