package manager.UV
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**@author yefeng
	 *20122012-4-12下午10:32:35
	 */
	public class RectData
	{
		public var x:Number;
		public var y:Number;
		
		public var rect:Rectangle;
		
		public var bitmapData:BitmapData;
		
		public var action:int;
		public var direction:int;
		public var frameIndex:int;
		public var delay:int;
		
		//面积   用于排序
		public var area:int;
		public function RectData()
		{
			rect=new Rectangle();
		}
	}
}