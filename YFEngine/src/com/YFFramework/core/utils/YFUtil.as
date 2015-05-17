package com.YFFramework.core.utils
{
	import flash.utils.Dictionary;

	/**
	 * 常用的一些方法放在这个类里面
	 * 2012-10-15 上午11:31:42
	 *@author yefeng
	 */
	public class YFUtil
	{
		public function YFUtil()
		{
		}
		
		/**dictionary转化为数组
		 */		
		public static function DictToArr(dict:Dictionary):Array
		{
			var arr:Array=[];
			for each(var obj:Object in dict)
			{
				arr.push(obj);
			}
			return arr;
		}
	}
}