package gpu2d.display
{
	import flash.display.BitmapData;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-12 下午10:19:59
	 * 显示对象   不具有交互性的 显示对象       具有交互性的是 GImage
	 * 
	 * mouseEnable属性始终为false 
	 */
	public class GShape extends GImage
	{
		public function GShape(bmpData:BitmapData,width:Number,height:Number)
		{
			super(bmpData,width,height);
		}
		override public function get mouseEnable():Boolean
		{
			return false
		}
	
	}
}