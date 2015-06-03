package com.YFFramework.core.yf2d.display.sprite2D
{
	import flash.display.BitmapData;

	/**低像素图片
	 * @author yefeng
	 * 2013 2013-5-28 下午5:52:40 
	 */
	public class LowMapData
	{
		/**  uv  坐标
		 */		
		public var u:Number;
		public var v:Number;
		/**贴图源
		 */		
		public var bitmapData:BitmapData;
		public function LowMapData()
		{
		}
		public function dispose():void
		{
			bitmapData=null;
		}
			
	}
}