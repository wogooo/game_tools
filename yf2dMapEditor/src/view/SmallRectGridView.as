package view
{
	import com.YFFramework.core.map.rectMap.RectMapConfig;

	/**2012-11-7 下午2:14:59
	 *@author yefeng
	 */
	public class SmallRectGridView extends RectGridView
	{
		private var _width:int;
		private var _height:int
		public function SmallRectGridView(width:int,height:int)
		{
			_width=width;
			_height=height;
			super();
		}
		
		override public function drawGrid():void
		{
			var tileW:int=RectMapConfig.tileW;
			var tileH:int=RectMapConfig.tileH;
			var gridW:int=_width;
			var gridH:int=_height;
			
			var rows:int=gridH/tileH;
			var columns:int=gridW/tileW;
			///画水平线
			var i:int;
			graphics.clear();
			this.graphics.lineStyle(1,0xbbbbbb);
			for(i=0;i<=rows;++i)
			{
				graphics.moveTo(0,i*tileH);
				graphics.lineTo(gridW,i*tileH);
			}
			///垂直线 
			for(i=0;i<=columns;++i)
			{
				graphics.moveTo(i*tileW,0);
				graphics.lineTo(i*tileW,gridH);
			}
			width=gridW;
			height=gridH;
		}
	}
}