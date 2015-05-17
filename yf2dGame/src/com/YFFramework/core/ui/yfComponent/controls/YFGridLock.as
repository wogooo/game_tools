package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**  背包 仓库 等的锁住的格子 
	 * @author yefeng
	 *2012-8-11上午10:35:20
	 */
	public class YFGridLock extends Bitmap
	{
		private static var sourceData:BitmapData;
	
		public function YFGridLock()
		{
			super(null, "auto",true);
			if(!sourceData)
			{
				var style:YFStyle=YFSkin.Instance.getStyle(YFSkin.GridsLock);
				sourceData=style.link as BitmapData;
			}
			bitmapData=sourceData;
		}
	}
}