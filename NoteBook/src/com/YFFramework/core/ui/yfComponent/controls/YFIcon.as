package com.YFFramework.core.ui.yfComponent.controls
{
	/** 图标
	 * @author yefeng
	 *2012-8-10下午11:33:39
	 */
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.abs.AbsUIView;
	
	public class YFIcon extends AbsUIView
	{
		public function YFIcon()
		{
			super(false);
		}
		
		public function initData(url:String):void
		{
			var loader:UILoader=new UILoader();
			loader.initData(url,this);
		}
			
		
	}
}