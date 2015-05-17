package com.YFFramework.core.ui.yfComponent.controls
{
	/**@author yefeng
	 *2012-8-11上午10:35:03
	 */
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**   放  物品的背景格子    没有锁住 开启的格子 
	 * 取自同一像素源 
	 */	
	public class YFGridOpen extends Bitmap
	{
		///单一像素源
		private static var sourceData:BitmapData;
		public function YFGridOpen()
		{
			super(null, "auto",true);
			if(!sourceData)
			{
				var style:YFStyle=YFSkin.Instance.getStyle(YFSkin.GridsOpen);
				sourceData=style.link as BitmapData;
			}
			bitmapData=sourceData
		}
		
					
	}
}