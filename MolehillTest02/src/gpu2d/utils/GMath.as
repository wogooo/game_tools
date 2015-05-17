package gpu2d.utils
{
	/**
	 * author :夜枫
	 * 时间 ：2011-11-12 下午03:12:19
	 */
	public final class GMath
	{
		public function GMath()
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