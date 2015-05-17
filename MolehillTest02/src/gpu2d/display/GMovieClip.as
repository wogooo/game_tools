package gpu2d.display
{
	import flash.display.BitmapData;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-11-22 下午12:27:00
	 */
	public class GMovieClip extends GImage
	{
		/**
		 * @param bmpDataArray  数据源
		 * @param intervalTime  每一张图片进行切换的时间间隔
		 * @param width   显示宽
		 * @param height 显示高
		 */
		public function GMovieClip(bmpDataArray:Vector.<BitmapData>,intervalTime:Number, width:Number, height:Number)
		{
			super(bmpDataArray[0], width, height);
		}
		
		
		
	}
}