package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.ui.movie.BitmapEx;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	
	import flash.display.BitmapData;
	
	/** 移动箭头   小地图上面的 移动箭头
	 * 2012-11-6 上午10:47:23
	 *@author yefeng
	 */
	public class YFSmallMapMoveArrow extends BitmapEx
	{
		private var _direction:int;
		public function YFSmallMapMoveArrow()
		{
			super();
			initUI();
		}
		protected function initUI():void
		{
			var bitmapData:BitmapData=ClassInstance.getInstance("jiantou2") as BitmapData;
			var bitmapDataEx:BitmapDataEx=new BitmapDataEx();
			bitmapDataEx.bitmapData=bitmapData;
			///注册点在中心
			bitmapDataEx.x=-bitmapDataEx.bitmapData.width*0.5;
			bitmapDataEx.y=-bitmapDataEx.bitmapData.height*0.5
			setBitmapDataEx(bitmapDataEx);
		}
		/**所在方向    该资源默认箭头方向是朝上的 
		 */		
		public function set direction(direction:int):void
		{
			_direction=direction;
			var degree:int=DirectionUtil.getDirectionDegree(direction);
//			degree=degree-270; ///减去 资源默认的方向  资源的方向为270
			rotation=degree;
		}
		public function get direction():int
		{
			return _direction;
		}
		
		
	}
}