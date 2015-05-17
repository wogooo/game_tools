package com.YFFramework.core.ui.movie.data
{
	/**
	 *  @author yefeng
	 *   @time:2012-3-22上午09:38:00
	 */
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BitmapDataEx 
	{
		public var x:int;
		public var y:int;
		public var bitmapData:BitmapData;  
		/**停留的帧数  默认值 为1    表示停留一帧
		 */
		public var  delay:int;
		
		/**在方向序列帧中的位置
		 */
		public var frameIndex:int;
		
		public function BitmapDataEx(width:int=0, height:int=0, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			if(width!=0&&height!=0) bitmapData=new BitmapData(width, height, transparent, fillColor);
			x=0;
			y=0;
			delay=1;
		}
		
		public function dispose():void
		{
			bitmapData.dispose();
			bitmapData=null;
			x=0;
			y=0;
			delay=0;
			frameIndex=0;
		}
		
		
	}
}