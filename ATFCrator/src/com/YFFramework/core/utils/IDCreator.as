package com.YFFramework.core.utils
{
	import com.YFFramework.core.debug.print;

	/**id 生成器
	 * 2012-10-8 下午3:22:25
	 *@author yefeng
	 */
	public class IDCreator
	{
		private static  var _id:int=0;
		public function IDCreator()
		{
		}
		/**  获得唯一id 
		 */		
		public static function getID():int
		{
			_id++;
			return _id
		}
	}
}