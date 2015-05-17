package yf2d.geom
{
	import flash.geom.Point;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-25 上午09:59:10
	 */
	public class Vertex
	{
		public var x:Number;
		public var y:Number;
		
		/**
		 * [x,y]值 在   [-1,1] 之间
		 */		
		public function Vertex(_x:Number=0,_y:Number=0)
		{
			x=_x;
			y=_y;
		}
	}
}