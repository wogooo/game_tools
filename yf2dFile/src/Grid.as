package
{
	/**@author yefeng
	 *20122012-11-17下午9:49:08
	 */
	import com.YFFramework.air.flex.FlexUI;
	
	public class Grid extends FlexUI
	{
		public function Grid()
		{
			super();
			draw()
		}
		private function draw():void
		{
			
			var i:int,j:int;
			graphics.lineStyle(1,0x66FFFF);
			for (i=16;i<=2048;i=i*2) /// row 
			{
				graphics.moveTo(0,i);
				graphics.lineTo(2048,i);
				
			}
			for(j=16;j<=2048;j=j*2)  //colon
			{
				graphics.moveTo(j,0);
				graphics.lineTo(j,2048);
				
			}
			
			graphics.endFill();
			
		}
		
		
		
	}
}