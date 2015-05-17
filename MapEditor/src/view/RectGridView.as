package view
{
	/**@author yefeng
	 *2012-6-5下午12:35:25
	 */
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.map.rectMap.RectMapConfig;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	public class RectGridView extends FlexUI
	{
		public function RectGridView()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			mouseChildren=mouseChildren=false;
		}
		
		public function drawGrid():void
		{
			var tileW:int=RectMapConfig.tileW;
			var tileH:int=RectMapConfig.tileH;
			var gridW:int=RectMapConfig.gridW;
			var gridH:int=RectMapConfig.gridH;
			
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
		override public function dispose(e:FlexEvent=null):void
		{
			super.dispose(e);
		}

		
	}
}