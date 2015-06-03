package com.dolo.ui.controls
{
	import com.dolo.ui.sets.Linkage;

	/** 弹出的小窗口
	 * @author yefeng
	 * 2013 2013-8-8 下午4:47:20 
	 */
	public class PopMiniWindow extends Window
	{
		public function PopMiniWindow()
		{
			super(MiniPopWindowBg);
			_titleYOffset=6;
		}
		/**设置tittle
		 */		
		override protected  function resetTitleBgLinkage():void
		{
			_titleBgLink=Linkage.popMiniWindowTittleBg;
		}
		override protected function resetTittleBgWidth():void
		{
			_tittleBgUI.y=-10;
		}
	}
}