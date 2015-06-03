package com.YFFramework.game.ui.imageText
{
	/**具备对象池功能 的view 可以进行回收
	 * @author yefeng
	 * 2013 2013-7-15 下午3:37:51 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	
	public class YFView extends AbsView
	{
		public function YFView()
		{
			super(false);
		}
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			while(numChildren) removeChildAt(0);
		}
		/**对象池中获取数据重新初始化
		 */		
		public function initFromPool():void
		{
		}
	}
}