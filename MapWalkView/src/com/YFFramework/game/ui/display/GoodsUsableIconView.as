package com.YFFramework.game.ui.display
{
	import com.YFFramework.core.center.manager.dbClick.DBClickManager;
	import com.YFFramework.core.debug.print;

	/**
	 * 可以使用的物品的图标类
	 * 
	 * @author yefeng
	 *2012-8-19下午6:01:45
	 */
	public class GoodsUsableIconView extends GoodsIconView
	{
		public function GoodsUsableIconView()
		{
			super();
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			DBClickManager.Instance.regDBClick(this,dbClickFunc);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			DBClickManager.Instance.delDBClick(this);
		}
		/**双击
		 */		
		protected function dbClickFunc():void
		{
			print(this,"双击...");
		}
		
		
	}
}