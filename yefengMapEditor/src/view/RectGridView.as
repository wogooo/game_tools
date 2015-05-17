package view
{
	/**@author yefeng
	 *2012-6-5下午12:35:25
	 */
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.map.rectMap.RectMapConfig;
	import com.YFFramework.core.ui.utils.Draw;
	
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
		
//		public function drawGrid():void
//		{
//			var tileW:int=RectMapConfig.tileW;
//			var tileH:int=RectMapConfig.tileH;
//			var gridW:int=RectMapConfig.gridW;
//			var gridH:int=RectMapConfig.gridH;
//			
//			var rows:int=gridH/tileH;
//			var columns:int=gridW/tileW;
//			///画水平线
//			var i:int;
//			graphics.clear();
//			this.graphics.lineStyle(1,0xbbbbbb);
//			for(i=0;i<=rows;++i)
//			{
//				graphics.moveTo(0,i*tileH);
//				graphics.lineTo(gridW,i*tileH);
//			}
//			///垂直线 
//			for(i=0;i<=columns;++i)
//			{
//				graphics.moveTo(i*tileW,0);
//				graphics.lineTo(i*tileW,gridH);
//			}
//			width=gridW;
//			height=gridH;
//		}
		override public function dispose(e:FlexEvent=null):void
		{
			super.dispose(e);
		}
		
		
		public  function drawGrid ():void
		{
			
			var tileW:int=RectMapConfig.tileW;
			var tileH:int=RectMapConfig.tileH;
			var gridW:int=RectMapConfig.gridW;
			var gridH:int=RectMapConfig.gridH;

			
			var col:int =  Math.round(gridW/ tileW);
			var row:int =  Math.round(gridH / tileH);
			
			var _wHalfTile:int = int(tileW/2);
			var _hHalfTile:int = int(tileH/2); 
			
			var dblMapWidth:int = col*2 + 1;
			var dblMapHeight:int = row * 2 + 1;
			
			RectMapConfig.rows=row*2
			RectMapConfig.columns=col
				
			RectMapConfig.gridW =(RectMapConfig.columns+ 0.5)*tileW
			RectMapConfig.gridH =(row+0.5)*tileH

			
			width=RectMapConfig.gridW;
			height=RectMapConfig.gridH;

			
			///x轴 和YY轴方向都 画 / / 两个方向
			var lineColor:uint=0xbbbbbb;
			graphics.clear();
			//X轴方向的点  / /  方向画线 
			graphics.lineStyle(1, lineColor, 1);
			
			
			for (var i:int = 1; i <= dblMapWidth;i=i+2 )
			{
				/// 画  /   方向的线
				graphics.moveTo(i * _wHalfTile, 0);
				if (dblMapWidth <= dblMapHeight) 
				{
					graphics.lineTo(0, i * _hHalfTile);
				}
				else
				{
					if (i <= dblMapHeight) 
					{
						graphics.lineTo(0,i*_hHalfTile);
					}
					else
					{
						graphics.lineTo((i-dblMapHeight)*_wHalfTile,dblMapHeight*_hHalfTile);
						
					}
				}
				
				//画 /方向的线
				graphics.moveTo(i * _wHalfTile, 0);
				
				if (dblMapWidth <= dblMapHeight) 
				{
					graphics.lineTo(dblMapWidth*_wHalfTile,(dblMapWidth-i)*_hHalfTile)
					
				}
				else
				{
					if (i +dblMapHeight<=dblMapWidth)
					{
						graphics.lineTo((i+dblMapHeight)*_wHalfTile,dblMapHeight*_hHalfTile);
					}
					else
					{
						graphics.lineTo(dblMapWidth*_wHalfTile,(dblMapWidth-i)*_hHalfTile);
					}
				}
			}
			// y轴新方向上的  / /
			
			i = 1;
			for (i; i <= dblMapHeight;i=i+2 ) 
			{
				//    / 方向上
				if (dblMapWidth < dblMapHeight) 
				{
					if(i>dblMapWidth)
					{
						graphics.moveTo(0, i*_hHalfTile);
						graphics.lineTo(dblMapWidth*_wHalfTile,(i-dblMapWidth)*_hHalfTile);
					}
				}
				//     / 方向上 
				graphics.moveTo(0, i * _hHalfTile);
				if (dblMapWidth < dblMapHeight) 
				{
					if (i + dblMapWidth <= dblMapHeight)
					{
						graphics.lineTo(dblMapWidth*_wHalfTile,(i+dblMapWidth)*_hHalfTile);
					}
					else
					{
						graphics.lineTo((dblMapHeight-i)*_wHalfTile,dblMapHeight*_hHalfTile);
					}
				}
				else
				{
					graphics.lineTo((dblMapHeight-i)*_wHalfTile,dblMapHeight*_hHalfTile);
				}
				//end for loop
			}
			//补全最终的未画部分
			var dis:int =Math.abs(dblMapHeight - dblMapWidth);
			//    var num:int = int(dis / 2) * 2;
			var j:int = 2;
			if (dblMapWidth <= dblMapHeight) 
			{
				j=2
				for (j; j <=dblMapWidth ;j=j+2 )
				{
					graphics.moveTo(dblMapWidth * _wHalfTile, (j+dis)*_hHalfTile);
					graphics.lineTo( j*_wHalfTile,dblMapHeight*_hHalfTile);
				}
			}
			else
			{
				j = 2;
				for (j; j <= dblMapHeight;j=j+2 ) 
				{
					
					graphics.moveTo((j+dis)*_wHalfTile,dblMapHeight*_hHalfTile);
					graphics.lineTo(dblMapWidth*_wHalfTile,j*_hHalfTile);
					// end for loop
				}
			}
		}
		///end class
	} 
}