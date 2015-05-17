package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 元宝图标 常驻游戏内存 不用释放  2012-8-13 下午1:09:13
	 *@author yefeng
	 */
	public class YFIConYuanbao extends YFComponent
	{
		public function YFIConYuanbao(autoRemove:Boolean=false)
		{
			super(autoRemove);
		}
		
		override protected function initUI():void
		{
			// TODO Auto Generated method stub
			super.initUI();
			_style=YFSkin.Instance.getStyle(YFSkin.YFMoneyYuanbao);
			var data:BitmapData=_style.link as BitmapData;
			addChild(new Bitmap(data));
		}
		
	}
}