package com.YFFramework.game.ui.imageText
{
	import com.YFFramework.core.ui.abs.AbsView;

	/**YFView 对象池 
	 * @author yefeng
	 * 2013 2013-7-15 下午3:30:54 
	 */
	public class YFViewPool
	{
		private static var poolArr:Vector.<AbsView>= new Vector.<AbsView>();
		private static const MaxSize:int=30;
		public function YFViewPool()
		{
		}
		
		public static function getYFView():AbsView
		{
			var view:YFView;
			if(poolArr.length>0)
			{
				view=poolArr.pop();
				view.initFromPool();
			}
			else view=new YFView();
			return view;
		}
		
		/**
		 */
		public static function toYFViewPool(view:YFView):void
		{
			
			if(poolArr.length<MaxSize)
			{
				
				view.disposeToPool();
				poolArr.push(view);
			}
			else view.dispose();
		}

	}
}