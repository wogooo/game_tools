package
{
	import flash.display.BitmapData;
	
	/**2012-7-24 下午12:44:51
	 *@author yefeng
	 */
	public class BitmapDataName extends BitmapData
	{
		public var name:String;
		public function BitmapDataName(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}