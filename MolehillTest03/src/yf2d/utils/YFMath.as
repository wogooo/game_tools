package yf2d.utils
{
	/**
	 * author :夜枫
	 * 时间 ：2011-11-12 下午03:12:19
	 */
	public final class YFMath
	{
		public function YFMath()
		{
		}
		public static function  DegreeToRadian(degree:Number):Number
		{
			return Math.PI*degree/180;
		}
		public static function RadianToDegree(rad:Number):Number
		{
			return rad*180/Math.PI;
		}
	}
}