package yf2d.geom
{
	/**
	 * author :夜枫
	 * 时间 ：2011-11-27 下午05:04:54
	 */
	public class ColorData
	{
		public var red:Number;
		public var green:Number;
		public var blue:Number;
		private var _alpha:Number;
		
		public var redOffset:Number;
		public var greenOffset:Number;
		public var blueOffset:Number
		public function ColorData()
		{
			red=1;
			green=1;
			blue=1;
			_alpha=1;
			redOffset=0;
			greenOffset=0;
			blueOffset=0
		}
		
		public function get alpha():Number{	return _alpha;		}
		
		public function set alpha(value:Number):void
		{
			_alpha=red=green=blue=value;
			if(value!=1)
				redOffset=greenOffset=blueOffset=0;
		}
			
			
		
	}
}