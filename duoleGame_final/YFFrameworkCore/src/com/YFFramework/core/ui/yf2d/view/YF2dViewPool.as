package com.YFFramework.core.ui.yf2d.view
{
	/**@author yefeng
	 * 2013 2013-10-25 下午12:23:07 
	 */
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	
	/**影子 倒影容器 对象池
	 */	
	public class YF2dViewPool extends DisplayObjectContainer2D
	{
		private static var _pool:Vector.<YF2dViewPool>=new Vector.<YF2dViewPool>();
		private static const MaxLen:int=50;// 5120*5120大小
		private static var _len:int=0;//当前池里的个数

		public function YF2dViewPool()
		{
			super();
		}
		
		
		
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			removeAllChildren(false);
		}
		
		/**获取tileView
		 */		
		public static function getYF2dViewPool():YF2dViewPool
		{
			var absView:YF2dViewPool;
			if(_len>0)
			{
				absView=_pool.pop();
				_len--;
			}
			else absView=new YF2dViewPool();
			return absView;
		}
		
		/**回收tileView
		 */		
		public static function toTileViewPool(absView:YF2dViewPool):void
		{
			if(_len<MaxLen)
			{
				var index:int=_pool.indexOf(absView);
				if(index==-1)
				{
					absView.disposeToPool();
					_pool.push(absView);
					_len++;
				}
			}
			else absView.dispose();
		}
		/**填满对象池
		 */		
		public static function FillPool():void
		{
			var absView:YF2dViewPool;
			for(var i:int=0;i!=MaxLen;++i)
			{
				absView=new YF2dViewPool();
				_pool.push(absView);
			}
			_len=MaxLen;
		}
		
	}
}