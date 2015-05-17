package com.YFFramework.core.utils.math
{
	/**@author yefeng
	 *2012-8-25下午10:39:52
	 */
	public class YFMath
	{
		public function YFMath()
		{
		}
		
		/**四舍五入保留一位小数
		 */		
		public static  function OneDot(value:Number):Number
		{
			return Number(int((value+0.05)*10)/10);
		}

				/**四舍五入保留两位小数
		 */		
		public static  function TwoDot(value:Number):Number
		{
			return Number(int((value+0.05)*100)/100);
		}

		public static function Round(value:Number):int
		{
			return int(value+0.5);
		}
		
	}
}